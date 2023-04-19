import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const apiID = 'c791d1fb';
const apiKey = '2d39fc144cf2fb47a81e9cb398c3010d';
const apiUrlFish =
    'https://api.edamam.com/api/recipes/v2?type=public&q=%22fish%22&app_id=$apiID&app_key=$apiKey';
const apiUrlChicken =
    'https://api.edamam.com/api/recipes/v2?type=public&q=%22chicken%22&app_id=$apiID&app_key=$apiKey';

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _fishRecipesFuture;
  late Future<List<dynamic>> _chickenRecipesFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fishRecipesFuture = _getRecipes(apiUrlFish);
    _chickenRecipesFuture = _getRecipes(apiUrlChicken);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _getRecipes(String url) async {
    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    return data['hits'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Menus'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.brown,
          ),
          tabs: [
            Tab(
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    'Fish',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Tab(
              child: SizedBox(
                height: 40,
                child: Center(
                  child: Text(
                    'Chicken',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
        FutureBuilder(
        future: _fishRecipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading fish recipes'),
            );
          } else {
            List<dynamic> recipes = snapshot.data as List<dynamic>;
            return ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index]['recipe'] as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () => _showIngredientsBottomSheet(context, recipe),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Image.network(
                                          recipe['image'],
                                          height: 80,
                                          width: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          recipe['label'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      recipe['image'],
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.timer),
                                    SizedBox(width: 4),
                                    Text('${recipe['totalTime']} min'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.restaurant),
                                    SizedBox(width: 4),
                                    Text('${recipe['yield']} servings'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: [
                                ...List.generate(
                                  min(recipe['healthLabels'].length, 5),
                                      (index) {
                                    return Chip(
                                      label: Text(
                                        recipe['healthLabels'][index],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    ]
      )
    );
  }

}
void _showIngredientsBottomSheet(BuildContext context, dynamic recipe) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                recipe['label'],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Ingredients:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              ...List.generate(recipe['ingredientLines'].length, (index) {
                return Text(
                  '- ${recipe['ingredientLines'][index]}',
                  style: TextStyle(fontSize: 16),
                );
              }),
            ],
          ),
        ),
      );
    },
  );
}
