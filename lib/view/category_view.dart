import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sapienpantry/services/pantry_service.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';
import 'grouped_view.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final PantryService _pantryService = PantryService();
  Map<String, Color> _categoryColors = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: _categoryColors.isNotEmpty
            ? _categoryColors.values.first
            : pPrimaryColor,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _pantryService.getCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          List<DocumentSnapshot<Map<String, dynamic>>> documents =
              snapshot.data!.docs;

          // Update the category colors
          for (DocumentSnapshot<Map<String, dynamic>> document in documents) {
            Map<String, dynamic>? data = document.data();
            if (data != null) {
              String category = data['category'];
              if (!_categoryColors.containsKey(category)) {
                Color categoryColor = generateColorForString(category);
                _categoryColors[category] = categoryColor;
              }
            }
          }

          List<Widget> categoryCards = documents
              .map((DocumentSnapshot<Map<String, dynamic>> document) {
            Map<String, dynamic>? data = document.data();

            Color categoryColor = _categoryColors[data!['category']]!;

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupItemView(
                        categoryId: document.id, category: data['category']),
                  ),
                );
              },
              child: Card(
                child: Container(
                  color: categoryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        data['category'],
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList();

          return GridView.count(
            primary: false,
            padding: const EdgeInsets.all(4),
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            crossAxisCount: 3,
            children: categoryCards,
          );
        },
      ),
    );
  }



        // Helper function to generate a color for a string
  Color generateColorForString(String str) {
    final bytes = str.codeUnits;
    final sum = bytes.fold(0, (a, b) => a + b);
    final index = sum % labelColors.length;
    return labelColors[index];
  }

  // Helper function to update the category colors
  void _updateCategoryColors(
      List<DocumentSnapshot<Map<String, dynamic>>> documents) {
    for (DocumentSnapshot<Map<String, dynamic>> document in documents) {
      Map<String, dynamic>? data = document.data();
      if (data != null) {
        String category = data['category'];
        if (!_categoryColors.containsKey(category)) {
          Color categoryColor = generateColorForString(category);
          _categoryColors[category] = categoryColor;
        }
      }
    }
    setState(() {});
  }
}
