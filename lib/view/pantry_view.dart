import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';

import '../controller/auth_controller.dart';
import '../services/pantry_service.dart';
import '../utils/helper.dart';
import '../utils/messages.dart';

class PantryView extends StatefulWidget {
  const PantryView({Key? key}) : super(key: key);

  @override
  _PantryViewState createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  PantryService _pantryService = PantryService();
  final textController = TextEditingController();
  final categoryController = TextEditingController();
  bool isDone = false;
  String time = '';
  bool _isSearching = false;
  late List<Pantry> _searchResults = [];
  late List<Pantry> _pantryList = [];


  @override
  void dispose() {
    textController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _stopSearch();
            textController.clear();
          },
          icon: const Icon(Icons.close),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: _startSearch,
          icon: const Icon(Icons.search),
        ),
        PopupMenuButton(
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem(
                child: Text('Sort by time'),
                value: 'time',
              ),
              const PopupMenuItem(
                child: Text('Sort by name'),
                value: 'name',
              ),
            ];
          },
          onSelected: (value) {
            setState(() {
              if (value == 'time') {
                _pantryList.sort((a, b) => a.time.compareTo(b.time));
              } else if (value == 'name') {
                _pantryList.sort((a, b) => a.text.compareTo(b.text));
              }
            });
          },
        ),
      ];
    }
  }
  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }


  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchResults = []; // modify this line
    });
  }
  void _searchItem(String query) {
    setState(() {
      if (query.isNotEmpty) {
        _searchResults = _pantryList
            .where((pantry) =>
        pantry.text.toLowerCase().contains(query.toLowerCase()) ||
            pantry.category.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        _searchResults = List.from(_pantryList);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    Map<K, List<T>> groupBy<T, K>(Iterable<T> iterable, K Function(T) keyFunc) {
      final groups = <K, List<T>>{};
      for (final item in iterable) {
        final key = keyFunc(item);
        groups.putIfAbsent(key, () => []).add(item);
      }
      return groups;
    }
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching
            ? TextField(
          controller: textController,
          autofocus: true,
          onChanged: _searchItem,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white),
          ),
          style: const TextStyle(color: Colors.white),
        )
            : const Text('Pantry'),
        actions: _buildAppBarActions(),
      ),
      body: Container(
        child: StreamBuilder<List<Pantry>>(
          stream: _pantryService.streamPantryList(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong.'));
            }
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            _pantryList = snapshot.data!;
            final data = _searchResults.isNotEmpty ? _searchResults : snapshot.data!;
            final filteredData = groupBy(data, (pantry) => pantry.category);
            final groupedData = _isSearching ? filteredData : groupBy(snapshot.data!, (pantry) => pantry.category);

            return ListView.builder(
              itemCount: _isSearching ? filteredData.length : groupedData.length,
              itemBuilder: (context, index) {
                final category = _isSearching ? filteredData.keys.toList()[index] : groupedData.keys.toList()[index];
                final items = _isSearching ? filteredData[category]! : groupedData[category]!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    ...items.map((pantry) {
                      return AnimatedOpacity(
                        opacity: pantry.isDone ? 0.5 : 1.0,
                        duration: Duration(milliseconds: 500),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              right: BorderSide(
                                color: getCatColorForCategory(pantry.category),
                                width: 10,
                              ),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(4, 4),
                                blurRadius: 2.0,
                                color: Colors.black12,
                              ),
                            ],
                          ),
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          child: ListTile(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 16.0),
                            title: Text(pantry.text),
                            trailing: Checkbox(
                              value: pantry.isDone,
                              onChanged: (bool? value) {
                                if (value != null) {
                                  _pantryService.updatePantry(
                                    pantry.id,
                                    pantry.copyWith(isDone: value),
                                  );
                                  if (!pantry.isDone) {
                                    showItemFinished(context);
                                  } else {
                                    showItemAdded(context);
                                  }
                                  setState(() {
                                    // Remove this line
                                    // pantry.isDone = value;
                                  });
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              checkColor: Colors.white,
                              fillColor: MaterialStateProperty.all<Color>(
                                pantry.isDone
                                    ? pPrimaryColor
                                    : Colors.grey[300]!,
                              ),
                            ),
                            onTap: () {
                              _showMoreDetails(context, pantry);
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        mini: true,
        backgroundColor: buttonColors.elementAt(0),
        onPressed: () async {
          setState(() {
            time = TimeOfDay.now().format(context);
          });
          await showItemInput(context).then((value) {
            textController.clear();
            categoryController.clear();
          });
        },
        child: const Icon(Icons.inventory),
      ),
    );
  }


  showItemInput(BuildContext context, {Pantry? pantry}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:
          Text(pantry == null ? 'Add Item to Pantry' : 'Update Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: textController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Item Name',
                  labelText: 'Item Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: categoryController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Category',
                  labelText: 'Category',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a category';
                  }
                  return null;
                },
              ),

              const SizedBox(
                height: 5,
              ),
              OutlinedButton(
                onPressed: () async {
                  final newTime = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                  if (newTime != null) {
                    setState(() {
                      time = newTime.format(context);
                    });
                  }
                },
                child: Text('Time : $time'),
              ),
            ],
          ),
          actions: [
            if (pantry != null)
              TextButton.icon(
                  onPressed: () {
                    _pantryService.deleteFromPantry(pantry.id);
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.redAccent,
                  ),
                  label: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.black54),
                  )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                textController.text.trim();
                categoryController.text.trim();
                if (textController.text.isEmpty) {
                  return;
                }
                if (pantry != null) {
                  _pantryService.updatePantry(
                      pantry.id,
                      pantry.copyWith(
                          text: textController.text,
                          category: categoryController.text,
                          time: time));
                } else {
                  _pantryService.addToPantry(
                      textController.text,
                      categoryController.text,
                      time,
                      getDateTimestamp(DateTime.now()));
                  showItemAdded(context);
                }
                Navigator.pop(context);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.save),
                  const SizedBox(width: 8.0),
                  Text(pantry == null ? 'Add' : 'Update'),
                ],
              ),
            )
          ],
        ));
  }



}
void _showMoreDetails(BuildContext context, Pantry pantry) {
  final textController = TextEditingController(text: pantry.text);
  final categoryController =
  TextEditingController(text: pantry.category);
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: textController,
              decoration: InputDecoration(
                labelText: 'Item name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8.0),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Update the pantry item with the new values
                final updatedPantry = pantry.copyWith(
                  text: textController.text,
                  category: categoryController.text,
                );
                PantryService().updatePantry(
                  pantry.id, // Pass the pantry item's id
                  updatedPantry,
                );
                Navigator.pop(context); // Close the bottom sheet
              },
              child: Text('Save'),
            ),
          ],
        ),
      );
    },
  );

}

