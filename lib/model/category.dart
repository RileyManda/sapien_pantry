import 'package:flutter/material.dart';

class Category {
  String id;
  String category;
  Color categoryColor;

  Category({required this.id, required this.category, required this.categoryColor});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'categoryColor': categoryColor.value,
    };
  }

  Category.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        category = map['category'],
        categoryColor = Color(map['categoryColor']);

  @override
  String toString() {
    return 'Category{id: $id, category: $category, categoryColor: $categoryColor}';
  }
}
