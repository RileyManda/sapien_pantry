import 'package:flutter/material.dart';
import 'package:sapienpantry/model/pantry.dart';
import 'package:sapienpantry/utils/constants.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/view/app_drawer.dart';
import 'package:sapienpantry/view/shopping_view.dart';
import 'package:sapienpantry/view/pantry_view.dart';
import '../utils/messages.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  final textController = TextEditingController();
  final catController = TextEditingController();
  String time = '';
  late AnimationController _animationController;
  // animate the icon of the main FAB
  late Animation<double> _buttonAnimatedIcon;
  // child FABs
  late Animation<double> _translateButton;
  bool _isExpanded = false;
  int pantryNotification = 0;
  int _itemsDone = 0;

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
    updateItemsDone();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    catController.dispose();
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
  void updateItemsDone() {
    setState(() {
      _itemsDone = 0;
    });

    firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry')
        .where('isDone', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        _itemsDone = snapshot.size;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: <Widget>[
          Stack(
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.storage_outlined, size: 18),
                  onPressed: () {
                    setState(() {
                      pantryNotification = 0;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PantryView()),
                    );
                  }),
              pantryNotification != 0
                  ? Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$pantryNotification',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ShoppingView()),
                  );
                },
              ),
              if (_itemsDone > 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      '$_itemsDone',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
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
                  MaterialPageRoute(builder: (context) => const PantryView()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: pPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.inventory, color: Colors.white, size: 24),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShoppingView()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.sapienshoptheme,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.local_grocery_store,
                      color: Colors.white, size: 24),
                ),
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
            heroTag: null,
            mini: true,
            backgroundColor: buttonColors.elementAt(2),
            onPressed: () {
              showComingSoon(context);
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
            heroTag: null,
            mini: true,
            backgroundColor: buttonColors.elementAt(1),
            onPressed: () {
              showComingSoon(context);
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
            heroTag: null,
            mini: true,
            backgroundColor: buttonColors.elementAt(0),
            onPressed: () async {
              setState(() {
                time = TimeOfDay.now().format(context);
              });
              await showItemInput(context).then((value) {
                textController.clear();
                catController.clear();
              });
            },
            child: const Icon(Icons.inventory),
          ),
        ),
        FloatingActionButton(
          heroTag: null,

          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _buttonAnimatedIcon,
          ),
        ),
      ]),

      // animated float end
    );
  }

  showItemInput(BuildContext context, {Pantry? pantry}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title:
                  Text(pantry == null ? 'Add Item to Pantry' : 'Update Pantry'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: textController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText:'Item Name',
                        labelText: 'Item Name',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(5))
                    ),
                  ),
                  TextFormField(
                    controller: catController,
                    autofocus: true,
                    decoration: const InputDecoration(
                        hintText:'Category',
                        labelText: 'Category Name',
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(5))

                    ),
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
                        pantryController.deleteFromPantry(pantry.id);
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
                      // TODO show error on field
                    }
                    if (catController.text.isEmpty) {
                      return;
                    }
                    if (pantry != null) {
                      pantryController.updatePantry(
                          pantry.id,
                          pantry.copyWith(
                              text: textController.text,category: catController.text, time: time));
                    } else {
                      pantryController.addtoPantry(textController.text,catController.text, time,
                          getDateTimestamp(DateTime.now()));
                      showIsAdded(context);
                      setState(() {
                        pantryNotification++;
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: Text(pantry == null ? 'Add' : 'Update'),
                )
              ],
            ));
  }








}
