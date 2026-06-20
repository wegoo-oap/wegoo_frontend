import 'dart:convert';
import '../models/user_model.dart';
import 'api_client.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  String get currentUid => 'local_user_id'; // Temporary until we use JWT payload

  Future<UserModel?> getUser(String uid) async {
    final response = await _apiClient.get('/users/$uid');
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<UserModel?> getCurrentUser() async {
    final response = await _apiClient.get('/users/me');
    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<bool> profileExists(String uid) async {
    final user = await getUser(uid);
    return user != null;
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    await _apiClient.put('/users/me', body: data);
  }

  Future<void> touchLastActive() async {
    await _apiClient.put('/users/me/last-active');
  }

  Future<void> blockUser(String targetUid) async {
    await _apiClient.put('/users/me/block/$targetUid');
  }

  Future<void> unblockUser(String targetUid) async {
    await _apiClient.delete('/users/me/block/$targetUid');
  }

  Future<void> addRating(String uid, double newRating) async {
    await _apiClient.post('/users/$uid/rating', body: {'rating': newRating});
  }
}
