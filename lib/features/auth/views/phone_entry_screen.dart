import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wegoo/features/auth/controllers/auth_providers.dart';

/// Converts an ISO 3166-1 alpha-2 country code to a flag emoji.
/// e.g. 'TN' -> 🇹🇳, 'FR' -> 🇫🇷
String countryCodeToFlag(String countryCode) {
  return countryCode.toUpperCase().runes.map((code) {
    return String.fromCharCode(0x1F1E6 - 0x41 + code);
  }).join();
}

class PhoneEntryScreen extends ConsumerStatefulWidget {
  const PhoneEntryScreen({super.key});

  @override
  ConsumerState<PhoneEntryScreen> createState() => _PhoneEntryScreenState();
}

class _PhoneEntryScreenState extends ConsumerState<PhoneEntryScreen>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  bool _isLoading = false;
  bool _inputScaled = false;

  // Selected country
  String _countryFlag = countryCodeToFlag('TN');
  String _countryCode = '+216';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    _phoneFocus.addListener(() {
      setState(() => _inputScaled = _phoneFocus.hasFocus);
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocus.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onSendOtp() async {
    final phoneNumber = '$_countryCode${_phoneController.text.trim()}';

    if (_phoneController.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      // Real API call
      await ref.read(authServiceProvider).sendOtp(phoneNumber);

      if (!mounted) return;
      setState(() => _isLoading = false);

      // SAVE mock verificationId for OTP screen (since we don't use it yet)
      ref.read(verificationIdProvider.notifier).state = 'mock_vid_123';

      // save phone number
      ref.read(phoneNumberProvider.notifier).state = phoneNumber;

      // go to OTP screen
      context.go('/auth/otp');
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  void _onGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final success = await ref.read(authServiceProvider).signInWithGoogle();
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (success) {
        context.go('/auth/profile/1');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google Sign-In failed or was canceled')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFFCF9F8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _CountryPickerSheet(
        onSelect: (flag, code) {
          setState(() {
            _countryFlag = flag;
            _countryCode = code;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            right: -100,
            child: _Blob(),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: _Blob(),
          ),

          // Floating explore icon
          Positioned(
            bottom: 40,
            right: 40,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.explore,
                size: 120,
                color: const Color(0xFF8C5000),
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    children: [
                      // Header
                      _Header(),

                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 32, 20, 48),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Illustration
                              _Illustration(),
                              const SizedBox(height: 40),

                              // Copy
                              const Center(
                                child: Column(
                                  children: [
                                    Text(
                                      'Welcome Home',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.56,
                                        color: Color(0xFF1C1B1B),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Enter your phone number to start your\nnext adventure with Wegoo.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF414755),
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 40),

                              // Phone number label
                              const Padding(
                                padding: EdgeInsets.only(left: 4, bottom: 8),
                                child: Text(
                                  'PHONE NUMBER',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.6,
                                    color: Color(0xFF414755),
                                  ),
                                ),
                              ),

                              // Input row
                              AnimatedScale(
                                scale: _inputScaled ? 1.01 : 1.0,
                                duration: const Duration(milliseconds: 150),
                                child: Row(
                                  children: [
                                    // Country picker
                                    GestureDetector(
                                      onTap: _showCountryPicker,
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 150),
                                        height: 56,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFCF9F8),
                                          border: Border.all(
                                            color: const Color(0xFFC1C6D7),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(_countryFlag,
                                                style: const TextStyle(
                                                    fontSize: 24)),
                                            const SizedBox(width: 8),
                                            Text(
                                              _countryCode,
                                              style: const TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFF1C1B1B),
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(Icons.expand_more,
                                                size: 18,
                                                color: Color(0xFF414755)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Phone input
                                    Expanded(
                                      child: TextField(
                                        controller: _phoneController,
                                        focusNode: _phoneFocus,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          FilteringTextInputFormatter
                                              .digitsOnly,
                                        ],
                                        style: const TextStyle(
                                          fontFamily: 'PlusJakartaSans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF1C1B1B),
                                        ),
                                        decoration: InputDecoration(
                                          hintText: '600 000 000',
                                          hintStyle: const TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            color: Color(0xFFC1C6D7),
                                            fontSize: 16,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16),
                                          filled: true,
                                          fillColor: const Color(0xFFFCF9F8),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFC1C6D7)),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                                color: Color(0xFFC1C6D7)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: const BorderSide(
                                              color: Color(0xFF0058BC),
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Send OTP button
                              _SendOtpButton(
                                isLoading: _isLoading,
                                onTap: _onSendOtp,
                              ),
                              const SizedBox(height: 24),
                              const _DividerOr(),
                              const SizedBox(height: 24),
                              _GoogleAuthButton(
                                onTap: _onGoogleSignIn,
                              ),

                              // Footer
                              const SizedBox(height: 48),
                              Center(
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14,
                                      color: Color(0xFF414755),
                                    ),
                                    children: [
                                      const TextSpan(
                                          text:
                                              'By continuing, you agree to our '),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            'Terms of Service',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF0058BC),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      WidgetSpan(
                                        child: GestureDetector(
                                          onTap: () {},
                                          child: const Text(
                                            'Privacy Policy',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF0058BC),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const TextSpan(text: '.'),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 32),

                              // Pagination dots
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _Dot(active: true),
                                  const SizedBox(width: 16),
                                  _Dot(active: false),
                                  const SizedBox(width: 16),
                                  _Dot(active: false),
                                ],
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
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Sub-widgets â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F8).withOpacity(0.8),
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
            onTap: () => context.go('/splash'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: Colors.transparent,
              ),
              child: const Icon(Icons.arrow_back,
                  color: Color(0xFF1C1B1B), size: 24),
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
}

class _Illustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/images/onboarding.png',
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => Container(
              color: const Color(0xFFF0EDEC),
              child: const Center(
                child: Icon(Icons.travel_explore,
                    size: 64, color: Color(0xFF0058BC)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SendOtpButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;
  const _SendOtpButton({required this.isLoading, required this.onTap});

  @override
  State<_SendOtpButton> createState() => _SendOtpButtonState();
}

class _SendOtpButtonState extends State<_SendOtpButton> {
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
        child: AnimatedOpacity(
          opacity: _pressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0058BC).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
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
                          'Send OTP',
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

class _Dot extends StatelessWidget {
  final bool active;
  const _Dot({required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFF0058BC) : const Color(0xFFC1C6D7),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFF0058BC).withOpacity(0.05),
            const Color(0xFFFE9400).withOpacity(0.02),
          ],
        ),
      ),
    );
  }
}

// â”€â”€ Country Picker Sheet â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _CountryPickerSheet extends StatelessWidget {
  final void Function(String flag, String code) onSelect;

  const _CountryPickerSheet({required this.onSelect});

  static final List<Map<String, String>> _countries = [
    {'flag': countryCodeToFlag('TN'), 'name': 'Tunisia', 'code': '+216'},
    {'flag': countryCodeToFlag('FR'), 'name': 'France', 'code': '+33'},
    {'flag': countryCodeToFlag('DZ'), 'name': 'Algeria', 'code': '+213'},
    {'flag': countryCodeToFlag('MA'), 'name': 'Morocco', 'code': '+212'},
    {'flag': countryCodeToFlag('ES'), 'name': 'Spain', 'code': '+34'},
    {'flag': countryCodeToFlag('IT'), 'name': 'Italy', 'code': '+39'},
    {'flag': countryCodeToFlag('DE'), 'name': 'Germany', 'code': '+49'},
    {'flag': countryCodeToFlag('GB'), 'name': 'UK', 'code': '+44'},
    {'flag': countryCodeToFlag('US'), 'name': 'USA', 'code': '+1'},
    {'flag': countryCodeToFlag('SA'), 'name': 'Saudi Arabia', 'code': '+966'},
    {'flag': countryCodeToFlag('AE'), 'name': 'UAE', 'code': '+971'},
    {'flag': countryCodeToFlag('TR'), 'name': 'Turkey', 'code': '+90'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFC1C6D7),
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Select Country',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1B1B),
          ),
        ),
        const SizedBox(height: 8),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _countries.length,
            itemBuilder: (context, i) {
              final c = _countries[i];
              return ListTile(
                leading: Text(c['flag']!, style: const TextStyle(fontSize: 28)),
                title: Text(
                  c['name']!,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1C1B1B),
                  ),
                ),
                trailing: Text(
                  c['code']!,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    color: Color(0xFF414755),
                  ),
                ),
                onTap: () {
                  onSelect(c['flag']!, c['code']!);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _DividerOr extends StatelessWidget {
  const _DividerOr();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE2E4E9), thickness: 1)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE2E4E9), thickness: 1)),
      ],
    );
  }
}

class _GoogleAuthButton extends StatefulWidget {
  const _GoogleAuthButton({required this.onTap});
  final VoidCallback onTap;
  @override
  State<_GoogleAuthButton> createState() => _GoogleAuthButtonState();
}

class _GoogleAuthButtonState extends State<_GoogleAuthButton> {
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
        child: AnimatedOpacity(
          opacity: _pressed ? 0.85 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE2E4E9), width: 1.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Image.network(
                      'https://developers.google.com/identity/images/g-logo.png',
                      width: 18,
                      height: 18,
                      errorBuilder: (_, __, ___) => const Text(
                        'G',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDB4437),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
