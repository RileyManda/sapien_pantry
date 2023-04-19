import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuView extends StatefulWidget {
  const MenuView({Key? key}) : super(key: key);

  @override
  _MenuViewState createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late List<dynamic> _menus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMenus();
  }

  Future<void> _fetchMenus() async {
    final url =
    Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        _menus = json.decode(response.body)['meals'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load menus');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menus'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _menus.length,
        itemBuilder: (context, index) {
          final menu = _menus[index];
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Container(
                    height: 600,
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            menu['strMealThumb'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 16),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              child: Text(
                                menu['strInstructions'] ?? '',
                                textAlign: TextAlign.justify,
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    child: Image.network(
                      menu['strMealThumb'],
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      menu['strMeal'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
