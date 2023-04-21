

import 'package:flutter/material.dart';

class RecepeUtils {

  static void showIngredientsBottomSheet(BuildContext context, recipe) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  recipe['label'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ingredients:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                ...List.generate(recipe['ingredientLines'].length, (index) {
                  return Text(
                    '- ${recipe['ingredientLines'][index]}',
                    style: TextStyle(fontSize: 16),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}