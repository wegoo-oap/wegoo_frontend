import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/group_model.dart';

class GroupRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUid => _auth.currentUser!.uid;

  // ── Créer un groupe + chat associé (batch) ────────────────
  Future<Map<String, String>> createGroup({
    required String name,
    required String tripId,
    required List<String> memberUids,
    required bool isPublic,
  }) async {
    final batch = _db.batch();

    // IDs
    final groupRef = _db.collection('groups').doc();
    final chatRef = _db.collection('chats').doc();
    final allMembers = [currentUid, ...memberUids];

    // Groupe
    batch.set(groupRef, {
      'name': name,
      'adminId': currentUid,
      'members': allMembers,
      'tripId': tripId,
      'chatId': chatRef.id,
      'isPublic': isPublic,
      'itinerary': [],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Chat associé
    batch.set(chatRef, {
      'type': 'GROUP',
      'members': allMembers,
      'groupName': name,
      'groupPhotoUrl': '',
      'tripId': tripId,
      'lastMessage': {},
      'createdAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();

    return {
      'groupId': groupRef.id,
      'chatId': chatRef.id,
    };
  }

  // ── Lire un groupe (stream) ───────────────────────────────
  Stream<GroupModel?> watchGroup(String groupId) {
    return _db
        .collection('groups')
        .doc(groupId)
        .snapshots()
        .map((doc) => doc.exists ? GroupModel.fromFirestore(doc) : null);
  }

  // ── Mes groupes (stream) ──────────────────────────────────
  Stream<List<GroupModel>> watchMyGroups() {
    return _db
        .collection('groups')
        .where('members', arrayContains: currentUid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(GroupModel.fromFirestore).toList());
  }

  // ── Ajouter un membre ─────────────────────────────────────
  Future<void> addMember({
    required String groupId,
    required String chatId,
    required String newMemberUid,
  }) async {
    final batch = _db.batch();

    batch.update(_db.collection('groups').doc(groupId), {
      'members': FieldValue.arrayUnion([newMemberUid]),
    });

    batch.update(_db.collection('chats').doc(chatId), {
      'members': FieldValue.arrayUnion([newMemberUid]),
    });

    await batch.commit();
  }

  // ── Retirer un membre ─────────────────────────────────────
  Future<void> removeMember({
    required String groupId,
    required String chatId,
    required String memberUid,
  }) async {
    final batch = _db.batch();

    batch.update(_db.collection('groups').doc(groupId), {
      'members': FieldValue.arrayRemove([memberUid]),
    });

    batch.update(_db.collection('chats').doc(chatId), {
      'members': FieldValue.arrayRemove([memberUid]),
    });

    await batch.commit();
  }

  // ── Ajouter une étape à l'itinéraire ─────────────────────
  Future<void> addItineraryStep({
    required String groupId,
    required Map<String, dynamic> step,
  }) async {
    await _db.collection('groups').doc(groupId).update({
      'itinerary': FieldValue.arrayUnion([step]),
    });
  }

  // ── Supprimer une étape de l'itinéraire ──────────────────
  Future<void> removeItineraryStep({
    required String groupId,
    required Map<String, dynamic> step,
  }) async {
    await _db.collection('groups').doc(groupId).update({
      'itinerary': FieldValue.arrayRemove([step]),
    });
  }
}
