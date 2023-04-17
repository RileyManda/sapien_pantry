import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sapienpantry/model/pantry.dart';
import '../services/pantry_service.dart';
import '../utils/helper.dart';
import '../utils/messages.dart';
import '../utils/pantry_utils.dart';

class PantryView extends StatefulWidget {
  const PantryView({Key? key}) : super(key: key);

  @override
  _PantryViewState createState() => _PantryViewState();
}

class _PantryViewState extends State<PantryView> {
  final _pantryService = PantryService();
  final _textController = TextEditingController();
  final _categoryController = TextEditingController();
  final _scrollController = ScrollController();
  late List<Pantry> _searchResults = [];
  late List<Pantry> _pantryList;
  bool _isSearching = false;
  bool _isVisible = true;
  String time = '';

  @override
  void initState() {
    super.initState();
    _pantryList = [];
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _isVisible = false;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _isVisible = true;
        });
      }
    });
    _pantryService.streamPantryList().listen((pantryList) {
      setState(() {
        _pantryList = pantryList;
      });
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _categoryController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchResults = [];
      _textController.clear();
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

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          onPressed: () {
            _stopSearch();
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
          itemBuilder: (BuildContext context) => const [
            PopupMenuItem(
              child: Text('Sort by time'),
              value: 'time',
            ),
            PopupMenuItem(
              child: Text('Sort by name'),
              value: 'name',
            ),
          ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: _isSearching ? const BackButton() : null,
        title: _isSearching
            ? TextField(
                controller: _textController,
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
            final data =
                _searchResults.isNotEmpty ? _searchResults : snapshot.data!;
            return ListView.builder(
              controller: _scrollController,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final pantry = data[index];
                return AnimatedOpacity(
                  opacity: pantry.isDone ? 0.5 : 1.0,
                  duration: Duration(milliseconds: 100),
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
                    margin:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                          }
                        },
                      ),
                      onTap: () {
                        PantryUtils.showMoreDetails(context, pantry);
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: _isVisible
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                mini: false,
                onPressed: () async {
                  setState(() {
                    time = TimeOfDay.now().format(context);
                  });
                  PantryUtils.showItemInput(context, setStateCallback: () {  });
                  _textController.clear();

                },
                child: const Icon(Icons.add),
              ),
            ])
          : null,
    );
  }
}

