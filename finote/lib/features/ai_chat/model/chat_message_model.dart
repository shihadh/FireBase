class ChatMessageModel {
  final String message;
  final bool isUser;
  final DateTime time;

  ChatMessageModel({
    required this.message,
    required this.isUser,
    required this.time,
  });
}
