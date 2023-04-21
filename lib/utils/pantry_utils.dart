import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/services/pantry_service.dart';
import 'helper.dart';
import 'messages.dart';

class PantryUtils {
  static PantryService _pantryService = PantryService();
  static TextEditingController textController = TextEditingController();
  static TextEditingController categoryController = TextEditingController();
  static TextEditingController expiryDateController = TextEditingController();
  static TextEditingController quantityController = TextEditingController();
  static TextEditingController notesController = TextEditingController();
  static int quantity = int.tryParse(quantityController.text) ?? 0; // use 0 as default value if text can't be parsed

  static final ScrollController _scrollController = ScrollController();
  static ScrollController get scrollController => _scrollController;
  static bool isSearching = false;
  static bool isVisible = true;
  static String time = '';


  static void showItemInput(BuildContext context, {required Function() setStateCallback, BuildContext? parentContext, Pantry? pantry}) async {
    String time = TimeOfDay.now().format(context);
    DateTime selectedDate = DateTime.now();
    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2019, 1),
          lastDate: DateTime(2111));
      if (picked != null ){
        setStateCallback();
        selectedDate = picked;
      }
    }

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:Text(pantry == null ? 'Add Item to Pantry' : 'Update Item'),
          content: SingleChildScrollView(
            child: Column(
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
                TextFormField(
                  controller: quantityController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Quantity',
                    labelText: 'Quantity',
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

                    onPressed: () => _selectDate(context),
                  child: Text("Expiry Date:${selectedDate.toLocal()}"),
                ),
                const SizedBox(
                  height: 5,
                ),
                OutlinedButton(
                  onPressed: () async {
                    final newTime = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    if (newTime != null) {
                      setStateCallback(); // call the setState method of the parent widget
                      time = newTime.format(context);
                    }
                  },
                  child: Text('Time : $time'),
                ),

                TextFormField(
                  controller: notesController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Notes',
                    labelText: 'Notes',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (pantry != null)
              TextButton.icon(
                  onPressed: () {
                    _pantryService.deleteFromPantry(pantry.id);
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
                textController.text.trim();
                categoryController.text.trim();
                quantityController.text.trim();
                notesController.text.trim();
                if (textController.text.isEmpty) {
                  return;
                }
             else {
                  _pantryService.addToPantry(
                    textController.text,
                    categoryController.text,
                    time,
                    getDateTimestamp(DateTime.now()),
                    int.tryParse(quantityController.text) ?? 0,
                    selectedDate.toIso8601String(),
                    notesController.text,
                  );
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
  static void showMoreDetails(BuildContext context, Pantry pantry) {
    textController.text = pantry.text;
    categoryController.text = pantry.category;
    final TextEditingController expiryDateController = TextEditingController(text: pantry.expiryDate?.toIso8601String() ?? '');
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    pantry.text,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: textController,
                            decoration: const InputDecoration(
                              labelText: 'Item name',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            controller: categoryController,
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          OutlinedButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: pantry.expiryDate ?? DateTime.now(),
                                firstDate: DateTime(2019, 1),
                                lastDate: DateTime(2111),
                              );
                              if (picked != null) {
                                expiryDateController.text =
                                    picked.toIso8601String();
                              }
                            },
                            child: Text('Expiry date: ${expiryDateController.text}'),
                          ),


                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: quantityController,
                            decoration: InputDecoration(
                              labelText: 'Quantity',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          TextFormField(
                            controller: notesController,
                            decoration: const InputDecoration(
                              labelText: 'Notes',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            children: [
                              if (pantry != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: TextButton.icon(
                                    onPressed: () {
                                      _pantryService.deleteFromPantry(pantry.id);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    ),
                                    label: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    textController.text.trim();
                                    categoryController.text.trim();
                                    quantityController.text.trim();
                                    notesController.text.trim();
                                    if (textController.text.isEmpty) {
                                      return;
                                    }
                                    if (pantry != null) {
                                      try {
                                        _pantryService.updatePantry(
                                            pantry.id,
                                            pantry.copyWith(
                                                text: textController.text,
                                                category: categoryController.text,
                                                time: time,
                                                expiryDate: DateTime.tryParse(expiryDateController.text),
                                                quantity: int.tryParse(quantityController.text),
                                                notes: notesController.text
                                            ),
                                            context
                                        );
                                      } catch (e) {
                                        // handle the exception
                                      }

                                    }

                                    Navigator.pop(context);
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.save),
                                      SizedBox(width: 8.0),
                                      Text('Update'),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Cancel and close modal
                                    Navigator.pop(context); // Close the bottom sheet
                                  },
                                  child: Text('Cancel'),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 8,
      backgroundColor: Colors.white,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).padding.top -
            MediaQuery.of(context).padding.bottom,
      ),
    );
  }
}
