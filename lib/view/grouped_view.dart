import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/model/shopping.dart';
import 'package:sapienpantry/utils/messages.dart';
import '../services/pantry_service.dart';

class GroupItemView extends StatefulWidget {
  final String categoryId;
  final String category;
  final Color categoryColor;

  const GroupItemView({
    Key? key,
    required this.categoryId,
    required this.category,
    required this.categoryColor,
  }) : super(key: key);
  @override
  State<GroupItemView> createState() => _GroupItemViewState();
}

class _GroupItemViewState extends State<GroupItemView>
    with SingleTickerProviderStateMixin {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _itemsStream;
  final PantryService _pantryService = PantryService();
  final textController = TextEditingController();
  final categoryController = TextEditingController();
  String time = '';
  late Shopping shopping;
  final _scrollController = ScrollController();
  bool _isVisible = true;

  @override
  initState() {
    super.initState();
    _itemsStream = getItemsStream(widget.categoryId);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    categoryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getItemsStream(
      String categoryId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry')
        .where('catId', isEqualTo: categoryId)
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: categoryColors[widget.categoryId],
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: getItemsStream(widget.categoryId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.data == null || snapshot.data!.size == 0) {
                return const Center(
                  child: Text('This Category is Empty:You can still add + items'),
                );
              }

              final itemList =
                  snapshot.data!.docs.map((e) => Pantry.fromMap(e)).toList();
              itemList.sort((a, b) =>
                  a.text.compareTo(b.text)); // Sorts the list alphabetically
              return GroupedListView(
                controller: _scrollController,
                semanticChildCount: itemList.length,
                sort: true,
                order: GroupedListOrder.ASC,
                elements: itemList,
                useStickyGroupSeparators: true,
                groupBy: (Pantry pantry) => pantry.category,
                groupHeaderBuilder: (Pantry pantry) => Padding(
                  padding: const EdgeInsets.all(10.0).copyWith(left: 20),
                  child: Text(
                    getFormattedDate(pantry.date).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
                itemBuilder: (context, Pantry pantry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        textController.text = pantry.text;
                        categoryController.text = pantry.category;
                        time = pantry.time;
                        showItemInput(context, pantry: pantry);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              right: BorderSide(
                                color: getCatColorForCategory(pantry.catId),

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
                              )),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  pantry.category,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )),
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
                                      showItemFinished(context);
                                    } else {
                                      showItemAdded(context);
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
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
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
      floatingActionButton: _isVisible
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                mini: false,
                onPressed: () async {
                  setState(() {
                    time = TimeOfDay.now().format(context);
                  });
                  await showItemInput(context).then((value) {
                    textController.clear();
                  });
                },
                child: const Icon(Icons.add),
              ),
            ])
          : null,
    );
  }

  showItemInput(BuildContext context, {Pantry? pantry}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title:
                  Text(pantry == null ? 'Add Item to Pantry' : 'Update Item'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: textController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Item Name',
                      labelText: 'Item Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an item name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: categoryController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Category',
                      labelText: 'Category',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
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
                    if (pantry != null) {
                      pantryController.updatePantry(
                          pantry.id,
                          pantry.copyWith(
                              text: textController.text,
                              category: categoryController.text,
                              time: time));
                    } else {
                      _pantryService.addToPantry(
                          textController.text,
                          categoryController.text,
                          time,
                          getDateTimestamp(DateTime.now()));
                      showItemAdded(context);
                    }
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.save),
                      const SizedBox(width: 8.0),
                      Text(pantry == null ? 'Add' : 'Update'),
                    ],
                  ),
                )
              ],
            ));
  }
}
