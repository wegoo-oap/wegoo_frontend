class MessageModel {
  const MessageModel({
    required this.messageId,
    required this.senderId,
    required this.text,
    required this.sentAt,
    required this.readBy,
  });

  final String messageId;
  final String senderId;
  final String text;
  final DateTime? sentAt;
  final List<String> readBy;

  factory MessageModel.fromJson(Map<String, dynamic> data) {
    return MessageModel(
      messageId: data['messageId'] ?? data['_id'] ?? '',
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      sentAt: data['sentAt'] != null ? DateTime.tryParse(data['sentAt'].toString()) : null,
      readBy: List<String>.from(data['readBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'senderId': senderId,
      'text': text,
      'sentAt': sentAt?.toIso8601String(),
      'readBy': readBy,
    };
  }
}
