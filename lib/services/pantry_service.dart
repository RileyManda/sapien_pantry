import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../controller/auth_controller.dart';
import '../model/category.dart';
import '../model/pantry.dart';
import 'dart:core';
import '../utils/messages.dart';

class PantryService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final AuthController authController = AuthController();
  static TextEditingController expiryDateController = TextEditingController();
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
      String itemText, String itemCategory,String time, int date,int quantity,String expiryDate,String notes) async {
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
        quantity: quantity,
        expiryDate: DateTime.parse(expiryDate),
        notes: notes,
      );

      await pantryRef.set(pantry.toMap());
    } catch (e) {
      debugPrint('Something went wrong(Add): $e');
    }
  }

  Future<void> updatePantry(String id, Pantry pantry, BuildContext context) async {
    try {
      // Update pantry collection
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('pantry')
          .doc(id)
          .update(pantry.toMap());

      // Update categories collection
      await firestore
          .collection('users')
          .doc(authController.user!.uid)
          .collection('categories')
          .doc(pantry.catId)
          .update({'category': pantry.category});
    } catch (e) {
      updateFailed(context);
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

  Future<void> deleteUserData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Reauthenticate the user
    final authCredential = EmailAuthProvider.credential(email: user.email!, password: 'password');
    await user.reauthenticateWithCredential(authCredential);

    // Delete all documents in the 'data' subcollection
    final dataRef = userRef.collection('data');
    final snapshots = await dataRef.get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    // Delete the user document
    await userRef.delete();

    // Delete the user's authentication credentials
    await user.delete();
  }

  Future<void> updatePantryItem(String id, Pantry pantry, BuildContext context) async {
    try {
      final pantryRef = FirebaseFirestore.instance.collection('pantry').doc(id);
      final dateRef = FirebaseFirestore.instance.collection('date').doc(pantry.date.toString());
      final dateDoc = await dateRef.get();

      DateTime now = DateTime.now();
      int timeDifference = 0;
      if (dateDoc.exists) {
        if (pantry.isDone) {
          DateTime pantryDate = DateTime.fromMillisecondsSinceEpoch(pantry.date);
          timeDifference = now.difference(pantryDate).inDays;
        }
        await pantryRef.update({
          'isDone': pantry.isDone,
          'timeDifference': timeDifference,
        });
      } else {
        if (pantry.isDone) {
          DateTime pantryDate = DateTime.fromMillisecondsSinceEpoch(pantry.date);
          timeDifference = now.difference(pantryDate).inDays;
        }
        await pantryRef.set({
          'text': pantry.text,
          'category': pantry.category,
          'catId': pantry.catId,
          'isDone': pantry.isDone,
          'time': pantry.time,
          'date': pantry.date,
          'quantity': pantry.quantity,
          'expiryDate': pantry.expiryDate?.toIso8601String(),
          'notes': pantry.notes,
          'timeDifference': timeDifference,
        });
        await dateRef.set({});
      }
    } catch (e) {
      debugPrint('Something went wrong(UpdateIsDone): $e');
    }
  }













}
