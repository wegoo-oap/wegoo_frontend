import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUid => _auth.currentUser!.uid;

  // ── Créer un chat direct ──────────────────────────────────
  Future<String> createDirectChat(String otherUid) async {
    final chatId = ChatModel.buildDirectId(currentUid, otherUid);
    final ref = _db.collection('chats').doc(chatId);
    final existing = await ref.get();

    if (!existing.exists) {
      await ref.set({
        'type': 'DIRECT',
        'members': [currentUid, otherUid],
        'groupName': '',
        'groupPhotoUrl': '',
        'tripId': '',
        'lastMessage': {},
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    return chatId;
  }

  // ── Créer un chat de groupe ───────────────────────────────
  Future<String> createGroupChat({
    required String groupName,
    required List<String> members,
    required String tripId,
  }) async {
    final ref = _db.collection('chats').doc();
    await ref.set({
      'type': 'GROUP',
      'members': members,
      'groupName': groupName,
      'groupPhotoUrl': '',
      'tripId': tripId,
      'lastMessage': {},
      'createdAt': FieldValue.serverTimestamp(),
    });
    return ref.id;
  }

  // ── Tous mes chats (inbox, stream) ────────────────────────
  Stream<List<ChatModel>> watchInbox() {
    return _db
        .collection('chats')
        .where('members', arrayContains: currentUid)
        .orderBy('lastMessage.sentAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ChatModel.fromFirestore).toList());
  }

  // ── Messages d'un chat (stream, paginés) ──────────────────
  Stream<List<MessageModel>> watchMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(40)
        .snapshots()
        .map((snap) => snap.docs.map(MessageModel.fromFirestore).toList());
  }

  // ── Envoyer un message ────────────────────────────────────
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final batch = _db.batch();

    // Nouveau message dans la sous-collection
    final msgRef =
        _db.collection('chats').doc(chatId).collection('messages').doc();

    batch.set(msgRef, {
      'senderId': currentUid,
      'text': text,
      'sentAt': FieldValue.serverTimestamp(),
      'readBy': [currentUid],
    });

    // Mise à jour de lastMessage sur le chat parent
    batch.update(
      _db.collection('chats').doc(chatId),
      {
        'lastMessage': {
          'text': text,
          'senderId': currentUid,
          'sentAt': FieldValue.serverTimestamp(),
        },
      },
    );

    await batch.commit();
  }

  // ── Marquer les messages comme lus ────────────────────────
  Future<void> markAsRead(String chatId, String messageId) async {
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'readBy': FieldValue.arrayUnion([currentUid]),
    });
  }
}
