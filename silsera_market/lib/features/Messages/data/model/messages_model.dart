class Message {
  String sender;
  String recipient;
  String item;
  String content;
  DateTime timestamp;

  Message({
    required this.sender,
    required this.recipient,
    required this.item,
    required this.content,
    required this.timestamp,
  });

  Map<String, dynamic> to_dict() {
    return {
      'sender': sender,
      'recipient': recipient,
      'item': item,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.from_dict(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'],
      recipient: map['recipient'],
      item: map['item'],
      content: map['content'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
