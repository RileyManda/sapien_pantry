import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sapienpantry/model/chat.dart';

import '../model/pantry.dart';
import '../utils/constants.dart';

class ChatController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String chatRoomId;
  final BehaviorSubject<List<Chat>> _chatStreamController = BehaviorSubject<List<Chat>>();

  ChatController(this.chatRoomId) {
    _getChats();
    _listenForPantryUpdates();
  }

  Stream<List<Chat>> get chatStream => _chatStreamController.stream;

  Future<void> sendMessage(Chat chat) async {
    await firestore.collection('chats').doc(chatRoomId).collection('messages').add(chat.toMap());
  }

  Future<void> _getChats() async {
    final querySnapshot =
    await firestore.collection('chats').doc(chatRoomId).collection('messages').orderBy('timestamp').get();
    final chats = querySnapshot.docs.map((doc) => Chat.fromMap(doc.data())).toList();
    _chatStreamController.add(chats);
  }

  void _listenForPantryUpdates() {
    firestore
        .collection('users')
        .doc(authController.user!.uid)
        .collection('pantry')
        .snapshots()
        .listen((snapshot) {
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
          if (pantry.isDone) {
            final message =
                'Item "${pantry.text}" is done on ${DateTime.fromMillisecondsSinceEpoch(pantry.date)}';
            final chat = Chat(
              senderId: 'sapienpantry',
              text: message,
              timestamp: DateTime.now().millisecondsSinceEpoch, isDone: false,
            );
            sendMessage(chat);
          }
        }
      });
    });
  }




  void dispose() {
    _chatStreamController.close();
  }
}
