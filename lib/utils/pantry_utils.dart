import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/services/pantry_service.dart';
import 'package:flutter/services.dart';

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
  String expiryDate = expiryDateController.text;


  static void showItemInput(BuildContext context, {required Function() setStateCallback, BuildContext? parentContext, Pantry? pantry}) async {
    String time = TimeOfDay.now().format(context);
    DateTime expiryDate = DateTime.now();
    String formattedExpiryDate = DateFormat.yMMMMEEEEd().add_jm().format(expiryDate);
    Future<void> showDatePickerDialog() async {
      final newDate = await showDatePicker(
        context: context,
        initialDate: expiryDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (newDate != null) {
        setStateCallback();
        expiryDate = newDate;
        formattedExpiryDate = DateFormat.yMMMMEEEEd().add_jm().format(expiryDate);
      }
    }
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:
          Text(pantry == null ? 'Add Item to Pantry' : 'Update Item'),
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
                  onPressed: showDatePickerDialog,
                  child: Text('ExpiryDate : $expiryDate'),
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
                expiryDateController.text.trim();
                quantityController.text.trim();
                notesController.text.trim();
                if (textController.text.isEmpty) {
                  return;
                }
                if (pantry != null) {
                  _pantryService.updatePantry(
                      pantry.id,
                      pantry.copyWith(
                          text: textController.text,
                          category: categoryController.text,
                          time: time,
                          expiryDate: expiryDateController.text,
                        quantity: int.tryParse(quantityController.text),
                        notes: notesController.text));
                } else {
                  _pantryService.addToPantry(
                      textController.text,
                      categoryController.text,
                      time,
                      getDateTimestamp(DateTime.now()),
                    int.tryParse(quantityController.text) ?? 0,
                    expiryDateController.text,
                    notesController.text,);
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
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: textController,
                          decoration: InputDecoration(
                            labelText: 'Item name',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: categoryController,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            // Update the pantry item with the new values
                            final updatedPantry = pantry.copyWith(
                              text: textController.text,
                              category: categoryController.text,
                            );
                            PantryService().updatePantry(
                              pantry.id, // Pass the pantry item's id
                              updatedPantry,
                            );
                            Navigator.pop(context); // Close the bottom sheet
                          },
                          child: Text('Update'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
