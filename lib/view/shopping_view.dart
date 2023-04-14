import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/model/shopping.dart';
import '../services/pantry_service.dart';
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
  final PantryService _pantryService = PantryService();
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
            stream:_pantryService.getShoppingList(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null || snapshot.data!.size == 0) {
                return const Center(
                  child: Text('Your shopping List is empty'),
                );
              }
              final shoppingList =
                  snapshot.data!.docs.map((e) => Pantry.fromMap(e)).toList();

              return GroupedListView(
                semanticChildCount: shoppingList.length,
                sort: true,
                order: GroupedListOrder.ASC,
                elements: shoppingList,
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
                        textController.text = pantry.category;
                        time = pantry.time;
                        // createShoppingList(context, pantry: pantry);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              right: BorderSide(
                            color: getCatColorForCategory(pantry.id),
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
                                    pantry.category,
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
                                    if (pantry.isDone) {
                                      itemPurchased(context);
                                    } else {
                                      // itemPurchased(context);
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
}
