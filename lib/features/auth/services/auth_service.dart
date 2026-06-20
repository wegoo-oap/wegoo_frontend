import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wegoo/core/network/api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService(this._apiClient);

  Future<void> sendOtp(String phoneNumber) async {
    // Appel réel au backend Node.js
    final response = await _apiClient.post('/api/auth/phone', body: {'phone': phoneNumber});
    if (response.statusCode != 200) {
      final message = jsonDecode(response.body)['message'] ?? 'Failed to send OTP';
      throw Exception(message);
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otpCode) async {
    // Appel réel au backend Node.js
    final response = await _apiClient.post('/api/auth/verify', body: {
      'phone': phoneNumber,
      'otp': otpCode,
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      if (token != null) {
        await _storage.write(key: 'jwt_token', value: token);
        return true;
      }
    }
    return false;
  }

  Future<void> signOut() async {
    await _storage.delete(key: 'jwt_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }
}
