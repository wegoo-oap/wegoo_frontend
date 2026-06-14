import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────
//  Travel Match Overlay — shown on top of discovery feed
//  when a mutual swipe-right happens
// ─────────────────────────────────────────────────────────────
class TravelMatchOverlay extends StatefulWidget {
  const TravelMatchOverlay({
    super.key,
    required this.myPhotoUrl,
    required this.matchName,
    required this.matchPhotoUrl,
    required this.destination,
    required this.onMessage,
    required this.onKeepSwiping,
  });

  final String myPhotoUrl;
  final String matchName;
  final String matchPhotoUrl;
  final String destination;
  final VoidCallback onMessage;
  final VoidCallback onKeepSwiping;

  @override
  State<TravelMatchOverlay> createState() => _TravelMatchOverlayState();
}

class _TravelMatchOverlayState extends State<TravelMatchOverlay>
    with TickerProviderStateMixin {
  // Badge bounce
  late AnimationController _badgeCtrl;
  // Avatars float
  late AnimationController _floatCtrl;
  late Animation<double> _float1;
  late Animation<double> _float2;
  // Entry fade + scale
  late AnimationController _entryCtrl;
  late Animation<double> _entryFade;
  late Animation<double> _entryScale;

  @override
  void initState() {
    super.initState();

    _badgeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _float1 = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );
    _float2 = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(
        parent: _floatCtrl,
        curve: const Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _entryFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );
    _entryScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _badgeCtrl.dispose();
    _floatCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // ── Background image ──────────────────────────
            Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuC3xwcIImg1aOe0jR5eMmhtHqOn-OsTNy8MIviIIcanr6X3Pg0ZEvsZcuP7_GGUSQ1T1SCBiFLJRzqJR8RwRZN3uBUaNv8b8-AHG3BbPDoCMGqmM0FlbG2854nraYA3tnqttK4qeA4MYscsLHdxWZmX5uHf6cZ3AS0UaEit1Y2M9apKoK9UvNEB8SCaZWCtzlqnOjhK6MjB9s3RJizDaXB-IakShls6AmSUtDhVyhsXcm8omSFx8LCzF6nNSqB148vX3LT4lgMTkQQG',
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0058BC), Color(0xFF0070EB)],
                  ),
                ),
              ),
            ),

            // ── Frosted glass overlay ─────────────────────
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                color: Colors.white.withOpacity(0.85),
              ),
            ),

            // ── Decorative icons ──────────────────────────
            Positioned(
              top: 80,
              left: 32,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  Icons.flight_takeoff,
                  size: 72,
                  color: const Color(0xFF0058BC),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              right: 32,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  Icons.explore,
                  size: 72,
                  color: const Color(0xFF8C5000),
                ),
              ),
            ),

            // ── Main content ──────────────────────────────
            FadeTransition(
              opacity: _entryFade,
              child: ScaleTransition(
                scale: _entryScale,
                child: SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bouncing badge
                          AnimatedBuilder(
                            animation: _badgeCtrl,
                            builder: (_, __) => Transform.translate(
                              offset: Offset(0, -6 * _badgeCtrl.value),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFE9400),
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  'NEW CONNECTION FOUND',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: Color(0xFF633700),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Headline
                          const Text(
                            "It's a Travel Match!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.56,
                              color: Color(0xFF0058BC),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Avatars + heart
                          _AvatarPair(
                            myPhotoUrl: widget.myPhotoUrl,
                            matchPhotoUrl: widget.matchPhotoUrl,
                            float1: _float1,
                            float2: _float2,
                          ),
                          const SizedBox(height: 32),

                          // Description
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 16,
                                color: Color(0xFF414755),
                                height: 1.5,
                              ),
                              children: [
                                const TextSpan(text: 'You and '),
                                TextSpan(
                                  text: widget.matchName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1C1B1B),
                                  ),
                                ),
                                const TextSpan(text: ' are both heading to '),
                                TextSpan(
                                  text: widget.destination,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF8C5000),
                                  ),
                                ),
                                const TextSpan(
                                    text:
                                        '. Start planning your journey together!'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Action buttons
                          _MessageButton(onTap: widget.onMessage),
                          const SizedBox(height: 12),
                          _KeepSwipingButton(onTap: widget.onKeepSwiping),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Avatar Pair — two floating avatars with heart in the middle
// ─────────────────────────────────────────────────────────────
class _AvatarPair extends StatelessWidget {
  const _AvatarPair({
    required this.myPhotoUrl,
    required this.matchPhotoUrl,
    required this.float1,
    required this.float2,
  });
  final String myPhotoUrl;
  final String matchPhotoUrl;
  final Animation<double> float1;
  final Animation<double> float2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 112,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // My avatar — left
          Positioned(
            left: 0,
            child: AnimatedBuilder(
              animation: float1,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, float1.value),
                child: child,
              ),
              child: _Avatar(photoUrl: myPhotoUrl),
            ),
          ),

          // Heart icon — center
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFE9400),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFE9400).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite,
              color: Color(0xFF633700),
              size: 28,
            ),
          ),

          // Match avatar — right
          Positioned(
            right: 0,
            child: AnimatedBuilder(
              animation: float2,
              builder: (_, child) => Transform.translate(
                offset: Offset(0, float2.value),
                child: child,
              ),
              child: _Avatar(photoUrl: matchPhotoUrl),
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.photoUrl});
  final String photoUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          photoUrl,
          fit: BoxFit.cover,
          errorBuilder: (c, e, s) => Container(
            color: const Color(0xFFEBE7E7),
            child: const Icon(Icons.person, size: 40, color: Color(0xFF717786)),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Send Message Button
// ─────────────────────────────────────────────────────────────
class _MessageButton extends StatefulWidget {
  const _MessageButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_MessageButton> createState() => _MessageButtonState();
}

class _MessageButtonState extends State<_MessageButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF0058BC),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0058BC).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.send, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Send a Message',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Keep Swiping Button
// ─────────────────────────────────────────────────────────────
class _KeepSwipingButton extends StatefulWidget {
  const _KeepSwipingButton({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_KeepSwipingButton> createState() => _KeepSwipingButtonState();
}

class _KeepSwipingButtonState extends State<_KeepSwipingButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFF717786),
              width: 2,
            ),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Keep Swiping',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1B),
              letterSpacing: 0.16,
            ),
          ),
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────────────────────
//  How to use TravelMatchOverlay inside DiscoveryFeedScreen:
//
//  When a right-swipe happens and the backend confirms a mutual
//  match, push this as a full-screen route or show it as an
//  overlay using a Stack in the parent widget:
//
//  if (_showMatchOverlay)
//    TravelMatchOverlay(
//      myPhotoUrl: currentUserPhoto,
//      matchName: 'Sarah',
//      matchPhotoUrl: matchedUserPhoto,
//      destination: 'Sidi Bou Said',
//      onMessage: () {
//        setState(() => _showMatchOverlay = false);
//        context.push('/chat/new-chat-id');
//      },
//      onKeepSwiping: () {
//        setState(() => _showMatchOverlay = false);
//      },
//    ),
// ─────────────────────────────────────────────────────────────