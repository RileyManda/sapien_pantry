import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sapienpantry/model/item.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/view/end_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
        title: const Text('Item List'),
      ),
      endDrawer: const EndDrawer(),
      body: Container(
        color: Colors.grey.shade100,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: firestore
                .collection('users')
                .doc(authController.user!.uid)
                .collection('items')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final itemList =
                  snapshot.data!.docs.map((e) => Item.fromMap(e)).toList();

              return GroupedListView(
                order: GroupedListOrder.DESC,
                elements: itemList,
                groupBy: (Item item) => item.date,
                groupHeaderBuilder: (Item item) => Padding(
                  padding: const EdgeInsets.all(10.0).copyWith(left: 20),
                  child: Text(
                    getFormattedDate(item.date).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ),
                itemBuilder: (context, Item item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: InkWell(
                      onTap: () {
                        textController.text = item.text;
                        time = item.time;
                        showItemInput(context, item: item);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              left: BorderSide(
                            color: getLabelColor(item.date),
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
                          opacity: item.isDone ? 0.4 : 1.0,
                          duration: const Duration(milliseconds: 100),
                          child: Row(
                            children: [
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Text(
                                  item.text,
                                  style: const TextStyle(fontSize: 18),
                                ),
                              )),
                              Text(
                                item.time,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              InkWell(
                                  onTap: () {
                                    itemController.updateItem(item.id,
                                        item.copyWith(isDone: !item.isDone));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4)
                                        .copyWith(right: 14),
                                    child: Icon(
                                      item.isDone
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
      floatingActionButton: FloatingActionButton(
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
    );
  }

  showItemInput(BuildContext context, {Item? item}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(item == null ? 'Add Item' : 'Update Item'),
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
                if (item != null)
                  TextButton.icon(
                      onPressed: () {
                        itemController.deleteItem(item.id);
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
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
                    if (item != null) {
                      itemController.updateItem(item.id,
                          item.copyWith(text: textController.text, time: time));
                    } else {
                      itemController.addItem(textController.text, time,
                          getDateTimestamp(DateTime.now()));
                    }
                    Navigator.pop(context);
                  },
                  child: Text(item == null ? 'Add Item' : 'Update Item'),
                )
              ],
            ));
  }
}
