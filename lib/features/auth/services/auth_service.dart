import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthService(this._apiClient);

  Future<void> sendOtp(String phoneNumber) async {
    // Stub: POST /auth/send-otp
    final response = await _apiClient.post('/auth/send-otp', body: {'phone': phoneNumber});
    if (response.statusCode != 200) {
      throw Exception('Failed to send OTP');
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otpCode) async {
    // Stub: POST /auth/verify-otp
    final response = await _apiClient.post('/auth/verify-otp', body: {
      'phone': phoneNumber,
      'code': otpCode,
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
