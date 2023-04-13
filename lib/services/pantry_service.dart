import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../model/category.dart';
import '../model/pantry.dart';

class PantryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = AuthController();

  Stream<List<Pantry>> get pantryList {
    return _pantryCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Pantry.fromMap(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
    });
  }
  CollectionReference get _pantryCollection {
    return firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry');
  }

  Future<void> addToPantry(
      String itemText, String itemCategory, String time, int date) async {
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



  Future<void> updatePantry(String id, Pantry pantry) async {
    try {
      // Update pantry collection
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .doc(id)
          .update({
        'text': pantry.text,
        'category': pantry.category,
        'date': pantry.date,
        'time': pantry.time,
        'isDone': pantry.isDone,
      });

      // Update categories collection
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('categories')
          .doc(pantry.catId)
          .update({
        'category': pantry.category,
      });
    } catch (e) {
      debugPrint('Something went wrong(Update): $e');
    }
  }




  Future<void> deleteFromPantry(String id) async {
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

  Future<void> deleteCompleted() async {
    try {
      WriteBatch batch = firestore.batch();
      final querySnapshot = await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .where('isDone', isEqualTo: true)
          .get();
      for (var document in querySnapshot.docs) {
        batch.delete(document.reference);
      }
      await batch.commit();
    } catch (e) {
      debugPrint('Something went wrong(Batch Delete): $e');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getShoppingList() {
    return firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry')
        .where('isDone', isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategories() {
    return firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('categories')
        .snapshots();
  }


  Stream<List<Pantry>> streamPantryList() async* {
    final collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry');
    await for (final querySnapshot in collectionRef.snapshots()) {
      final pantryList =
      querySnapshot.docs.map((doc) => Pantry.fromMap(doc)).toList();
      yield pantryList;
    }
  }


  Stream<int> itemsDoneStream(String pantryId) {
    return firestore
        .collection('pantries')
        .doc(pantryId)
        .collection('items')
        .where('isDone', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }




}
