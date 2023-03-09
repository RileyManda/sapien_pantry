import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sapienpantry/model/item.dart';
import 'package:sapienpantry/utils/constants.dart';

class ItemController extends GetxController {
  static ItemController instance = Get.find();
  addItem(String itemText, String time, int date) async {
    try {
      final ref = firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('items')
          .doc();
      final item = Item(
          id: ref.id, text: itemText, isDone: false, time: time, date: date);
      await ref.set(item.toMap());
    } catch (e) {
      debugPrint('Something went wrong(Add): $e');
    }
  }

  updateItem(String id, Item item) async {
    try {
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('items')
          .doc(id)
          .update(item.toMap());
    } catch (e) {
      debugPrint('Something went wrong(Update): $e');
    }
  }

  deleteItem(String id) async {
    try {
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('items')
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
          .collection('items')
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
