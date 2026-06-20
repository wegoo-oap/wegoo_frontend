import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wegoo/features/auth/controllers/auth_providers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen>
    with TickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isComplete = false;
  bool _isLoading = false;
  bool _showResend = false;
  int _timeLeft = 60;
  Timer? _timer;

  // Success overlay
  bool _showSuccess = false;
  late AnimationController _overlayController;
  late AnimationController _scaleController;
  late AnimationController _bounceController;
  late Animation<double> _overlayOpacity;
  late Animation<double> _cardScale;

  @override
  void initState() {
    super.initState();

    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _overlayOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _overlayController, curve: Curves.easeOut),
    );
    _cardScale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft <= 0) {
        t.cancel();
        setState(() => _showResend = true);
      } else {
        setState(() => _timeLeft--);
      }
    });
  }

  void _onResend() {
    setState(() {
      _timeLeft = 60;
      _showResend = false;
      for (var c in _controllers) {
        c.clear();
      }
      _isComplete = false;
    });
    _startTimer();
    _focusNodes[0].requestFocus();
  }

  void _checkCompleteness() {
    final complete = _controllers.every((c) => c.text.length == 1);
    setState(() => _isComplete = complete);
  }

  void _onVerify() async {
    if (!_isComplete) return;

    setState(() => _isLoading = true);

    final phoneNumber = ref.read(phoneNumberProvider);

    if (phoneNumber == null) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please resend OTP.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    try {
      final code = _controllers.map((c) => c.text).join();

      // Real API call
      final success = await ref.read(authServiceProvider).verifyOtp(phoneNumber, code);

      if (!success) {
        throw Exception('Invalid OTP or Verification Failed');
      }

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _showSuccess = true;
      });
      _overlayController.forward();
      _scaleController.forward();

      await Future.delayed(const Duration(milliseconds: 2000));

      if (!mounted) return;

      // Navigate to profile setup (mocking a new user)
      context.go('/auth/profile/1');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll('Exception: ', '')),
          backgroundColor: const Color(0xFFBA1A1A),
        ),
      );
    }
  }

  String get _timerText {
    final m = _timeLeft ~/ 60;
    final s = _timeLeft % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    _overlayController.dispose();
    _scaleController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  children: [
                    // Header
                    _buildHeader(context),

                    // Scrollable content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            const Text(
                              'Verify your identity',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.56,
                                color: Color(0xFF1C1B1B),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "We've sent a 6-digit code to your mobile device. Enter it below to secure your travel account.",
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 16,
                                color: Color(0xFF414755),
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Illustration
                            _buildIllustration(),
                            const SizedBox(height: 32),

                            // OTP label
                            const Text(
                              'ENTER 6-DIGIT CODE',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: Color(0xFF414755),
                              ),
                            ),
                            const SizedBox(height: 12),

                            // OTP boxes
                            _buildOtpRow(),
                            const SizedBox(height: 24),

                            // Timer / Resend
                            Center(
                              child: _showResend
                                  ? GestureDetector(
                                      onTap: _onResend,
                                      child: const Text(
                                        "Didn't receive a code? Resend",
                                        style: TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF8C5000),
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    )
                                  : RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 14,
                                          color: Color(0xFF414755),
                                        ),
                                        children: [
                                          const TextSpan(
                                              text: 'Resend code in '),
                                          TextSpan(
                                            text: _timerText,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              color: Color(0xFF0058BC),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 32),

                            // Verify button
                            _VerifyButton(
                              isLoading: _isLoading,
                              isEnabled: _isComplete,
                              onTap: _onVerify,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Success overlay
          if (_showSuccess)
            FadeTransition(
              opacity: _overlayOpacity,
              child: Container(
                color: const Color(0xFFFCF9F8).withOpacity(0.92),
                child: Center(
                  child: ScaleTransition(
                    scale: _cardScale,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCF9F8),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 40,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedBuilder(
                            animation: _bounceController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  -6 * _bounceController.value,
                                ),
                                child: child,
                              );
                            },
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xFFFE9400),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Color(0xFF633700),
                                size: 40,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Verified!',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.56,
                              color: Color(0xFF1C1B1B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Your journey starts now.',
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
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.go('/auth/phone'),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back, color: Color(0xFF0058BC), size: 24),
            ),
          ),
          const Text(
            'Wegoo',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.56,
              color: Color(0xFF0058BC),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/onboarding.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: const Color(0xFFF0EDEC),
                  child: const Center(
                    child: Icon(Icons.lock_outline,
                        size: 48, color: Color(0xFF0058BC)),
                  ),
                ),
              ),
              // Gradient overlay bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 80,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Color(0x66000000),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
          6,
          (i) => _OtpBox(
                controller: _controllers[i],
                focusNode: _focusNodes[i],
                onChanged: (val) {
                  if (val.length == 1 && i < 5) {
                    _focusNodes[i + 1].requestFocus();
                  }
                  _checkCompleteness();
                },
                onBackspace: () {
                  if (_controllers[i].text.isEmpty && i > 0) {
                    _focusNodes[i - 1].requestFocus();
                    _controllers[i - 1].clear();
                    _checkCompleteness();
                  }
                },
              )),
    );
  }
}

// â”€â”€ OTP Box â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() => _focused = widget.focusNode.hasFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _focused ? const Color(0xFF0058BC) : const Color(0xFFC1C6D7),
          width: _focused ? 2 : 1.5,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: const Color(0xFF0058BC).withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace) {
            widget.onBackspace();
          }
        },
        child: TextField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1B1B),
          ),
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}

// â”€â”€ Verify Button â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _VerifyButton extends StatefulWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onTap;

  const _VerifyButton({
    required this.isLoading,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  State<_VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<_VerifyButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.isEnabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedOpacity(
          opacity: widget.isEnabled ? 1.0 : 0.5,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC),
              borderRadius: BorderRadius.circular(12),
              boxShadow: widget.isEnabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0058BC).withOpacity(0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Verify & Continue',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.chevron_right,
                            color: Colors.white, size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€ No-op ImageFilter for BackdropFilter â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
