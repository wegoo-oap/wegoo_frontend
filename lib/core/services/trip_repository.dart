import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/trip_model.dart';
import '../models/match_model.dart';

class TripRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUid => _auth.currentUser!.uid;

  // ── Créer un voyage ────────────────────────────────────────
  Future<String> createTrip(TripModel trip) async {
    final ref = _db.collection('trips').doc();
    await ref.set(trip.toFirestore());
    return ref.id; // retourne le tripId généré
  }

  // ── Lire un voyage ─────────────────────────────────────────
  Future<TripModel?> getTrip(String tripId) async {
    final doc = await _db.collection('trips').doc(tripId).get();
    if (!doc.exists) return null;
    return TripModel.fromFirestore(doc);
  }

  // ── Mes voyages (stream) ───────────────────────────────────
  Stream<List<TripModel>> watchUserTrips() {
    return _db
        .collection('trips')
        .where('userId', isEqualTo: currentUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(TripModel.fromFirestore).toList());
  }

  // ── Voyage actif de l'utilisateur ─────────────────────────
  Future<TripModel?> getActiveTrip() async {
    final snap = await _db
        .collection('trips')
        .where('userId', isEqualTo: currentUid)
        .where('status', isEqualTo: 'active')
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return TripModel.fromFirestore(snap.docs.first);
  }

  // ── Annuler un voyage ──────────────────────────────────────
  Future<void> cancelTrip(String tripId) async {
    await _db.collection('trips').doc(tripId).update({
      'status': 'cancelled',
    });
  }

  // ── Matches d'un voyage (stream, triés par score) ──────────
  Stream<List<MatchModel>> watchMatches(String tripId) {
    return _db
        .collection('trips')
        .doc(tripId)
        .collection('matches')
        .orderBy('score', descending: true)
        .limit(50)
        .snapshots()
        .map((snap) => snap.docs.map(MatchModel.fromFirestore).toList());
  }

  // ── Marquer un voyage comme passé ─────────────────────────
  Future<void> markTripAsPast(String tripId) async {
    await _db.collection('trips').doc(tripId).update({
      'status': 'past',
    });
  }
}
