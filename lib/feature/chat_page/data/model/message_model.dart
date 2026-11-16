class MessageModel {
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime time;

  const MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.time,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] ?? '',
      receiverId: map['receiverId'] ?? '',
      text: map['text'] ?? '',
      time: DateTime.parse(map['time'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'text': text,
      'time': time.toIso8601String(),
    };
  }
}
