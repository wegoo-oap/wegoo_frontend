import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class PostTripRatingScreen extends StatefulWidget {
  final String travelerName;
  final String travelerPhotoUrl;
  final String tripEndedLabel;

  const PostTripRatingScreen({
    super.key,
    this.travelerName = 'Elena Rossi',
    this.travelerPhotoUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAJRlZx6NPTPPJYtq8yNVnXunLgErBRuXnPguhZRuLBP1N6UHq30soHjYHkXXoXbsWrNsw8RTUwUGiyw9fGIWsmiNwRiqQgwxfjLpPH-Lyy2Dh7AV04M6R1KYXI6V2x-VV-iEsRklNiZYPbgrhCuN59I_cAGfmXB0Gb8cYBxbzQSyUb3WsmCBcYRXY-3oj_Vnvr10RyFk47mW5YieTedyo12x0_v_9mxl2FFlzKKugrbNXSphqMJjtaVyvnBgw_8iWF5eCuXegkyKg2',
    this.tripEndedLabel = 'Trip ended 24 hours ago.',
  });

  @override
  State<PostTripRatingScreen> createState() => _PostTripRatingScreenState();
}

class _PostTripRatingScreenState extends State<PostTripRatingScreen> {
  int _rating = 0;
  int? _hoverRating;
  bool _ratingPulse = false;
  bool _isSubmitting = false;

  final TextEditingController _feedbackController = TextEditingController();
  final FocusNode _feedbackFocus = FocusNode();

  static const _primary = Color(0xFF0058BC);
  static const _surface = Color(0xFFFCF9F8);
  static const _onSurface = Color(0xFF1C1B1B);
  static const _onSurfaceVariant = Color(0xFF414755);
  static const _outline = Color(0xFF717786);
  static const _outlineVariant = Color(0xFFC1C6D7);
  static const _primaryFixed = Color(0xFFD8E2FF);
  static const _secondaryContainer = Color(0xFFFE9400);
  static const _onSecondaryContainer = Color(0xFF633700);
  static const _primaryContainer = Color(0xFF0070EB);
  static const _onPrimaryContainer = Color(0xFFFEFCFF);
  static const _surfaceContainerHigh = Color(0xFFEBE7E7);
  static const _surfaceContainerLowest = Color(0xFFFFFFFF);
  static const _secondaryFixed = Color(0xFFFFDCBF);

  @override
  void dispose() {
    _feedbackController.dispose();
    _feedbackFocus.dispose();
    super.dispose();
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
      _ratingPulse = true;
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => _ratingPulse = false);
    });
  }

  Future<void> _onSubmit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a star rating.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _surface,
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 672),
                    child: Column(
                      children: [
                        _buildRatingCard(context),
                        const SizedBox(height: 32),
                        _buildBentoGrid(),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    const headerAvatarUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCwdd10G90dGqN0KIEm1hYLZf1_iGIkjpbIGUPTqo1GKil4WSZO5kC-v4PkJngMXHis0t634XjhN4WdPxaMq-PS6M3wcxDbs3tiavzZhBG469Z6vTNTbaWkMIVjGmPdMRq77NsrObw1RSw2Q2MFtZKB4RV6JKqqmXu49QBDQwvT3PtZ1LsZu7qUarzgaYuD5TY9jZJxcWaUbwviFdT4U97IbnfOXVAxF8080J0_dc0cem7AjewD1UHm_brLTIo6v-69ToNfVDqgLzvp';

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: _surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: headerAvatarUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: _surfaceContainerHigh,
                    child: const Icon(Icons.person, color: _primary, size: 22),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: _surfaceContainerHigh,
                    child: const Icon(Icons.person, color: _primary, size: 22),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Wegoo',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _primary,
              ),
            ),
            const Spacer(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go('/settings'),
                borderRadius: BorderRadius.circular(99),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.settings_outlined, color: _primary, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surfaceContainerHigh),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildTravelerHeader(),
          const SizedBox(height: 24),
          _buildStarRating(),
          const SizedBox(height: 32),
          _buildFeedbackArea(),
          const SizedBox(height: 32),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildTravelerHeader() {
    return Column(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: _primaryFixed, width: 4),
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: widget.travelerPhotoUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                color: _primaryFixed,
                child: const Icon(Icons.person, size: 48, color: _primary),
              ),
              errorWidget: (_, __, ___) => Container(
                color: _primaryFixed,
                child: const Icon(Icons.person, size: 48, color: _primary),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'How was your trip with ${widget.travelerName}?',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 28,
            height: 36 / 28,
            letterSpacing: -0.56,
            fontWeight: FontWeight.w700,
            color: _onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your feedback helps keep our community safe and reliable. ${widget.tripEndedLabel}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            height: 24 / 16,
            color: _onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStarRating() {
    final displayRating = _hoverRating ?? _rating;

    return AnimatedScale(
      scale: _ratingPulse ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final starIndex = index + 1;
          final isFilled = starIndex <= displayRating;
          final isHoverPreview =
              _hoverRating != null && starIndex <= _hoverRating! && _rating == 0;

          Color starColor;
          if (isFilled && !isHoverPreview) {
            starColor = _secondaryContainer;
          } else if (isHoverPreview || (isFilled && _hoverRating != null)) {
            starColor = _secondaryFixed;
          } else {
            starColor = _outline;
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _setRating(starIndex),
                onHover: (hovering) {
                  setState(() {
                    _hoverRating = hovering ? starIndex : null;
                  });
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: AnimatedScale(
                    scale: 1.0,
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      size: 36,
                      color: starColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildFeedbackArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ADDITIONAL FEEDBACK (OPTIONAL)',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            height: 16 / 12,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w700,
            color: _onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _feedbackController,
          focusNode: _feedbackFocus,
          maxLines: 6,
          minLines: 6,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            height: 24 / 16,
            color: _onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'Tell us about the highlights of your journey...',
            hintStyle: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: _outline,
            ),
            filled: true,
            fillColor: _surface,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        _SubmitButton(
          isLoading: _isSubmitting,
          onTap: _onSubmit,
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => context.go('/home'),
          style: TextButton.styleFrom(
            foregroundColor: _primary,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          ),
          child: const Text(
            'Maybe Later',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBentoGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 600;

        final safeCommunity = _BentoCard(
          icon: Icons.verified,
          iconBg: _secondaryContainer,
          iconColor: _onSecondaryContainer,
          title: 'Safe Community',
          subtitle:
              'Your ratings are anonymous until the other person also rates you.',
        );

        final earnBadges = _BentoCard(
          icon: Icons.military_tech_outlined,
          iconBg: _primaryContainer,
          iconColor: _onPrimaryContainer,
          title: 'Earn Badges',
          subtitle:
              "Submitting reviews earns you 'Reliable Traveler' status points.",
        );

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: safeCommunity),
              const SizedBox(width: 16),
              Expanded(child: earnBadges),
            ],
          );
        }

        return Column(
          children: [
            safeCommunity,
            const SizedBox(height: 16),
            earnBadges,
          ],
        );
      },
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
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
                : const Text(
                    'Submit Rating',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.16,
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _BentoCard({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1C1B1B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    height: 20 / 14,
                    color: Color(0xFF414755),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
