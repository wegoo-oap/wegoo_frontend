import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  const TripModel({
    required this.tripId,
    required this.userId,
    required this.destinationId,
    required this.destinationName,
    required this.countryCode,
    required this.startDate,
    required this.endDate,
    required this.durationDays,
    required this.tripType,
    required this.visibility,
    required this.status,
    required this.accommodation,
    required this.tripBio,
    required this.userSnapshot,
    required this.createdAt,
  });

  final String tripId;
  final String userId;
  final String destinationId; // "TN-SBS"
  final String destinationName; // "Sidi Bou Said, Tunisia"
  final String countryCode; // "TN"
  final DateTime startDate;
  final DateTime endDate;
  final int durationDays;
  final String tripType; // "SOLO" | "COUPLE" | "GROUP"
  final String visibility; // "PUBLIC" | "CONNECTIONS" | "PRIVATE"
  final String status; // "active" | "past" | "cancelled"
  final String accommodation;
  final String tripBio;
  final Map<String, dynamic> userSnapshot;
  final DateTime? createdAt;

  // ── fromFirestore ──────────────────────────────────────────
  factory TripModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TripModel(
      tripId: doc.id,
      userId: data['userId'] ?? '',
      destinationId: data['destinationId'] ?? '',
      destinationName: data['destinationName'] ?? '',
      countryCode: data['countryCode'] ?? '',
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
      durationDays: (data['durationDays'] ?? 0).toInt(),
      tripType: data['tripType'] ?? 'SOLO',
      visibility: data['visibility'] ?? 'PUBLIC',
      status: data['status'] ?? 'active',
      accommodation: data['accommodation'] ?? '',
      tripBio: data['tripBio'] ?? '',
      userSnapshot: Map<String, dynamic>.from(data['userSnapshot'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  // ── toFirestore ────────────────────────────────────────────
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'destinationId': destinationId,
      'destinationName': destinationName,
      'countryCode': countryCode,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'durationDays': durationDays,
      'tripType': tripType,
      'visibility': visibility,
      'status': status,
      'accommodation': accommodation,
      'tripBio': tripBio,
      'userSnapshot': userSnapshot,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
