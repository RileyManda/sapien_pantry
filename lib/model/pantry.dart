import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Pantry {
  final String id;
  final String text;
  final String category;
  final String catId;
  late final bool isDone;
  final String time;
  final int date;
  final int? quantity;
  final DateTime? expiryDate;
  final String? notes;

  Pantry({
    required this.id,
    required this.text,
    required this.category,
    required this.catId,
    required this.isDone,
    required this.time,
    required this.date,
    this.quantity,
    this.expiryDate,
    this.notes,
  });

  Pantry copyWith({
    String? text,
    String? category,
    String? catId,
    bool? isDone,
    String? time,
    int? date,
    int? quantity,
    DateTime? expiryDate,
    String? notes,
  }) =>
      Pantry(
        id: id,
        text: text ?? this.text,
        category: category ?? this.category,
        catId: catId ?? this.catId,
        isDone: isDone ?? this.isDone,
        time: time ?? this.time,
        date: date ?? this.date,
        quantity: quantity ?? this.quantity,
        expiryDate: expiryDate ?? this.expiryDate,
        notes: notes ?? this.notes,
      );

  factory Pantry.fromMap(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot,
      ) =>
      Pantry(
        id: documentSnapshot.id,
        text: documentSnapshot.data()!['text'],
        category: documentSnapshot.data()!['category'],
        catId: documentSnapshot.data()!['catId'],
        isDone: documentSnapshot.data()!['isDone'],
        time: documentSnapshot.data()!['time'],
        date: documentSnapshot.data()!['date'],
        quantity: documentSnapshot.data()!['quantity'],
        expiryDate: documentSnapshot.data()!['expiryDate'] != null
            ? DateTime.parse(documentSnapshot.data()!['expiryDate'])
            : null,
        notes: documentSnapshot.data()!['notes'],

        // populate info from the snapshot data, which may be null
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'category': category,
    'catId': catId,
    'isDone': isDone,
    'time': time,
    'date': date,
    'quantity': quantity,
    'expiryDate': expiryDate?.toIso8601String(),
    'notes': notes,

    // include info in the map
  };

  @override
  String toString() {
    return '$text - $category - $date - $time - $isDone - $quantity - $expiryDate - $notes';
  }
}

