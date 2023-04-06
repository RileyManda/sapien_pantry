import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sapienpantry/model/category.dart';
import 'package:sapienpantry/services/cache_service.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'grouped_view.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);



  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _categoriesStream;
  late List<Category> _cachedCategories;
  late CacheService _cacheService;
  static const Duration kCacheDuration = Duration(minutes: 30);


  @override
  void initState() {
    super.initState();
    _categoriesStream = getCategoriesStream();
    _cachedCategories = [];
    SharedPreferences.getInstance().then((prefs) {
      _cacheService = CacheService(prefs);
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoriesStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user!.uid)
        .collection('categories')
        .snapshots();
  }

  Future<void> _cacheCategories(
      QuerySnapshot<Map<String, dynamic>> snapshot) async {
    _cachedCategories = snapshot.docs
        .map((doc) => Category.fromMap(doc.data()))
        .toList();

    // Save the categories in a local cache
    final cacheData = _cachedCategories
        .map((category) => category.toMap())
        .toList();

    CacheService.setCacheData(
      cacheKey: kCategoriesCacheKey,
      cacheData: jsonEncode(cacheData),
      cacheDuration: kCacheDuration,
    );




  }

  Future<void> _loadCachedCategories() async {
    final cacheData = await CacheService.getCacheData(kCategoriesCacheKey);
    if (cacheData is String) {
      final List<dynamic> jsonData = jsonDecode(cacheData) as List<dynamic>;
      _cachedCategories = jsonData
          .map((json) => Category.fromMap(json as Map<String, dynamic>))
          .toList();
    }
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
              // Load the cached categories if there's no data in the snapshot
              if (_cachedCategories.isEmpty) {
                _loadCachedCategories();
              }

              return GridView.count(
                primary: false,
                padding: const EdgeInsets.all(4),
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                crossAxisCount: 3,
                children: _cachedCategories
                    .map<Widget>((category) =>
                    _buildCategoryContainer(context, category))
                    .toList(),
              );
            }
            // Cache the categories
            _cacheCategories(snapshot.data!);
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

            return GridView.count(
              primary: false,
              padding: const EdgeInsets.all(4),
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              crossAxisCount: 3,
              children: categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    // Navigate to the ItemsView passing the category id
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GroupItemView(categoryId: category.id,category: category.category),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: getCatColorForCategory(category.id),
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
          },
        ),
      ),
    );
  }
}
Widget _buildCategoryContainer(BuildContext context, Category category) {
  return GestureDetector(
    onTap: () {
      // Navigate to the ItemsView passing the category id
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              GroupItemView(categoryId: category.id, category: category.category),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: getCatColorForCategory(category.id),
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
}


