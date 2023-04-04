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


  // addToPantry(String itemText, String itemCategory, String time, int date) async {
  //   try {
  //     final categoryRef = firestore
  //         .collection('users')
  //         .doc(authController.user!.uid)
  //         .collection('categories')
  //         .doc();
  //
  //     final category = Category(
  //       id: categoryRef.id,
  //       category: itemCategory,
  //     );
  //     await categoryRef.set(category.toMap());
  //
  //     final pantryRef = firestore
  //         .collection('users')
  //         .doc(authController.user!.uid)
  //         .collection('pantry')
  //         .doc();
  //
  //     final pantry = Pantry(
  //       id: pantryRef.id,
  //       text: itemText,
  //       category: itemCategory,
  //       catId:categoryRef.id,
  //       isDone: false,
  //       time: time,
  //       date: date,
  //     );
  //
  //     await pantryRef.set(pantry.toMap());
  //   } catch (e) {
  //     debugPrint('Something went wrong(Add): $e');
  //   }
  // }

  // addCategory(String category) async {
  //   final categoryRef = FirebaseFirestore.instance.collection('categories');
  //   await categoryRef.add({'category': category});
  // }


  // addtoPantry(String itemText,String itemCategory, String time, int date) async {
  //   try {
  //     // Check if the category document already exists
  //     final categoryRef = firestore
  //         .collection('users')
  //         .doc(authController.user!.uid)
  //         .collection('categories')
  //         .doc(itemCategory);
  //     final categorySnapshot = await categoryRef.get();
  //     if (!categorySnapshot.exists) {
  //       // If the category document does not exist, create it
  //       final category = Pantry(category: itemCategory);
  //       await categoryRef.set(category.toMap());
  //     }
  //     // Create the pantry item document
  //     final pantryRef = firestore
  //         .collection('users')
  //         .doc(authController.user!.uid)
  //         .collection('pantry')
  //         .doc();
  //     final pantry = Pantry(
  //         id: pantryRef.id, text: itemText,category: itemCategory, isDone: false, time: time, date: date);
  //     await pantryRef.set(pantry.toMap());
  //   } catch (e) {
  //     debugPrint('Something went wrong(Add): $e');
  //   }
  // }


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



// addToShopping(String itemText,String itemCategory, String time, int date) async {
//   try {
//     final ref = firestore
//         .collection('users')
//         .doc(authController.user!.uid)
//         .collection('shoppinglist')
//         .doc();
//     final pantry = Pantry(
//         id: ref.id, text: itemText,category: itemCategory, isDone: false, time: time, date: date);
//     await ref.set(pantry.toMap());
//   } catch (e) {
//     debugPrint('Something went wrong(Add): $e');
//   }
// }

updateShoppingList(String id, Shopping shopping) async {
  try {
    await firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('shoppinglist')
        .doc(id)
        .update(shopping.toMap());
  } catch (e) {
    debugPrint('Something went wrong(Update): $e');
  }
}

deleteFromShopping(String id) async {
  try {
    await firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('shoppinglist')
        .doc(id)
        .delete();
  } catch (e) {
    debugPrint('Something went wrong(Delete): $e');
  }
}

deleteAllShopping() {
  try {
    WriteBatch batch = firestore.batch();
    return firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('shoppinglist')
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
  getDoneItems(String id, Shopping shopping) async {
    try {
      firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .where('isDone', isEqualTo: true)
          .snapshots();
    } catch (e) {
      debugPrint('Something went wrong(Update): $e');
    }
  }

}
