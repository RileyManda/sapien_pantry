import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/chat.dart';
import '../model/pantry.dart';
import '../utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sapienpantry/controller/auth_controller.dart';
import 'package:firebase_core/firebase_core.dart';



class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final List<Chat> _messages = [];
  late StreamSubscription<QuerySnapshot> _subscription;
  final AuthController authController = AuthController();


  @override
  void initState() {
    super.initState();
    _messages.addAll([
      Chat(
        senderId: 'Sapien',
        text: 'Welcome to SapienPanrty!',
        timestamp: DateTime.now().millisecondsSinceEpoch, isDone: true,
      ),
      Chat(
        senderId: 'Sapien',
        text: 'I will keep you updated on activities in your Pantry',
        timestamp: DateTime.now().millisecondsSinceEpoch, isDone: true,
      ),
    ]);
    _subscription = _listenForPantryUpdates();
  }

  void _sendMessage(Pantry pantry) {
    final message = 'Item "${pantry.text}" is ${pantry.isDone ? "done" : "not done"}';
    final chat = Chat(
      senderId: 'sapienpantry',
      text: message,
      timestamp: DateTime.now().millisecondsSinceEpoch, isDone: pantry.isDone,

    );
    setState(() {
      _messages.add(chat);
      print('Messages: $_messages');
    });
  }

  StreamSubscription<QuerySnapshot> _listenForPantryUpdates() {
    // final FirebaseFirestore firestore = FirebaseFirestore.instance;
    return firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry')
        .snapshots()
        .listen((snapshot) {
      print('Number of doc changes: ${snapshot.docChanges.length}');
      snapshot.docChanges.forEach((change) {
        if (change.type == DocumentChangeType.modified) {
          final pantryData = change.doc.data();
          final pantry = Pantry(
            id: change.doc.id,
            text: pantryData!['text'],
            category: pantryData['category'],
            catId: pantryData['catId'],
            isDone: pantryData['isDone'],
            time: pantryData['time'],
            date: pantryData['date'],
          );
          _sendMessage(pantry); // pass the pantry object to _sendMessage method
        }
      });
    });
  }


  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat View'),
      ),
      body: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (BuildContext context, int index) {
         return ListTile(
            title: Text(
              'Sapien: ${_messages[index].text}',
                // display the item name
            ),

           subtitle: Text(
             'Status: ${_messages[index].isDone ? "Done" : "Not Done"}', // display the isDone status
           ),

         );

        },
      ),
    );
  }
}

