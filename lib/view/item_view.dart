import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sapienpantry/model/item.dart';
import 'package:sapienpantry/utils/helper.dart';
import 'package:sapienpantry/widgets/item_tile.dart';

import '../utils/constants.dart';

class ItemView extends StatefulWidget {
  final String categoryId;

  const ItemView({Key? key, required this.categoryId}) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> _itemsStream;

  @override
  void initState() {
    _itemsStream = getItemsStream(widget.categoryId);
    super.initState();
  }
  Stream<QuerySnapshot<Map<String, dynamic>>> getItemsStream(String categoryId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry')
        .where('catId', isEqualTo: categoryId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Item'),
      ),
      body: Container(
        color: Colors.grey.shade100,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _itemsStream,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.data == null || snapshot.data!.size == 0) {
              return const Center(
                child: Text('No items found.'),
              );
            }
            // Get the list of items from the QuerySnapshot
            final items = snapshot.data!.docs
                .map((doc) => Item.fromMap(doc.data()))
                .toList();

            // Build a list of ItemTile widgets for each item
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return ItemTile(item: items[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
