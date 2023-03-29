import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/utils/messages.dart';

import '../model/category.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);
  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  String time = '';
  late Category category;

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(4),
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
          crossAxisCount: 3,
          children: [
            GestureDetector(
              onTap: () {
                showComingSoon(context);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.emoji_food_beverage,
                      color: Colors.white, size: 24),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showComingSoon(context);
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.fastfood, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),

      //animated float
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        FloatingActionButton(
          mini: true,
          backgroundColor: Colors.red,
          onPressed: () async {
            await addNewCategory(context).then((value) {
              textController.clear();
            });
          },
          child: const Icon(Icons.add),
        ),
      ]),
    );
  }

  addNewCategory(BuildContext context, {Pantry? pantry}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                  pantry == null ? 'Feature Coming Soon' : 'Update Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: 'Category Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5))),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      showComingSoon(context);
                    },
                    child: Text('Time : $time'),
                  ),
                ],
              ),
              actions: [
                if (pantry != null)
                  TextButton.icon(
                      onPressed: () {
                        null;
                        // pantryController.deleteFromPantry(pantry.id);
                        // Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.grey,
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
                    null;
                    // if (textController.text.isEmpty) {
                    //   return;
                    // }
                    // if (pantry != null) {
                    //   pantryController.updatePantry(
                    //       pantry.id,
                    //       pantry.copyWith(
                    //           text: textController.text, time: time));
                    // } else {
                    //   pantryController.addtoPantry(textController.text, time,
                    //       getDateTimestamp(DateTime.now()));
                    //   itemAdded();
                    // }
                    // Navigator.pop(context);
                  },
                  child: Text(pantry == null ? 'Create' : 'Update'),
                )
              ],
            ));
  }
}
