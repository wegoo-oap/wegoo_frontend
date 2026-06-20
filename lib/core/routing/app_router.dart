import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/views/splash_screen.dart';
import '../../features/auth/views/onboarding_screen.dart';
import '../../features/auth/views/phone_entry_screen.dart';
import '../../features/auth/views/otp_screen.dart';
import '../../features/auth/views/profile_setup_step1_screen.dart';
import '../../features/auth/views/profile_setup_step2_screen.dart';
import '../../features/profile/views/my_profile_screen.dart';
import '../../features/profile/views/settings_screen.dart';
import '../../features/profile/views/notifications_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'jwt_token');
    final isLoggedIn = token != null;
    final loc = state.matchedLocation;

    final isProfileSetup = loc == '/auth/profile/1' || loc == '/auth/profile/2';
    if (isProfileSetup) return null;

    final isAuthRoute = loc == '/splash' || loc == '/onboarding' || loc.startsWith('/auth');

    if (isLoggedIn && isAuthRoute) return '/profile'; // Temporary until we add swipe

    final isProtected = loc.startsWith('/profile') || loc == '/settings' || loc == '/notifications';

    if (!isLoggedIn && isProtected) return '/splash';

    return null;
  },

  routes: [
    GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
    GoRoute(path: '/auth/phone', builder: (c, s) => const PhoneEntryScreen()),
    GoRoute(path: '/auth/otp', builder: (c, s) => const OtpScreen()),
    GoRoute(path: '/auth/profile/1', builder: (c, s) => const ProfileSetupStep1Screen()),
    GoRoute(path: '/auth/profile/2', builder: (c, s) => const ProfileSetupStep2Screen()),
    GoRoute(path: '/profile', builder: (c, s) => const MyProfileScreen()),
    GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    GoRoute(path: '/notifications', builder: (c, s) => const NotificationsScreen()),
  ],
);
