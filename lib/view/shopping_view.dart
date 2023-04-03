import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/model/shopping.dart';

import '../utils/messages.dart';

class ShoppingView extends StatefulWidget {
  const ShoppingView({Key? key}) : super(key: key);
  @override
  State<ShoppingView> createState() => _ShoppingViewState();
}

class _ShoppingViewState extends State<ShoppingView>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  final categoryController = TextEditingController();
  String time = '';
  late Shopping shopping;
  int shopping_notification = 0;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    // catController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore
                .collection('users')
                .doc(authController.user!.uid)
                .collection('pantry')
                .where('isDone', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Stack(
                  children: const [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Center(
                      child: Text('Loading...'),
                    ),
                  ],
                );
              } else if (snapshot.data == null || snapshot.data!.size == 0) {
                Future.microtask(() => noItemsShopping(context));
              }
              final pantryList =
                  snapshot.data!.docs.map((e) => Pantry.fromMap(e)).toList();

              return GroupedListView(
                semanticChildCount: pantryList.length,
                sort: true,
                order: GroupedListOrder.ASC,
                elements: pantryList,
                useStickyGroupSeparators: true,
                groupBy: (Pantry pantry) => pantry.time,
                groupHeaderBuilder: (Pantry pantry) => Padding(
                  padding: const EdgeInsets.all(10.0).copyWith(left: 20),
                  child: Text(
                    getFormattedDate(pantry.date).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ),
                itemBuilder: (context, Pantry pantry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        textController.text = pantry.text;
                        textController.text = pantry.category ?? '';
                        time = pantry.time;
                        createShoppingList(context, pantry: pantry);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              right: BorderSide(
                            color: getLabelColor(pantry.date),
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
                          opacity: pantry.isDone ? 0.4 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    pantry.text,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    pantry.category ?? '',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              Text(
                                pantry.time,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                  onTap: () {
                                    pantryController.updatePantry(
                                        pantry.id,
                                        pantry.copyWith(
                                            isDone: !pantry.isDone));
                                    if (!pantry.isDone) {
                                      pantryController.addToShopping(
                                          textController.text,
                                          textController.text,
                                          time,
                                          getDateTimestamp(DateTime.now()));
                                      // ignore: todo
                                      //TODO: update shopping list notifications badge on dashboard
                                    } else {
                                      itemPurchased(context);
                                      setState(() {
                                        !pantry.isDone;
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4)
                                        .copyWith(right: 14),
                                    child: Icon(
                                      pantry.isDone
                                          ? Icons.add_shopping_cart_rounded
                                          : Icons.shopping_cart_sharp,
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
    );
  }

  createShoppingList(BuildContext context, {Pantry? pantry}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(pantry == null ? 'Add to Shopping List' : 'Update'),
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
                  TextField(
                    // controller: catController,
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
                if (pantry != null)
                  TextButton.icon(
                      onPressed: () {
                        pantryController.deleteFromPantry(pantry.id);
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
                    // if (category.isEmpty) {
                    //   return;
                    // }
                    if (pantry != null) {
                      pantryController.updatePantry(
                          pantry.id,
                          pantry.copyWith(
                              text: textController.text,
                              category: textController.text,
                              time: time));
                    } else {
                      pantryController.addToPantry(
                          textController.text,
                          textController.text,
                          time,
                          getDateTimestamp(DateTime.now()));
                      itemPurchased(context);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(pantry == null ? 'Add Item' : 'Update'),
                )
              ],
            ));
  }
}
