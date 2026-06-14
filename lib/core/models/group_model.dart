import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  const GroupModel({
    required this.groupId,
    required this.name,
    required this.adminId,
    required this.members,
    required this.tripId,
    required this.chatId,
    required this.isPublic,
    required this.itinerary,
    required this.createdAt,
  });

  final String groupId;
  final String name;
  final String adminId;
  final List<String> members; // max 12 for MVP
  final String tripId; // linked trip
  final String chatId; // linked chat document
  final bool isPublic;
  final List<Map<String, dynamic>>
      itinerary; // [{placeId, placeName, date, notes}]
  final DateTime? createdAt;

  // ── fromFirestore ──────────────────────────────────────────
  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel(
      groupId: doc.id,
      name: data['name'] ?? '',
      adminId: data['adminId'] ?? '',
      members: List<String>.from(data['members'] ?? []),
      tripId: data['tripId'] ?? '',
      chatId: data['chatId'] ?? '',
      isPublic: data['isPublic'] ?? false,
      itinerary: List<Map<String, dynamic>>.from(
        (data['itinerary'] ?? []).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // ── toFirestore ────────────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'adminId': adminId,
      'members': members,
      'tripId': tripId,
      'chatId': chatId,
      'isPublic': isPublic,
      'itinerary': itinerary,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // ── copyWith ───────────────────────────────────────────────
  GroupModel copyWith({
    List<String>? members,
    List<Map<String, dynamic>>? itinerary,
    bool? isPublic,
  }) {
    return GroupModel(
      groupId: groupId,
      name: name,
      adminId: adminId,
      members: members ?? this.members,
      tripId: tripId,
      chatId: chatId,
      isPublic: isPublic ?? this.isPublic,
      itinerary: itinerary ?? this.itinerary,
      createdAt: createdAt,
    );
  }
}
