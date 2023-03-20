import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String category;

  Category({
    required this.id,
    required this.category
  });

  Category copyWith({String? category, bool? isDone, String? time, int? date}) => Category(
        id: id,
        category: category ?? this.category,
      );

  factory Category.fromMap(
          DocumentSnapshot<Map<String, dynamic>> documentSnapshot) =>
      Category(
        id: documentSnapshot.id,
        category: documentSnapshot.data()!['category'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
       
      };
  @override
  String toString() {
    return '$category';
  }
}
