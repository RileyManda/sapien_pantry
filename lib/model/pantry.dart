import 'package:cloud_firestore/cloud_firestore.dart';

class Pantry {
  final String id;
  final String text;
  final String? category;
  final bool isDone;
  final String time;
  final int date;

  Pantry({
    required this.id,
    required this.text,
      this.category,
    required this.isDone,
    required this.time,
    required this.date,
  });

  Pantry copyWith({String? text,String? category, bool? isDone, String? time, int? date}) => Pantry(
        id: id,
        text: text ?? this.text,
        category: category ?? this.category,
        isDone: isDone ?? this.isDone,
        time: time ?? this.time,
        date: date ?? this.date,
      );

  factory Pantry.fromMap(
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot) =>
      Pantry(
        id: documentSnapshot.id,
        text: documentSnapshot.data()!['text'],
        category: documentSnapshot.data()!['category'],
        isDone: documentSnapshot.data()!['isDone'],
        time: documentSnapshot.data()!['time'],
        date: documentSnapshot.data()!['date'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'text': text,
    'category': category,
        'isDone': isDone,
        'time': time,
        'date': date,
      };
  @override
  String toString() {
    return '$text - $category - $date - $time - $isDone';
  }
}
