import 'package:flutter/material.dart';
import '../model/pantry.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _textEditingController =
  TextEditingController();
  final List<String> _messages = [];

  // void _sendMessage() {
  //   if (_textEditingController.text.isNotEmpty) {
  //     setState(() {
  //       _messages.add(_textEditingController.text);
  //       _textEditingController.clear();
  //     });
  //   }
  // }

  void _sendMessage() {
    if (_textEditingController.text.isNotEmpty) {
      setState(() {
        String message = _textEditingController.text;
        Pantry pantry = Pantry(
          id: UniqueKey().toString(),
          text: message,
          category: 'category',
          catId: '1',
          isDone: false,
          time: TimeOfDay.now().format(context),
          date: DateTime.now().millisecondsSinceEpoch,
        );

        if (pantry.isDone) {
          message = 'Item "${pantry.text}" is done';
        }

        _messages.add(message);
        _textEditingController.clear();
      });
    }
  }


  void isDone(Pantry pantry) {
    if (pantry.isDone) {
      String message =
          'Item "${pantry.text}" is done at ${DateTime.now()}';
      setState(() {
        _messages.add(message);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    // Pantry pantry = Pantry(
    //   id: 'id',
    //   text: 'Eggs',
    //   category: 'category',
    //   catId: '1',
    //   isDone: false,
    //   time: '10:00AM',
    //   date: DateTime.now().millisecondsSinceEpoch,
    // );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat View'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





