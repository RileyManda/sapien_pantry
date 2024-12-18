import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/secrets.dart';

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _recipesFuture;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _recipesFuture =
        _getRecipes('https://api.edamam.com/search');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<dynamic>> _getRecipes(String url) async {
    final fishRecipesResponse = await http.get(Uri.parse(
        '$url?q=fish&app_id=${secrets['appId']}&app_key=${secrets['appKey']}'));
    final chickenRecipesResponse = await http.get(Uri.parse(
        '$url?q=chicken&app_id=${secrets['appId']}&app_key=${secrets['appKey']}'));
    final vegetarianRecipesResponse = await http.get(Uri.parse(
        '$url?q=vegetarian&app_id=${secrets['appId']}&app_key=${secrets['appKey']}'));
    if (fishRecipesResponse.statusCode == 200 &&
        chickenRecipesResponse.statusCode == 200 &&
        vegetarianRecipesResponse.statusCode == 200) {
      final fishRecipes = json.decode(fishRecipesResponse.body)['hits'];
      final chickenRecipes = json.decode(chickenRecipesResponse.body)['hits'];
      final vegetarianRecipes = json.decode(vegetarianRecipesResponse.body)['hits'];
      return [fishRecipes, chickenRecipes, vegetarianRecipes];
    } else {
      throw Exception('Failed to load recipes');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Menus'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Fish',
            ),
            Tab(
              text: 'Chicken',
            ),
            Tab(
              text: 'Vegetarian',
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error loading recipes'),
            );
          } else {
            final recipes = snapshot.data!;
            return TabBarView(
              controller: _tabController,
              children: [
                _buildRecipesList(recipes[0]),
                _buildRecipesList(recipes[1]),
                _buildRecipesList(recipes[2]),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildRecipesList(List<dynamic> recipes) {
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
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
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
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
}