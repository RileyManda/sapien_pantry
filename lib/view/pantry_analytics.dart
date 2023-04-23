import 'package:flutter/material.dart';
import 'package:sapienpantry/utils/constants.dart';
import '../model/pantry.dart';

class PantryAnalytics extends StatelessWidget {
  final List<Pantry> pantryList;

  const PantryAnalytics({Key? key, required this.pantryList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalItems = pantryList.length;
    int doneItems = pantryList.where((pantry) => pantry.isDone).length;
    int notDoneItems = pantryList.where((pantry) => !pantry.isDone).length;

    double doneProgress = doneItems > 0 ? doneItems / totalItems : 0.0;
    double notDoneProgress = notDoneItems > 0 ? notDoneItems / totalItems : 0.0;

    return Column(
      children: [

        SizedBox(
          height: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pantry',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              LinearProgressIndicator(
                value: notDoneProgress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ShoppingList',// Done Items Progress
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              LinearProgressIndicator(
                value: doneProgress,
                backgroundColor: Colors.grey.shade300,
                color: Colors.red,

              ),
            ],
          ),
        ),


      ],
    );
  }
}











