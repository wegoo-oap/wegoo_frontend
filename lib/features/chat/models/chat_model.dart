class ChatModel {
  const ChatModel({
    required this.chatId,
    required this.type,
    required this.members,
    required this.groupName,
    required this.groupPhotoUrl,
    required this.tripId,
    required this.lastMessage,
    required this.createdAt,
  });

  final String chatId;
  final String type; // "DIRECT" | "GROUP"
  final List<String> members; // list of userIds
  final String groupName; // null for DIRECT
  final String groupPhotoUrl; // null for DIRECT
  final String tripId; // linked trip (optional)
  final Map<String, dynamic> lastMessage; // {text, senderId, sentAt}
  final DateTime? createdAt;

  static String buildDirectId(String uidA, String uidB) {
    final sorted = [uidA, uidB]..sort();
    return sorted.join('_');
  }

  factory ChatModel.fromJson(Map<String, dynamic> data) {
    return ChatModel(
      chatId: data['chatId'] ?? data['_id'] ?? '',
      type: data['type'] ?? 'DIRECT',
      members: List<String>.from(data['members'] ?? []),
      groupName: data['groupName'] ?? '',
      groupPhotoUrl: data['groupPhotoUrl'] ?? '',
      tripId: data['tripId'] ?? '',
      lastMessage: Map<String, dynamic>.from(data['lastMessage'] ?? {}),
      createdAt: data['createdAt'] != null ? DateTime.tryParse(data['createdAt'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'type': type,
      'members': members,
      'groupName': groupName,
      'groupPhotoUrl': groupPhotoUrl,
      'tripId': tripId,
      'lastMessage': lastMessage,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
