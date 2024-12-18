import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/model/shopping.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/model/category.dart';

import '../model/pantry.dart';

class PantryController extends GetxController {
  static PantryController instance = Get.find();

  addToPantry(String itemText, String itemCategory, String time, int date) async {
    try {
      final categorySnapshot = await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('categories')
          .where('category', isEqualTo: itemCategory)
          .get();

      String categoryId;
      if (categorySnapshot.docs.isNotEmpty) {
        categoryId = categorySnapshot.docs.first.id;
      } else {
        final categoryRef = firestore
            .collection('users')
            .doc(authController.user!.uid)
            .collection('categories')
            .doc();

        final category = Category(
          id: categoryRef.id,
          category: itemCategory,
        );
        await categoryRef.set(category.toMap());

        categoryId = categoryRef.id;
      }

      final pantryRef = firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .doc();

      final pantry = Pantry(
        id: pantryRef.id,
        text: itemText,
        category: itemCategory,
        catId: categoryId,
        isDone: false,
        time: time,
        date: date,
      );

      await pantryRef.set(pantry.toMap());
    } catch (e) {
      debugPrint('Something went wrong(Add): $e');
    }
  }

  updatePantry(String id, Pantry pantry) async {
    try {
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .doc(id)
          .update(pantry.toMap());
    } catch (e) {
      debugPrint('Something went wrong(Update): $e');
    }
  }

  deleteFromPantry(String id) async {
    try {
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .doc(id)
          .delete();
    } catch (e) {
      debugPrint('Something went wrong(Delete): $e');
    }
  }

  deleteCompleted() {
    try {
      WriteBatch batch = firestore.batch();
      return firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .where('isDone', isEqualTo: true)
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          batch.delete(document.reference);
        }
        return batch.commit();
      });
    } catch (e) {
      debugPrint('Something went wrong(Batch Delete): $e');
    }
  }


}
