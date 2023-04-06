import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sapienpantry/services/pantry_service.dart';
import '../utils/constants.dart';
import '../utils/helper.dart';
import 'grouped_view.dart';

class CategoryView extends StatefulWidget {
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
        title: const Text('Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _pantryService.getCategories(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Widget> categoryCards = snapshot.data!.docs
              .map((DocumentSnapshot<Map<String, dynamic>> document) {
            Map<String, dynamic>? data = document.data();

            // Generate or retrieve the color for this category
            Color categoryColor;
            if (_categoryColors.containsKey(data!['category'])) {
              categoryColor = _categoryColors[data['category']]!;
            } else {
              categoryColor = generateColorForString(data['category']);
              _categoryColors[data['category']] = categoryColor;
            }

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GroupItemView(categoryId: document.id,category:data['category'] ),
                 
                  ),
                );
              },
              child: Card(
                child: Container(
                  color: categoryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(data['category'],style: TextStyle(
                        color: Colors.white,
                      ),),

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
}
