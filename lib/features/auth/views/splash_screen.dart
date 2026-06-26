import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Staggered entrance animations
  late AnimationController _logoController;
  late AnimationController _illustrationController;
  late AnimationController _actionsController;

  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;
  late Animation<double> _illustrationOpacity;
  late Animation<Offset> _illustrationSlide;
  late Animation<double> _actionsOpacity;
  late Animation<Offset> _actionsSlide;

  // Breathing animation for the illustration
  late AnimationController _breathingController;
  late Animation<double> _breathingScale;

  // Shimmer animation for the CTA button
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // ── Logo animation ──
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _logoSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // ── Illustration animation ──
    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _illustrationOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _illustrationController, curve: Curves.easeOut),
    );
    _illustrationSlide =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _illustrationController, curve: Curves.easeOut),
    );

    // ── Actions animation ──
    _actionsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _actionsOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _actionsController, curve: Curves.easeOut),
    );
    _actionsSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _actionsController, curve: Curves.easeOut),
    );

    // ── Breathing (subtle scale pulse on illustration) ──
    _breathingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    _breathingScale = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    // Start breathing loop after entrance animation completes
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) _breathingController.repeat(reverse: true);
    });

    // ── Shimmer on CTA button ──
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) _shimmerController.repeat();
    });

    // ── Staggered start ──
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _illustrationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _actionsController.forward();
    });

    // Auth redirect — fires after animations settle (1400ms)
    // If user is already logged in, skip splash entirely
    Future.delayed(const Duration(milliseconds: 1400), () async {
      if (!mounted) return;
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'jwt_token');
      if (token != null) {
        context.go('/home');
      }
      // If user is null — do nothing, let them tap the button
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _illustrationController.dispose();
    _actionsController.dispose();
    _breathingController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Enriched background: subtle warm gradient
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDFBFA), // warm white top
              Color(0xFFF5F0ED), // warm beige mid
              Color(0xFFEEF3FA), // subtle blue tint bottom
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ── Decorative blobs (more visible) ──
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0058BC).withOpacity(0.06),
                      const Color(0xFF0058BC).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: screenWidth * 0.75,
                height: screenWidth * 0.75,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFE9400).withOpacity(0.07),
                      const Color(0xFFFE9400).withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // Small accent blob
            Positioned(
              top: screenHeight * 0.35,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0058BC).withOpacity(0.03),
                ),
              ),
            ),

            // ── Main content ──
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // ── Logo & Tagline ──
                      FadeTransition(
                        opacity: _logoOpacity,
                        child: SlideTransition(
                          position: _logoSlide,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'weg',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 42,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: -0.8,
                                          color: Color(0xFF1C1B1B),
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: _OoText(),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Trouvez votre tribu, vivez votre Wejha.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF888888),
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 1),

                      // ── Illustration (large, with breathing animation) ──
                      FadeTransition(
                        opacity: _illustrationOpacity,
                        child: SlideTransition(
                          position: _illustrationSlide,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: ScaleTransition(
                              scale: _breathingScale,
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: screenWidth * 0.88,
                                  maxHeight: screenHeight * 0.42,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF0058BC)
                                          .withOpacity(0.08),
                                      blurRadius: 32,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 12),
                                    ),
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 16,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Image.asset(
                                    'assets/images/image.png',
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 280,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0058BC)
                                            .withOpacity(0.05),
                                        borderRadius:
                                            BorderRadius.circular(28),
                                      ),
                                      child: const Icon(
                                        Icons.travel_explore,
                                        size: 80,
                                        color: Color(0xFF0058BC),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(flex: 2),

                      // ── Actions ──
                      FadeTransition(
                        opacity: _actionsOpacity,
                        child: SlideTransition(
                          position: _actionsSlide,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                            child: Column(
                              children: [
                                _PrimaryButton(
                                  label: "C'est parti !",
                                  onTap: () => context.go('/auth/phone'),
                                  shimmerController: _shimmerController,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Déjà membre ? ',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 15,
                                        color: Color(0xFF999999),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () =>
                                          context.go('/auth/phone'),
                                      child: const Text(
                                        'Se connecter',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF0058BC),
                                          decoration:
                                              TextDecoration.underline,
                                          decorationColor: Color(0xFF0058BC),
                                          decorationThickness: 1.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).padding.bottom + 36),
                    ],
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

// ── "oo" with blue underline accent ──
class _OoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Text(
          'oo',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 42,
            fontWeight: FontWeight.w700,
            letterSpacing: -2.0,
            color: Color(0xFF0058BC),
          ),
        ),
        Positioned(
          bottom: 5,
          left: 4,
          right: 4,
          child: Container(
            height: 2.5,
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC).withOpacity(0.35),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Premium CTA button with gradient + shimmer ──
class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final AnimationController shimmerController;

  const _PrimaryButton({
    required this.label,
    required this.onTap,
    required this.shimmerController,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
        duration: const Duration(milliseconds: 120),
        child: AnimatedOpacity(
          opacity: _pressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              // Premium gradient
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0068E0), // brighter blue
                  Color(0xFF0050B5), // deep blue
                  Color(0xFF003D8F), // darker accent
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0058BC).withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFF0058BC).withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  // Shimmer overlay
                  AnimatedBuilder(
                    animation: widget.shimmerController,
                    builder: (context, child) {
                      return Positioned(
                        left: -100 +
                            (MediaQuery.of(context).size.width + 100) *
                                widget.shimmerController.value,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.0),
                                Colors.white.withOpacity(0.12),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  // Label
                  Center(
                    child: Text(
                      widget.label,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
