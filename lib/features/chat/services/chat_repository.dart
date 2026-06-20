import 'dart:convert';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import 'api_client.dart';

class ChatRepository {
  final ApiClient _apiClient;

  ChatRepository(this._apiClient);

  Future<String> createDirectChat(String otherUid) async {
    final response = await _apiClient.post('/chats/direct', body: {'otherUid': otherUid});
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['chatId'];
    }
    throw Exception('Failed to create chat');
  }

  Future<String> createGroupChat({
    required String groupName,
    required List<String> members,
    required String tripId,
  }) async {
    final response = await _apiClient.post('/chats/group', body: {
      'groupName': groupName,
      'members': members,
      'tripId': tripId,
    });
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['chatId'];
    }
    throw Exception('Failed to create group chat');
  }

  Future<List<ChatModel>> getInbox() async {
    final response = await _apiClient.get('/chats');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => ChatModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<List<MessageModel>> getMessages(String chatId) async {
    final response = await _apiClient.get('/chats/$chatId/messages');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => MessageModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    await _apiClient.post('/chats/$chatId/messages', body: {'text': text});
  }

  Future<void> markAsRead(String chatId, String messageId) async {
    await _apiClient.put('/chats/$chatId/messages/$messageId/read');
  }
}
