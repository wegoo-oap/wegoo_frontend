import 'package:flutter/material.dart';
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
import '../widgets/bottom_nav_bar.dart';

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

    if (isLoggedIn && isAuthRoute) return '/home';

    final isProtected = loc.startsWith('/home') || loc.startsWith('/profile') || loc.startsWith('/trips') || loc.startsWith('/messages') || loc == '/settings' || loc == '/notifications';

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

    // Main app with bottom navigation
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (c, s) => const _DiscoveryPlaceholder()),
        GoRoute(path: '/trips', builder: (c, s) => const _TripsPlaceholder()),
        GoRoute(path: '/messages', builder: (c, s) => const _MessagesPlaceholder()),
        GoRoute(path: '/profile', builder: (c, s) => const MyProfileScreen()),
      ],
    ),

    GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    GoRoute(path: '/notifications', builder: (c, s) => const NotificationsScreen()),
  ],
);

// Temporary placeholder screens — will be replaced with real screens later

class _DiscoveryPlaceholder extends StatelessWidget {
  const _DiscoveryPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF0058BC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.explore, size: 48, color: Color(0xFF0058BC)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Discovery',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1B1B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Find your perfect travel buddies',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  color: Color(0xFF414755),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripsPlaceholder extends StatelessWidget {
  const _TripsPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFFE9400).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.travel_explore, size: 48, color: Color(0xFFFE9400)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Trips',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1B1B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your upcoming adventures',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  color: Color(0xFF414755),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MessagesPlaceholder extends StatelessWidget {
  const _MessagesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF0058BC).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(Icons.chat_bubble_outline, size: 48, color: Color(0xFF0058BC)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Messages',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1B1B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chat with your travel matches',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  color: Color(0xFF414755),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
