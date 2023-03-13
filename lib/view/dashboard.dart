import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:sapienpantry/model/item.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/view/app_drawer.dart';
import 'package:sapienpantry/view/shopping_screen.dart';

import 'pantry_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  String time = '';
  // Animation controller
  late AnimationController _animationController;

  // animate the icon of the main FAB
  late Animation<double> _buttonAnimatedIcon;

  // child FABs
  late Animation<double> _translateButton;
  bool _isExpanded = false;

  @override
  initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..addListener(() {
        setState(() {});
      });

    _buttonAnimatedIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(
      begin: 100,
      end: -20,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  // function: expand/collapse the children of floating buttons
  _toggle() {
    if (_isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    _isExpanded = !_isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sapien Pantry'),
      ),
      drawer: const AppDrawer(),
      body: Container(
        color: Colors.grey.shade100,
        child: GridView.count(
    primary: false,
    padding: const EdgeInsets.all(4),
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    crossAxisCount: 3,
    children: [
    GestureDetector(
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const PantryScreen()),
    );
    },
    child: Container(
    padding: const EdgeInsets.all(20),

    child: Center(
    child: const Text('Pantry'),
    ),
    color: Colors.redAccent,
    ),
    ),

      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ShoppingScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(20),

          child: Center(
            child: const Text('Shopping'),
          ),
          color: Colors.blueAccent,
        ),
      ),
    ],
        ),
      ),
      //animated float
      floatingActionButton:
      Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Transform(
          transform: Matrix4.translationValues(
            0.0,
            _translateButton.value * 4,
            0.0,
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.amber,
            onPressed: () {
              comingSoon();
            },
            child: const Icon(Icons.message),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0,
            _translateButton.value * 3,
            0,
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              comingSoon();
            },
            child: const Icon(
              Icons.call,
            ),
          ),
        ),
        Transform(
          transform: Matrix4.translationValues(
            0,
            _translateButton.value * 2,
            0,
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            onPressed: () async {
              setState(() {
                time = TimeOfDay.now().format(context);
              });
              await showItemInput(context).then((value) {
                textController.clear();
              });
            },
            child: const Icon(Icons.shopping_basket),
          ),
        ),
        // This is the primary F

        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _buttonAnimatedIcon,
          ),
          // FloatingActionButton(
          // onPressed: () async {
          // setState(() {
          // time = TimeOfDay.now().format(context);
          // });
          // await showItemInput(context).then((value) {
          // textController.clear();
          // });
          // },
          // child: const Icon(Icons.shopping_basket),
          // ),
        ),
      ]),

      // animated float end
    );
  }

  showItemInput(BuildContext context, {Item? item}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Update Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: textController,
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
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
            if (item != null)
              TextButton.icon(
                  onPressed: () {
                    itemController.deleteItem(item.id);
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
                if (textController.text.isEmpty) {
                  return;
                }
                if (item != null) {
                  itemController.updateItem(item.id,
                      item.copyWith(text: textController.text, time: time));
                } else {
                  itemController.addItem(textController.text, time,
                      getDateTimestamp(DateTime.now()));
                  showIsAdded();
                }
                Navigator.pop(context);
              },
              child: Text(item == null ? 'Add Item' : 'Update'),
            )
          ],
        ));
  }

  showIsDone() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Item has run out'),
      backgroundColor: Colors.orangeAccent,
    ));
  }

  showIsAdded() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Item added to Pantry'),
      backgroundColor: Colors.green,
    ));
  }

  showOurFault() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Something went wrong: Our server is sleepy,'),
      backgroundColor: Colors.amberAccent,
    ));
  }

  comingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Feature coming soon'),
      backgroundColor: Colors.grey,
    ));
  }
}
