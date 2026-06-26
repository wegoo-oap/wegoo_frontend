import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wegoo/app.dart';
import 'package:wegoo/core/routing/app_router.dart';
import 'package:wegoo/features/auth/views/splash_screen.dart';
import 'package:wegoo/features/auth/views/onboarding_screen.dart';
import 'package:wegoo/features/auth/views/phone_entry_screen.dart';
import 'package:wegoo/features/auth/views/otp_screen.dart';
import 'package:wegoo/features/auth/views/profile_setup_step1_screen.dart';
import 'package:wegoo/features/auth/views/profile_setup_step2_screen.dart';
import 'package:wegoo/features/profile/views/my_profile_screen.dart';
import 'package:wegoo/features/profile/views/settings_screen.dart';
import 'package:wegoo/features/profile/views/notifications_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  /// Helper: pumps the WegooApp wrapped in ProviderScope.
  Future<void> pumpApp(WidgetTester tester) async {
    // Set a larger screen size to prevent RenderFlex overflow on SplashScreen
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    
    await tester.pumpWidget(
      const ProviderScope(
        child: WegooApp(),
      ),
    );
    // Allow the initial route to resolve (async redirect reads secure storage)
    await tester.pump(const Duration(milliseconds: 100));
  }

  /// Navigates to [path] and pumps enough frames for the route to render.
  Future<void> navigateAndSettle(WidgetTester tester, String path) async {
    appRouter.go(path);
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));
  }

  /// Drains all pending timers so the test framework doesn't complain
  /// about "A Timer is still pending". SplashScreen fires Future.delayed
  /// at 100ms, 300ms, 500ms, and 1400ms — so pumping 2000ms total covers all.
  Future<void> drainTimers(WidgetTester tester) async {
    await tester.pump(const Duration(milliseconds: 2000));
    // Extra pump to process any last micro-task
    await tester.pump(const Duration(milliseconds: 100));
  }

  // ────────────────────────────────────────────────────────────────
  //  GROUP 1 — Unauthenticated (guest) tests
  // ────────────────────────────────────────────────────────────────

  group('Unauthenticated (Guest) Navigation Tests', () {
    setUp(() {
      // No JWT → guest
      FlutterSecureStorage.setMockInitialValues({});
    });

    testWidgets(
        'Protected route /home redirects to /splash for guest',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/home');

      expect(find.byType(SplashScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Protected route /trips redirects to /splash for guest',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/trips');

      expect(find.byType(SplashScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Protected route /messages redirects to /splash for guest',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/messages');

      expect(find.byType(SplashScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Protected route /profile redirects to /splash for guest',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/profile');

      expect(find.byType(SplashScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Protected route /settings redirects to /splash for guest',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/settings');

      expect(find.byType(SplashScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Protected route /notifications redirects to /splash for guest',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/notifications');

      expect(find.byType(SplashScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Public route /onboarding loads OnboardingScreen',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/onboarding');

      expect(find.byType(OnboardingScreen), findsOneWidget);
      // Onboarding has no timers, but we navigated FROM splash so drain those
      await drainTimers(tester);
    });

    testWidgets(
        'Public route /auth/phone loads PhoneEntryScreen',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/auth/phone');

      expect(find.byType(PhoneEntryScreen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Public route /auth/otp loads OtpScreen',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/auth/otp');

      expect(find.byType(OtpScreen), findsOneWidget);
      // OtpScreen has a Timer.periodic(1s) countdown — drain 61s to exhaust it
      for (int i = 0; i < 62; i++) {
        await tester.pump(const Duration(seconds: 1));
      }
    });

    testWidgets(
        'Public route /auth/profile/1 loads ProfileSetupStep1Screen',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/auth/profile/1');

      expect(find.byType(ProfileSetupStep1Screen), findsOneWidget);
      await drainTimers(tester);
    });

    testWidgets(
        'Public route /auth/profile/2 loads ProfileSetupStep2Screen',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/auth/profile/2');

      expect(find.byType(ProfileSetupStep2Screen), findsOneWidget);
      await drainTimers(tester);
    });
  });

  // ────────────────────────────────────────────────────────────────
  //  GROUP 2 — Authenticated (logged-in) tests
  // ────────────────────────────────────────────────────────────────

  group('Authenticated (Logged In) Navigation Tests', () {
    setUp(() {
      // Simulate a valid JWT token in secure storage
      FlutterSecureStorage.setMockInitialValues({
        'jwt_token': 'mock_valid_jwt_token',
      });
    });

    testWidgets(
        'Auth route /splash redirects to /home when logged in',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/splash');

      // The bottom nav bar also has "Discovery" as a label, so there
      // are 2 Text widgets with that string. Use findsAtLeastNWidgets.
      expect(find.text('Discovery'), findsAtLeastNWidgets(1));
    });

    testWidgets(
        'Auth route /onboarding redirects to /home when logged in',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/onboarding');

      expect(find.text('Discovery'), findsAtLeastNWidgets(1));
    });

    testWidgets(
        'Auth route /auth/phone redirects to /home when logged in',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/auth/phone');

      expect(find.text('Discovery'), findsAtLeastNWidgets(1));
    });

    testWidgets(
        '/home renders Discovery placeholder inside ShellRoute',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/home');

      // Page body shows unique subtitle text
      expect(
        find.text('Find your perfect travel buddies'),
        findsOneWidget,
      );
    });

    testWidgets(
        '/trips renders Trips placeholder inside ShellRoute',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/trips');

      expect(
        find.text('Your upcoming adventures'),
        findsOneWidget,
      );
    });

    testWidgets(
        '/messages renders Messages placeholder inside ShellRoute',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/messages');

      expect(
        find.text('Chat with your travel matches'),
        findsOneWidget,
      );
    });

    testWidgets(
        '/profile renders MyProfileScreen inside ShellRoute',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/profile');

      expect(find.byType(MyProfileScreen), findsOneWidget);
    });

    testWidgets(
        '/settings loads SettingsScreen when logged in',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/settings');

      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets(
        '/notifications loads NotificationsScreen when logged in',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/notifications');

      expect(find.byType(NotificationsScreen), findsOneWidget);
    });

    testWidgets(
        '/auth/profile/1 still loads even when logged in (profile setup bypass)',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/auth/profile/1');

      expect(find.byType(ProfileSetupStep1Screen), findsOneWidget);
    });

    testWidgets(
        '/auth/profile/2 still loads even when logged in (profile setup bypass)',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/auth/profile/2');

      expect(find.byType(ProfileSetupStep2Screen), findsOneWidget);
    });

    testWidgets(
        'Interactive test: Tapping bottom navigation bar switches tabs',
        (WidgetTester tester) async {
      await pumpApp(tester);
      await navigateAndSettle(tester, '/home');

      // Verify we are on the Home (Discovery) tab
      expect(find.text('Find your perfect travel buddies'), findsOneWidget);

      // Tap on 'Trips' tab
      await tester.tap(find.text('Trips').last);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      
      // Verify we switched to Trips tab
      expect(find.text('Your upcoming adventures'), findsOneWidget);

      // Tap on 'Messages' tab
      await tester.tap(find.text('Messages').last);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      
      // Verify we switched to Messages tab
      expect(find.text('Chat with your travel matches'), findsOneWidget);

      // Tap on 'Profile' tab
      await tester.tap(find.text('Profile').last);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
      
      // Verify we switched to Profile tab
      expect(find.byType(MyProfileScreen), findsOneWidget);
    });
  });
}
