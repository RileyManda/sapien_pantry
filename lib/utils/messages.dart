
import 'package:flutter/material.dart';
import 'package:sapienpantry/model/pantry.dart';

import 'constants.dart';

void showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Feature coming soon'),
    backgroundColor: pPrimaryColor,
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

void showItemAdded(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item added to Pantry'),
    backgroundColor: itemAddedColor,
  ));
}

void showItemFinished(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item has run out & added to shopping list'),
    backgroundColor: Colors.sapienshoptheme,
  ));
}


void noItemsShopping(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('No Items found in your Shopping List'),
    backgroundColor: Colors.grey,
  ));
}

void emptyPantry(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Your Pantry is Empty'),
    backgroundColor: Colors.grey,
  ));
}

void noCategories(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('You have not created any categories '),
    backgroundColor: Colors.grey,
  ));
}

void itemPurchased(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Item purchased & added to Pantry'),
    backgroundColor: Colors.green,
  ));
}

// wifi connection checks:
void showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 5),
    ),
  );
}
void showIsConnected(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 3),
    ),
  );
}
void deleteCompleted(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Items deleted successfully'),
    backgroundColor: Colors.orangeAccent,
  ));
}

void updateFailed(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Update failed-Please try again'),
    backgroundColor: Colors.orangeAccent,
  ));
}

void resetEmailSent(BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(
    content: Text('A password reset link has been sent to your email'),
    backgroundColor: pPrimaryColor,
    duration: Duration(seconds: 5),
  ));
}

void resetEmailFailed(BuildContext context) {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(
    content: Text('Failed to reset password'),
    backgroundColor: Colors.deepOrange,
    duration: Duration(seconds: 5),
  ));
}







