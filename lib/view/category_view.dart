import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sapienpantry/model/category.dart';
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
        title: const Text('Categories'),
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

          List<Widget> categoryCards = snapshot.data!.docs
              .map((DocumentSnapshot<Map<String, dynamic>> document) {
            Category category = Category.fromMap(document.data()!);



            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GroupItemView(
                          categoryId: document.id,
                          category: category.category,
                          categoryColor: category.categoryColor.toString(),
                        ),
                  ),
                );
              },
              child: Card(
                child: Container(
                  color: getCatColorForCategory(category.id),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        category.category,
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


}
