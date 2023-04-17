import 'package:flutter/material.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/services/pantry_service.dart';

class PantryUtils {
  static void showMoreDetails(BuildContext context, Pantry pantry) {
    final textController = TextEditingController(text: pantry.text);
    final categoryController = TextEditingController(text: pantry.category);
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
