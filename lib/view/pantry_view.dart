import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/services/pantry_service.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/utils/messages.dart';
import 'package:sapienpantry/utils/pantry_utils.dart';


class PantryView extends StatefulWidget {
  const PantryView({Key? key}) : super(key: key);

  @override
  PantryViewState createState() => PantryViewState();
}

class PantryViewState extends State<PantryView> {
  final _pantryService = PantryService();
  late List<Pantry> _searchResults = [];
  List<Pantry> _pantryList = [];



  @override
  void initState() {
    super.initState();
    _pantryList = [];
    PantryUtils.scrollController.addListener(() {
      if (PantryUtils.scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          PantryUtils.isVisible = false;
        });
      }
      if (PantryUtils.scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          PantryUtils.isVisible = true;
        });
      }
    });
    _pantryService.streamPantryList().listen((pantryList) {
      setState(() {
        _pantryList = pantryList;
      });
    });
  }
  void _startSearch() {
    setState(() {
      PantryUtils.isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      PantryUtils.isSearching = false;
      _searchResults= [];
      PantryUtils.textController.clear();
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
    if (PantryUtils.isSearching) {
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
              value: 'time',
              child: Text('Sort by time'),
            ),
            PopupMenuItem(
              value: 'name',
              child: Text('Sort by name'),
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
        leading: PantryUtils.isSearching ? const BackButton() : null,
        title: PantryUtils.isSearching
            ? TextField(
                controller: PantryUtils.textController,
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
      body: StreamBuilder<List<Pantry>>(
        stream: _pantryService.streamPantryList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong.'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          _pantryList = snapshot.data!;
          final data =
              _searchResults.isNotEmpty ? _searchResults : snapshot.data!;
          return ListView.builder(
            controller: PantryUtils.scrollController,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final pantry = data[index];
              return AnimatedOpacity(
                opacity: pantry.isDone ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 100),
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
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text(pantry.text),
                    trailing: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        _pantryService.updatePantry(
                          pantry.id,
                          pantry.copyWith(isDone: !pantry.isDone),
                          context,
                        );
                        if (!pantry.isDone) {
                          showItemFinished(context);
                        } else {
                          showItemAdded(context);
                        }
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        child: Icon(
                          pantry.isDone
                              ? Icons.check_circle
                              : Icons.circle_rounded,
                          color: pantry.isDone
                              ? Colors.sapienshoptheme
                              : Theme.of(context).primaryColorDark,
                        ),
                      ),
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
      floatingActionButton: PantryUtils.isVisible
          ? Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                mini: false,
                onPressed: () async {
                  setState(() {
                    PantryUtils.time = TimeOfDay.now().format(context);
                  });
                  PantryUtils.showItemInput(context, setStateCallback: () {  });
                  PantryUtils.textController.clear();

                },
                child: const Icon(Icons.add),
              ),
            ])
          : null,
    );
  }

}

