import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionModel {
  const ConnectionModel({
    required this.connectionId,
    required this.userA,
    required this.userB,
    required this.status,
    required this.tripContext,
    required this.requestedAt,
    this.respondedAt,
  });

  final String connectionId;
  final String userA; // requester
  final String userB; // recipient
  final String status; // "pending" | "accepted" | "declined" | "blocked"
  final String tripContext; // tripId that triggered the request
  final DateTime? requestedAt;
  final DateTime? respondedAt;

  // ── Deterministic ID ──────────────────────────────────────
  // Sort both UIDs and join with "_" — prevents duplicates
  static String buildId(String uidA, String uidB) {
    final sorted = [uidA, uidB]..sort();
    return sorted.join('_');
  }

  // ── fromFirestore ──────────────────────────────────────────
  factory ConnectionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConnectionModel(
      connectionId: doc.id,
      userA: data['userA'] ?? '',
      userB: data['userB'] ?? '',
      status: data['status'] ?? 'pending',
      tripContext: data['tripContext'] ?? '',
      requestedAt: (data['requestedAt'] as Timestamp?)?.toDate(),
      respondedAt: (data['respondedAt'] as Timestamp?)?.toDate(),
    );
  }

  // ── toFirestore ────────────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'userA': userA,
      'userB': userB,
      'status': status,
      'tripContext': tripContext,
      'requestedAt': FieldValue.serverTimestamp(),
      'respondedAt':
          respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
    };
  }
}
