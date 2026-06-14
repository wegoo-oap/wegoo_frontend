import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/phone_entry_screen.dart';
import '../../features/auth/screens/otp_screen.dart';
import '../../features/auth/screens/profile_setup_step1_screen.dart';
import '../../features/auth/screens/profile_setup_step2_screen.dart';
import '../../features/home/screens/discovery_feed_screen.dart';
import '../../features/trips/screens/my_trips_screen.dart';
import '../../features/trips/screens/destination_picker_screen.dart';
import '../../features/trips/screens/date_picker_screen.dart';
import '../../features/trips/screens/trip_details_screen.dart';
import '../../features/trips/screens/trip_success_screen.dart';
import '../../features/trips/screens/post_trip_rating_screen.dart';
import '../../features/trips/screens/shared_itinerary_screen.dart';
import '../../features/social/screens/traveler_profile_screen.dart';
import '../../features/social/screens/direct_chat_screen.dart';
import '../../features/social/screens/group_chat_screen.dart';
import '../../features/social/screens/create_group_screen.dart';
import '../../features/social/screens/connection_requests_screen.dart';
// import '../../features/messages/screens/messages_screen.dart';
import '../../features/home/screens/map_screen.dart';
import '../../features/profile/screens/my_profile_screen.dart';
import '../../features/social/screens/messages_screen.dart';
import '../../features/profile/screens/notifications_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../../features/social/screens/group_members_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',

  // ── Auth guard ───────────────────────────────────────────────
  // If the user is already logged in, skip splash/auth screens
  // and go straight to /home.
  // If the user is NOT logged in and tries to access a protected
  // route, send them back to /splash.
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final loc = state.matchedLocation;

    // Profile setup routes — toujours laisser passer
    // même si l'utilisateur est connecté
    final isProfileSetup = loc == '/auth/profile/1' || loc == '/auth/profile/2';
    if (isProfileSetup) return null;

    final isAuthRoute =
        loc == '/splash' || loc == '/onboarding' || loc.startsWith('/auth');

    // Connecté + sur écran auth → home
    if (user != null && isAuthRoute) return '/home';

    // Non connecté + route protégée → splash
    final isProtected = loc.startsWith('/home') ||
        loc.startsWith('/trips') ||
        loc.startsWith('/profile') ||
        loc.startsWith('/messages') ||
        loc.startsWith('/trip') ||
        loc.startsWith('/user') ||
        loc.startsWith('/chat') ||
        loc.startsWith('/groups') ||
        loc.startsWith('/connections') ||
        loc == '/settings' ||
        loc == '/notifications';

    if (user == null && isProtected) return '/splash';

    return null;
  },

  routes: [
    // ── Auth ──────────────────────────────────────────────────
    GoRoute(
      path: '/splash',
      builder: (c, s) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (c, s) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth/phone',
      builder: (c, s) => const PhoneEntryScreen(),
    ),
    GoRoute(
      path: '/auth/otp',
      builder: (c, s) => const OtpScreen(),
    ),
    GoRoute(
      path: '/auth/profile/1',
      builder: (c, s) => const ProfileSetupStep1Screen(),
    ),
    GoRoute(
      path: '/auth/profile/2',
      builder: (c, s) => const ProfileSetupStep2Screen(),
    ),

    // ── Main shell (bottom nav) ────────────────────────────────
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (c, s) => const DiscoveryFeedScreen(),
        ),
        GoRoute(path: '/map', builder: (c, s) => const MapScreen()),
        GoRoute(
          path: '/trips',
          builder: (c, s) => const MyTripsScreen(),
        ),
        GoRoute(path: '/messages', builder: (c, s) => const MessagesScreen()),
        GoRoute(
          path: '/profile',
          builder: (c, s) => const MyProfileScreen(),
        ),
      ],
    ),

    // ── Trip declaration flow ──────────────────────────────────
    GoRoute(
      path: '/trip/new/destination',
      builder: (c, s) => const DestinationPickerScreen(),
    ),
    GoRoute(
      path: '/trip/new/dates',
      builder: (c, s) => const DatePickerScreen(),
    ),
    GoRoute(
      path: '/trip/new/details',
      builder: (c, s) => const TripDetailsScreen(),
    ),
    GoRoute(
      path: '/trip/new/success',
      builder: (c, s) => const TripSuccessScreen(),
    ),
    GoRoute(
      path: '/trip/rate',
      builder: (c, s) => PostTripRatingScreen(
        travelerName: s.uri.queryParameters['name'] ?? 'Elena Rossi',
        tripEndedLabel:
            s.uri.queryParameters['ended'] ?? 'Trip ended 24 hours ago.',
      ),
    ),
    GoRoute(
      path: '/trip/itinerary',
      builder: (c, s) => SharedItineraryScreen(
        tripTitle: s.uri.queryParameters['title'] ?? 'Amalfi Coast Wonders',
      ),
    ),

    // ── Social ────────────────────────────────────────────────
    GoRoute(
      path: '/user/:id',
      builder: (c, s) => TravelerProfileScreen(userId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/chat/:id',
      builder: (c, s) => DirectChatScreen(chatId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/groups/new',
      builder: (c, s) => const CreateGroupScreen(),
    ),
    GoRoute(
      path: '/groups/:id/chat',
      builder: (c, s) => GroupChatScreen(groupId: s.pathParameters['id']!),
    ),
    GoRoute(
      path: '/connections/requests',
      builder: (c, s) => const ConnectionRequestsScreen(),
    ),
    GoRoute(
      path: '/groups/:id/members',
      builder: (c, s) => GroupMembersScreen(groupId: s.pathParameters['id']!),
    ),
// ──Profile ────────────────────────────────────────────────
    GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
    GoRoute(
        path: '/notifications', builder: (c, s) => const NotificationsScreen()),
  ],
);
