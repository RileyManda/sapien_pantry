import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sapienpantry/model/category.dart';
import 'package:sapienpantry/model/item.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'grouped_view.dart';



class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView>
    with SingleTickerProviderStateMixin {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _categoriesStream;

  @override
  void initState() {
    _categoriesStream = getCategoriesStream();
    super.initState();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoriesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user!.uid)
        .collection('categories')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _categoriesStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null || snapshot.data!.size == 0) {
              return const Center(
                child: Text('You have not created any categories.'),
              );
            }
            // Get the list of categories from the QuerySnapshot
            final categories = snapshot.data!.docs
                .map((doc) => Category.fromMap(doc.data()))
                .toList();

            // Build a list of Container widgets for each category
            return categoryGridView(categories);
          },
        ),
      ),
    );
  }

  Widget categoryGridView(List<Category> categories) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(4),
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      crossAxisCount: 3,
      children: categories.map((category) {
        final color =
            categoryColors[category.id] ?? getCatColorForCategory(category.id);
        return GestureDetector(
          onTap: () {
            // Navigate to the ItemsView passing the category id
            Navigator.push(
              context,
              MaterialPageRoute(
                // builder: (context) => ItemView(categoryId: category.id),
                builder: (context) => GroupItemView(categoryId: category.id),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                category.category,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }).toList(),


    );
  }


}

