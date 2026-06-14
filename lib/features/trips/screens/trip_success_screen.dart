import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripSuccessScreen extends StatefulWidget {
  const TripSuccessScreen({super.key});

  @override
  State<TripSuccessScreen> createState() => _TripSuccessScreenState();
}

class _TripSuccessScreenState extends State<TripSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _entryController;
  late AnimationController _floatController;
  late Animation<double> _entryScale;
  late Animation<double> _entryOpacity;
  late Animation<double> _floatAnimation;

  final List<_ConfettiParticle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Entry animation
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _entryScale = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: const Cubic(0.175, 0.885, 0.32, 1.275),
      ),
    );
    _entryOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOut),
    );

    // Float animation
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(begin: 0, end: -20).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    // Start entry after short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _entryController.forward();
    });

    // Generate confetti particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_ConfettiParticle(
        x: _random.nextDouble(),
        size: _random.nextDouble() * 8 + 4,
        color: [
          const Color(0xFF0058BC),
          const Color(0xFFFE9400),
          const Color(0xFFFFB874),
          const Color(0xFFADC6FF),
        ][_random.nextInt(4)],
        duration: _random.nextDouble() * 5000 + 5000,
        delay: _random.nextDouble() * 5000,
        isCircle: _random.nextBool(),
        opacity: _random.nextDouble() * 0.5 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _entryController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Stack(
        children: [
          // Confetti background
          ..._particles.map((p) => _ConfettiWidget(particle: p)),

          // Main content
          SafeArea(
            child: ScaleTransition(
              scale: _entryScale,
              child: FadeTransition(
                opacity: _entryOpacity,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 40),

                            // Hero section
                            _buildHero(),
                            const SizedBox(height: 32),

                            // Copy
                            _buildCopy(),
                            const SizedBox(height: 32),

                            // Action buttons
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _buildActions(context),
                            ),
                            const SizedBox(height: 32),

                            // Trip card
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _buildTripCard(),
                            ),
                            const SizedBox(height: 32),

                            // Footer branding
                            Text(
                              'WEGOO',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 8,
                                color:
                                    const Color(0xFF0058BC).withOpacity(0.15),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
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
    );
  }

  Widget _buildHero() {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Blurred background circle
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF0058BC).withOpacity(0.05),
            ),
          ),

          // Floating content
          AnimatedBuilder(
            animation: _floatAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: child,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Checkmark circle
                Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0058BC),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0058BC).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),

                // Overlapping avatars
                SizedBox(
                  height: 56,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _Avatar(offset: 0, color: const Color(0xFFD8E2FF)),
                      _Avatar(offset: 32, color: const Color(0xFFFFDCBF)),
                      _Avatar(offset: 64, color: const Color(0xFFD8E2FF)),
                      Positioned(
                        left: 96,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFE9400),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFFFCF9F8), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Text(
                              '+9',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF633700),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCopy() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const Text(
            'Trip Published!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.56,
              color: Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                color: Color(0xFF414755),
                height: 1.5,
              ),
              children: [
                TextSpan(text: '12 people are also going to '),
                TextSpan(
                  text: 'Amalfi Coast',
                  style: TextStyle(
                    color: Color(0xFF0058BC),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(text: ' this week. Connect with them!'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        // Primary — See who's going
        _ActionButton(
          label: "See who's going",
          icon: Icons.group,
          isPrimary: true,
          onTap: () => context.go('/home'),
        ),
        const SizedBox(height: 12),
        // Secondary — Go to home
        _ActionButton(
          label: 'Go to home',
          isPrimary: false,
          onTap: () => context.go('/home'),
        ),
      ],
    );
  }

  Widget _buildTripCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E2E1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Destination thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0058BC).withOpacity(0.5),
                    const Color(0xFFFE9400).withOpacity(0.6),
                  ],
                ),
              ),
              child: const Icon(Icons.travel_explore,
                  color: Colors.white70, size: 32),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR NEW TRIP',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFF8C5000),
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Amalfi Coastal Escape',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1B1B),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.calendar_month,
                        size: 14, color: Color(0xFF414755)),
                    SizedBox(width: 4),
                    Text(
                      'Oct 12 - Oct 18',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: Color(0xFF414755),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Avatar ───────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  final double offset;
  final Color color;

  const _Avatar({required this.offset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFCF9F8), width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
            ),
          ],
        ),
        child: const Icon(Icons.person, color: Colors.white70, size: 24),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    this.icon,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
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
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            color:
                widget.isPrimary ? const Color(0xFF0058BC) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: widget.isPrimary
                ? null
                : Border.all(color: const Color(0xFFC1C6D7), width: 2),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF0058BC).withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color:
                      widget.isPrimary ? Colors.white : const Color(0xFF0058BC),
                ),
              ),
              if (widget.icon != null) ...[
                const SizedBox(width: 8),
                Icon(
                  widget.icon,
                  color:
                      widget.isPrimary ? Colors.white : const Color(0xFF0058BC),
                  size: 20,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ── Confetti ──────────────────────────────────────────────────

class _ConfettiParticle {
  final double x;
  final double size;
  final Color color;
  final double duration;
  final double delay;
  final bool isCircle;
  final double opacity;

  _ConfettiParticle({
    required this.x,
    required this.size,
    required this.color,
    required this.duration,
    required this.delay,
    required this.isCircle,
    required this.opacity,
  });
}

class _ConfettiWidget extends StatefulWidget {
  final _ConfettiParticle particle;

  const _ConfettiWidget({required this.particle});

  @override
  State<_ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<_ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fallAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.particle.duration.toInt()),
    );

    _fallAnimation = Tween<double>(begin: -0.1, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    Future.delayed(
      Duration(milliseconds: widget.particle.delay.toInt()),
      () {
        if (mounted) _controller.repeat();
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        return Positioned(
          left: widget.particle.x * screenWidth,
          top: _fallAnimation.value * screenHeight,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Opacity(
              opacity: widget.particle.opacity,
              child: Container(
                width: widget.particle.size,
                height: widget.particle.size,
                decoration: BoxDecoration(
                  color: widget.particle.color,
                  shape: widget.particle.isCircle
                      ? BoxShape.circle
                      : BoxShape.rectangle,
                  borderRadius: widget.particle.isCircle
                      ? null
                      : BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
