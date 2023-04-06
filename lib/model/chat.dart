class Chat {
  final String senderId;
  final String text;
  final int timestamp;
  final bool isDone; // new property

  Chat({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isDone, // initialize isDone in the constructor
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp,
      'isDone': isDone, // add isDone to the map
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      senderId: map['senderId'],
      text: map['text'],
      timestamp: map['timestamp'],
      isDone: map['isDone'], // initialize isDone from the map
    );
  }
}
