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
  late AnimationController _logoController;
  late AnimationController _illustrationController;
  late AnimationController _actionsController;

  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;
  late Animation<double> _illustrationOpacity;
  late Animation<Offset> _illustrationSlide;
  late Animation<double> _actionsOpacity;
  late Animation<Offset> _actionsSlide;

  Offset _parallaxOffset = Offset.zero;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

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

    _illustrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _illustrationOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _illustrationController, curve: Curves.easeOut),
    );
    _illustrationSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
      CurvedAnimation(parent: _illustrationController, curve: Curves.easeOut),
    );

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

    // Staggered animation start
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _illustrationController.forward();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _actionsController.forward();
    });

    // Auth redirect â€” fires after animations settle (1400ms)
    // If user is already logged in, skip splash entirely
    Future.delayed(const Duration(milliseconds: 1400), () async {
      if (!mounted) return;
      const storage = FlutterSecureStorage();
      final token = await storage.read(key: 'jwt_token');
      if (token != null) {
        context.go('/home');
      }
      // If user is null â€” do nothing, let them tap the button
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _illustrationController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: MouseRegion(
        onHover: (event) {
          final size = MediaQuery.of(context).size;
          final dx = (size.width / 2 - event.position.dx) / 50;
          final dy = (size.height / 2 - event.position.dy) / 50;
          setState(() => _parallaxOffset = Offset(dx, dy));
        },
        child: Stack(
          children: [
            // Background decorative blobs
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF0058BC).withOpacity(0.03),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              left: -60,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFE9400).withOpacity(0.05),
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Logo & Tagline
                      FadeTransition(
                        opacity: _logoOpacity,
                        child: SlideTransition(
                          position: _logoSlide,
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'weg',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.72,
                                        color: Color(0xFF1C1B1B),
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: _OoText(),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Trouvez votre tribu, vivez votre Wejha.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFF666666),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Illustration
                      Expanded(
                        child: FadeTransition(
                          opacity: _illustrationOpacity,
                          child: SlideTransition(
                            position: _illustrationSlide,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 100),
                                  transform: Matrix4.translationValues(
                                    _parallaxOffset.dx,
                                    _parallaxOffset.dy,
                                    0,
                                  ),
                                  constraints: const BoxConstraints(
                                    maxWidth: 340,
                                    maxHeight: 300,
                                  ),
                                  child: Image.asset(
                                    'assets/images/onboarding.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (c, e, s) => Container(
                                      width: 280,
                                      height: 280,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0058BC)
                                            .withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      child: const Icon(
                                        Icons.travel_explore,
                                        size: 80,
                                        color: Color(0xFF0058BC),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                                // Pagination dots
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF0058BC),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE5E2E1),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE5E2E1),
                                        borderRadius: BorderRadius.circular(99),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Actions
                      FadeTransition(
                        opacity: _actionsOpacity,
                        child: SlideTransition(
                          position: _actionsSlide,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                            child: Column(
                              children: [
                                _PrimaryButton(
                                  label: "C'est parti !",
                                  onTap: () => context.go('/auth/phone'),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'DÃ©jÃ  membre ? ',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 15,
                                        color: Color(0xFF666666),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => context.go('/auth/phone'),
                                      child: const Text(
                                        'Se connecter',
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF0058BC),
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

// "oo" with blue underline accent
class _OoText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Text(
          'oo',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.8,
            color: Color(0xFF0058BC),
          ),
        ),
        Positioned(
          bottom: 4,
          left: 4,
          right: 4,
          child: Container(
            height: 2,
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC).withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}

// Primary button with press animation
class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

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
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: _pressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: double.infinity,
            height: 60,
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
            child: Center(
              child: Text(
                widget.label,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
