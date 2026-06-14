import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/connection_model.dart';

class ConnectionRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUid => _auth.currentUser!.uid;

  // ── Envoyer une demande de connexion ──────────────────────
  Future<void> sendRequest({
    required String targetUid,
    required String tripContext,
  }) async {
    final connectionId = ConnectionModel.buildId(currentUid, targetUid);

    await _db.collection('connections').doc(connectionId).set({
      'userA': currentUid,
      'userB': targetUid,
      'status': 'pending',
      'tripContext': tripContext,
      'requestedAt': FieldValue.serverTimestamp(),
      'respondedAt': null,
    });
  }

  // ── Accepter une demande ──────────────────────────────────
  Future<void> acceptRequest(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'accepted',
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Décliner une demande ──────────────────────────────────
  Future<void> declineRequest(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'declined',
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Bloquer via connexion ─────────────────────────────────
  Future<void> blockConnection(String connectionId) async {
    await _db.collection('connections').doc(connectionId).update({
      'status': 'blocked',
      'respondedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Vérifier si connectés ─────────────────────────────────
  Future<bool> areConnected(String otherUid) async {
    final id = ConnectionModel.buildId(currentUid, otherUid);
    final doc = await _db.collection('connections').doc(id).get();
    if (!doc.exists) return false;
    return doc.data()!['status'] == 'accepted';
  }

  // ── Vérifier le statut d'une connexion ───────────────────
  Future<String?> getConnectionStatus(String otherUid) async {
    final id = ConnectionModel.buildId(currentUid, otherUid);
    final doc = await _db.collection('connections').doc(id).get();
    if (!doc.exists) return null;
    return doc.data()!['status'] as String?;
  }

  // ── Demandes reçues en attente (stream) ───────────────────
  Stream<List<ConnectionModel>> watchIncomingRequests() {
    return _db
        .collection('connections')
        .where('userB', isEqualTo: currentUid)
        .where('status', isEqualTo: 'pending')
        .orderBy('requestedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ConnectionModel.fromFirestore).toList());
  }

  // ── Mes connexions acceptées (stream) ─────────────────────
  Stream<List<ConnectionModel>> watchAcceptedConnections() {
    return _db
        .collection('connections')
        .where('userA', isEqualTo: currentUid)
        .where('status', isEqualTo: 'accepted')
        .snapshots()
        .map((snap) => snap.docs.map(ConnectionModel.fromFirestore).toList());
  }
}
