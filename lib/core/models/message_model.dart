import 'package:cloud_firestore/cloud_firestore.dart';

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
  final List<String> readBy; // list of userIds who read the message

  // ── fromFirestore ──────────────────────────────────────────
  factory MessageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MessageModel(
      messageId: doc.id,
      senderId: data['senderId'] ?? '',
      text: data['text'] ?? '',
      sentAt: (data['sentAt'] as Timestamp?)?.toDate(),
      readBy: List<String>.from(data['readBy'] ?? []),
    );
  }

  // ── toFirestore ────────────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'senderId': senderId,
      'text': text,
      'sentAt': FieldValue.serverTimestamp(),
      'readBy': readBy,
    };
  }
}
