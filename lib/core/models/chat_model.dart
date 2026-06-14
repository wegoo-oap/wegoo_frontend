import 'package:cloud_firestore/cloud_firestore.dart';

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

  // ── Deterministic ID for DIRECT chats ─────────────────────
  static String buildDirectId(String uidA, String uidB) {
    final sorted = [uidA, uidB]..sort();
    return sorted.join('_');
  }

  // ── fromFirestore ──────────────────────────────────────────
  factory ChatModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatModel(
      chatId: doc.id,
      type: data['type'] ?? 'DIRECT',
      members: List<String>.from(data['members'] ?? []),
      groupName: data['groupName'] ?? '',
      groupPhotoUrl: data['groupPhotoUrl'] ?? '',
      tripId: data['tripId'] ?? '',
      lastMessage: Map<String, dynamic>.from(data['lastMessage'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // ── toFirestore ────────────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'members': members,
      'groupName': groupName,
      'groupPhotoUrl': groupPhotoUrl,
      'tripId': tripId,
      'lastMessage': lastMessage,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
