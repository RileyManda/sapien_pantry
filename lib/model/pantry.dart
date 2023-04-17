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
  final String? info; // new variable

  Pantry({
    required this.id,
    required this.text,
    required this.category,
    required this.catId,
    required this.isDone,
    required this.time,
    required this.date,
    this.info // nullable variable
  });

  Pantry copyWith(
      {String? text,
        String? category,
        String? catId,
        bool? isDone,
        String? time,
        int? date,
        String? info}) =>
      Pantry(
          id: id,
          text: text ?? this.text,
          category: category ?? this.category,
          catId: catId ?? this.catId,
          isDone: isDone ?? this.isDone,
          time: time ?? this.time,
          date: date ?? this.date,
          info: info ?? this.info // use the passed-in value, or the existing value if null
      );

  factory Pantry.fromMap(
      DocumentSnapshot<Map<String, dynamic>> documentSnapshot) =>
      Pantry(
          id: documentSnapshot.id,
          text: documentSnapshot.data()!['text'],
          category: documentSnapshot.data()!['category'],
          catId: documentSnapshot.data()!['catId'],
          isDone: documentSnapshot.data()!['isDone'],
          time: documentSnapshot.data()!['time'],
          date: documentSnapshot.data()!['date'],
          info: documentSnapshot.data()!['info'] // populate info from the snapshot data, which may be null
      );

  Map<String, dynamic> toMap() => {
    'id': id,
    'text': text,
    'category': category,
    'catId': catId,
    'isDone': isDone,
    'time': time,
    'date': date,
    'info': info // include info in the map
  };

  @override
  String toString() {
    return '$text - $category - $date - $time - $isDone - $info';
  }
}

