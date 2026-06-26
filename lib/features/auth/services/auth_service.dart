import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wegoo/core/network/api_client.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: '703788374349-mh2usfvek49c15ehph37surul5tb8vt1.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? account = await googleSignIn.signIn();
      
      if (account == null) {
        return false;
      }
      
      final GoogleSignInAuthentication auth = await account.authentication;
      final String? idToken = auth.idToken;
      
      if (idToken == null) {
        return false;
      }
      
      final response = await _apiClient.post('/api/auth/google', body: {
        'idToken': idToken,
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
    } catch (error) {
      return false;
    }
  }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId: '703788374349-mh2usfvek49c15ehph37surul5tb8vt1.apps.googleusercontent.com',
    );
    try {
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (_) {}
    await _storage.delete(key: 'jwt_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'jwt_token');
    return token != null;
  }
}
