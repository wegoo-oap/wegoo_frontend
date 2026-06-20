import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../services/auth_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient);
});

final isLoggedInProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isLoggedIn();
});

final verificationIdProvider = StateProvider<String?>((_) => null);
final phoneNumberProvider = StateProvider<String?>((_) => null);
