import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sapienpantry/model/shopping.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/view/search_view.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);
  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  String time = '';

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          // Navigate to the Search Screen
          IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const SearchPage())),
              icon: const Icon(Icons.search))
        ],
      ),

      body: Container(
        color: Colors.grey.shade100,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore
                .collection('users')
                .doc(authController.user!.uid)
                .collection('shoppinglist')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final shoppingList =
                  snapshot.data!.docs.map((e) => Shopping.fromMap(e)).toList();

              return GroupedListView(
                order: GroupedListOrder.ASC,
                elements: shoppingList,
                useStickyGroupSeparators: true,
                groupBy: (Shopping shopping) => shopping.text,
                groupHeaderBuilder: (Shopping shopping) => Padding(
                  padding: const EdgeInsets.all(10.0).copyWith(left: 20),
                  child: Text(
                    getFormattedDate(shopping.date).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ),
                itemBuilder: (context, Shopping shopping) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        textController.text = shopping.text;
                        time = shopping.time;
                        showItemInput(context, shopping: shopping);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              right: BorderSide(
                            color: getLabelColor(shopping.date),
                            width: 10,
                          )),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(4, 4),
                              blurRadius: 2.0,
                              color: Colors.black12,
                            ),
                          ],
                        ),
                        child: AnimatedOpacity(
                          opacity: shopping.isDone ? 0.4 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  shopping.text,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )),
                              Text(
                                shopping.time,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                  onTap: () {
                                    pantryController.updateShoppingList(
                                        shopping.id,
                                        shopping.copyWith(
                                            isDone: !shopping.isDone));

                                    if (!shopping.isDone) {
                                      showIsDone();
                                    } else {
                                      showIsAdded();
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4)
                                        .copyWith(right: 14),
                                    child: Icon(
                                      shopping.isDone
                                          ? Icons.shopping_cart
                                          : Icons.remove_shopping_cart_outlined,
                                      size: 28,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),

      // animated float end
    );
  }

  showItemInput(BuildContext context, {Shopping? shopping}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(shopping == null ? 'Add Item' : 'Update Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final newTime = await showTimePicker(
                          context: context, initialTime: TimeOfDay.now());
                      if (newTime != null) {
                        setState(() {
                          time = newTime.format(context);
                        });
                      }
                    },
                    child: Text('Time : $time'),
                  ),
                ],
              ),
              actions: [
                if (shopping != null)
                  TextButton.icon(
                      onPressed: () {
                        pantryController.deleteFromShopping(shopping.id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.black54),
                      )),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel')),
                ElevatedButton(
                  onPressed: () {
                    if (textController.text.isEmpty) {
                      return;
                    }
                    if (shopping != null) {
                      pantryController.updateShoppingList(
                          shopping.id,
                          shopping.copyWith(
                              text: textController.text, time: time));
                    } else {
                      pantryController.addToShopping(textController.text, time,
                          getDateTimestamp(DateTime.now()));
                      showIsAdded();
                    }
                    Navigator.pop(context);
                  },
                  child: Text(shopping == null ? 'Add Item' : 'Update'),
                )
              ],
            ));
  }

  showIsDone() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Item purchased'),
      backgroundColor: Colors.lightGreen,
    ));
  }

  showIsAdded() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Item added to Pantry'),
      backgroundColor: Colors.green,
    ));
  }

  showOurFault() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Something went wrong:Its our fault,'),
      backgroundColor: Colors.amberAccent,
    ));
  }

  comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Feature coming soon'),
      backgroundColor: Colors.grey,
    ));
  }
}
