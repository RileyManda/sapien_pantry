import 'dart:convert';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/menu_db_helper.dart';
import '../services/secrets.dart';
import '../utils/recepe_utils.dart';

class MenuView extends StatefulWidget {
  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with SingleTickerProviderStateMixin {
  late Future<List<dynamic>> _recipesFuture;
  late TabController _tabController;
  RecepeUtils _recepe_utils = RecepeUtils();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _recipesFuture =
        _getRecipes('https://api.edamam.com/search');
    _requestPermission();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  void _requestPermission() async {
    var status = await Permission.storage.request();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Permission Denied'),
          content: Text('Loading Recipes requires access to local storage. Without this permission, recipes will not load.'),
          actions: [
            MaterialButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
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

      // Save the recipes to the database
      // Save the recipes to the database
      final menuDb = MenuDb();
      try {
        final database = await menuDb.database;
        await database.transaction((txn) async {
          for (var recipe in fishRecipes) {
            final recipeMap = {
              MenuDb.columnName: recipe['recipe']['label'],
              MenuDb.columnImage: recipe['recipe']['image'],
              MenuDb.columnTotalTime: recipe['recipe']['totalTime'],
              MenuDb.columnYield: recipe['recipe']['yield'],
              MenuDb.columnHealthLabels: recipe['recipe']['healthLabels'].join(', ')
            };
            await txn.insert(MenuDb.table, recipeMap);
          }
          for (var recipe in chickenRecipes) {
            final recipeMap = {
              MenuDb.columnName: recipe['recipe']['label'],
              MenuDb.columnImage: recipe['recipe']['image'],
              MenuDb.columnTotalTime: recipe['recipe']['totalTime'],
              MenuDb.columnYield: recipe['recipe']['yield'],
              MenuDb.columnHealthLabels: recipe['recipe']['healthLabels'].join(', ')
            };
            await txn.insert(MenuDb.table, recipeMap);
          }
          for (var recipe in vegetarianRecipes) {
            final recipeMap = {
              MenuDb.columnName: recipe['recipe']['label'],
              MenuDb.columnImage: recipe['recipe']['image'],
              MenuDb.columnTotalTime: recipe['recipe']['totalTime'],
              MenuDb.columnYield: recipe['recipe']['yield'],
              MenuDb.columnHealthLabels: recipe['recipe']['healthLabels'].join(', ')
            };
            await txn.insert(MenuDb.table, recipeMap);
          }
        });

        // Return the recipes as a list
        return [fishRecipes, chickenRecipes, vegetarianRecipes];
      } catch (e) {
        throw Exception('Failed to save recipes to database');
      }

    } else {
      throw Exception('Failed to load recipes');
    }
    return []; // return an empty list if no recipes are found
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recepes'),
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
    return Expanded(
      child: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index]['recipe'] as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: () =>  RecepeUtils.showIngredientsBottomSheet(context, recipe),
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
      ),
    );
  }



}