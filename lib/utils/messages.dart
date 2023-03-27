
import 'package:flutter/material.dart';

void showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Feature coming soon'),
    backgroundColor: Colors.grey,
  ));
}

void showOurFault(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Something went wrong: Our server is sleepy,'),
    backgroundColor: Colors.amberAccent,
  ));
}
void showIsAdded(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item added to Pantry'),
    backgroundColor: Colors.green,
  ));
}

void showIsDone(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item has run out'),
    backgroundColor: Colors.orangeAccent,
  ));
}


void showItemAdded(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item added to Pantry'),
    backgroundColor: Colors.orangeAccent,
  ));
}

void showItemFinished(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item has run out & added to shopping list'),
    backgroundColor: Colors.orangeAccent,
  ));
}


void noItemsShopping(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('No Items found in your Shopping List'),
    backgroundColor: Colors.orangeAccent,
  ));
}

void emptyPantry(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Your Pantry is Empty'),
    backgroundColor: Colors.orangeAccent,
  ));
}

void itemPurchased(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item purchased & added to Pantry'),
    backgroundColor: Colors.orangeAccent,
  ));
}



