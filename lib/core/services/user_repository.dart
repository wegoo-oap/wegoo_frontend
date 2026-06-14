import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class UserRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUid => _auth.currentUser!.uid;

  // ── Lire un utilisateur une fois ──────────────────────────
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  // ── Écouter un utilisateur en temps réel ──────────────────
  Stream<UserModel?> watchUser(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }

  // ── Écouter mon propre profil ─────────────────────────────
  Stream<UserModel?> watchCurrentUser() => watchUser(currentUid);

  // ── Vérifier si le profil est complet ─────────────────────
  Future<bool> profileExists(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists;
  }

  // ── Créer / mettre à jour (merge) ─────────────────────────
  Future<void> updateUser(Map<String, dynamic> data) async {
    await _db
        .collection('users')
        .doc(currentUid)
        .set(data, SetOptions(merge: true));
  }

  // ── Mettre à jour lastActive ──────────────────────────────
  Future<void> touchLastActive() async {
    await _db.collection('users').doc(currentUid).update({
      'lastActive': FieldValue.serverTimestamp(),
    });
  }

  // ── Bloquer un utilisateur ────────────────────────────────
  Future<void> blockUser(String targetUid) async {
    await _db.collection('users').doc(currentUid).update({
      'blockedUsers': FieldValue.arrayUnion([targetUid]),
    });
  }

  // ── Débloquer un utilisateur ──────────────────────────────
  Future<void> unblockUser(String targetUid) async {
    await _db.collection('users').doc(currentUid).update({
      'blockedUsers': FieldValue.arrayRemove([targetUid]),
    });
  }

  // ── Mettre à jour la note moyenne ─────────────────────────
  // Appelé après réception d'une nouvelle note
  Future<void> addRating(String uid, double newRating) async {
    final doc = await _db.collection('users').doc(uid).get();
    final data = doc.data()!;
    final currentRating = (data['rating'] ?? 0.0).toDouble();
    final currentCount = (data['ratingCount'] ?? 0).toInt();
    final newCount = currentCount + 1;
    final newAverage = ((currentRating * currentCount) + newRating) / newCount;

    await _db.collection('users').doc(uid).update({
      'rating': newAverage,
      'ratingCount': newCount,
    });
  }
}
