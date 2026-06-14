import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  const MatchModel({
    required this.matchId,
    required this.score,
    required this.tripA,
    required this.tripB,
    required this.userA,
    required this.userB,
    required this.destination,
    required this.dateOverlap,
    required this.computedAt,
  });

  final String matchId; // matchedTripId (document ID)
  final double score; // 0 → 100
  final String tripA; // my tripId
  final String tripB; // matched tripId
  final String userA; // my userId
  final String userB; // matched userId
  final String destination; // destinationId
  final int dateOverlap; // overlap in days
  final DateTime? computedAt;

  // ── fromFirestore ──────────────────────────────────────────
  // Path: /trips/{tripId}/matches/{matchedTripId}
  factory MatchModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MatchModel(
      matchId: doc.id,
      score: (data['score'] ?? 0.0).toDouble(),
      tripA: data['tripA'] ?? '',
      tripB: data['tripB'] ?? '',
      userA: data['userA'] ?? '',
      userB: data['userB'] ?? '',
      destination: data['destination'] ?? '',
      dateOverlap: (data['dateOverlap'] ?? 0).toInt(),
      computedAt: (data['computedAt'] as Timestamp?)?.toDate(),
    );
  }

  // ── toFirestore ────────────────────────────────────────────
  // Written only by Cloud Function — admin SDK bypasses rules
  Map<String, dynamic> toFirestore() {
    return {
      'score': score,
      'tripA': tripA,
      'tripB': tripB,
      'userA': userA,
      'userB': userB,
      'destination': destination,
      'dateOverlap': dateOverlap,
      'computedAt': FieldValue.serverTimestamp(),
    };
  }
}
