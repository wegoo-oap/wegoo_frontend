import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ─────────────────────────────────────────────────────────────
//  Wegoo Design Tokens (from HTML tailwind config)
// ─────────────────────────────────────────────────────────────
class WegooColors {
  static const primary = Color(0xFF0058BC);
  static const primaryContainer = Color(0xFF0070EB);
  static const onPrimary = Colors.white;

  static const secondary = Color(0xFF8C5000);
  static const secondaryContainer = Color(0xFFFE9400);
  static const secondaryFixed = Color(0xFFFFDCBF);
  static const secondaryFixedDim = Color(0xFFFFB874);
  static const onSecondaryFixed = Color(0xFF2D1600);

  static const surface = Color(0xFFFCF9F8);
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF6F3F2);
  static const surfaceContainer = Color(0xFFF0EDEC);
  static const surfaceContainerHigh = Color(0xFFEBE7E7);
  static const surfaceContainerHighest = Color(0xFFE5E2E1);

  static const onSurface = Color(0xFF1C1B1B);
  static const onSurfaceVariant = Color(0xFF414755);
  static const outline = Color(0xFF717786);
  static const outlineVariant = Color(0xFFC1C6D7);

  static const tertiary = Color(0xFF5C5C5C);
}

class WegooTextStyles {
  static const _jakarta = 'PlusJakartaSans'; // add to pubspec

  static const labelCaps = TextStyle(
    fontFamily: _jakarta,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.05 * 12,
    fontWeight: FontWeight.w700,
  );

  static const buttonText = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.01 * 16,
    fontWeight: FontWeight.w600,
  );

  static const bodySmall = TextStyle(
    fontFamily: _jakarta,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );

  static const bodyMedium = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
  );

  static const headline1Mobile = TextStyle(
    fontFamily: _jakarta,
    fontSize: 28,
    height: 36 / 28,
    letterSpacing: -0.02 * 28,
    fontWeight: FontWeight.w700,
  );
}

// ─────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────
class ProfileSetupStep1Screen extends StatefulWidget {
  const ProfileSetupStep1Screen({super.key});

  @override
  State<ProfileSetupStep1Screen> createState() =>
      _ProfileSetupStep1ScreenState();
}

class _ProfileSetupStep1ScreenState extends State<ProfileSetupStep1Screen>
    with SingleTickerProviderStateMixin {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _selectedNationality;
  File? _photoFile;
  late AnimationController _progressAnimCtrl;
  late Animation<double> _progressAnim;
  bool _isLoading = false;

  // Mirrors the HTML nationality list — expand as needed
  static const _nationalities = [
    ('fr', 'France'),
    ('it', 'Italy'),
    ('es', 'Spain'),
    ('gr', 'Greece'),
    ('us', 'USA'),
    ('tn', 'Tunisia'),
    ('dz', 'Algeria'),
    ('ma', 'Morocco'),
  ];

  @override
  void initState() {
    super.initState();
    // Animate progress bar from 0 → 50 % (Step 1 of 2)
    _progressAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _progressAnim = Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: _progressAnimCtrl, curve: Curves.easeOut),
    );
    _progressAnimCtrl.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _progressAnimCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 512,
    );
    if (picked != null) {
      setState(() => _photoFile = File(picked.path));
    }
  }

  Future<void> _onNext() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // Photo upload removed for now — Storage requires Blaze plan
      // Will add back when upgraded
      const String photoUrl = '';

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'userId': uid,
        'displayName': _nameController.text.trim(),
        'age': int.tryParse(_ageController.text) ?? 0,
        'nationality': _selectedNationality ?? '',
        'photoUrl': photoUrl,
        'isVerified': true,
        'rating': 0.0,
        'ratingCount': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (mounted) context.push('/auth/profile/2');
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: WegooColors.surface,
        body: Column(
          children: [
            // ── Sticky Header ──────────────────────────────
            _StickyHeader(progressAnim: _progressAnim),

            // ── Scrollable Body ────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 32),

                          // ── Title ──────────────────────
                          _TitleSection(),

                          const SizedBox(height: 40),

                          // ── Photo Picker ───────────────
                          _PhotoPicker(
                            photoFile: _photoFile,
                            onTap: _pickPhoto,
                          ),

                          const SizedBox(height: 48),

                          // ── Name ───────────────────────
                          _FieldLabel('FULL NAME'),
                          const SizedBox(height: 12),
                          _WegooTextField(
                            controller: _nameController,
                            hint: 'Enter your name',
                            keyboardType: TextInputType.name,
                            suffixIcon: Icons.badge_outlined,
                          ),

                          const SizedBox(height: 32),

                          // ── Age + Nationality ──────────
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel('AGE'),
                                    const SizedBox(height: 12),
                                    _WegooTextField(
                                      controller: _ageController,
                                      hint: 'e.g. 24',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(3),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _FieldLabel('NATIONALITY'),
                                    const SizedBox(height: 12),
                                    _NationalityDropdown(
                                      value: _selectedNationality,
                                      nationalities: _nationalities,
                                      onChanged: (v) => setState(
                                          () => _selectedNationality = v),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // ── Safety Card ────────────────
                          _SafetyCard(),

                          const SizedBox(height: 32),

                          // ── Next Button ────────────────
                          _NextButton(
                            isLoading: _isLoading,
                            onTap: _isLoading ? () {} : _onNext,
                          ),

                          const SizedBox(height: 48),

                          // ── Footer decoration ──────────
                          _FooterDecoration(),

                          const SizedBox(height: 48),
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
//  Sticky Header with animated progress bar
// ─────────────────────────────────────────────────────────────
class _StickyHeader extends StatelessWidget {
  const _StickyHeader({required this.progressAnim});
  final Animation<double> progressAnim;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: WegooColors.surface.withOpacity(0.85),
      padding: EdgeInsets.fromLTRB(20, top + 12, 20, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step 1 of 2',
                    style: WegooTextStyles.labelCaps.copyWith(
                      color: WegooColors.primary,
                    ),
                  ),
                  Text(
                    '50% Complete',
                    style: WegooTextStyles.labelCaps.copyWith(
                      color: WegooColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: SizedBox(
                  height: 8,
                  child: AnimatedBuilder(
                    animation: progressAnim,
                    builder: (_, __) => LinearProgressIndicator(
                      value: progressAnim.value,
                      backgroundColor: WegooColors.surfaceContainerHighest,
                      valueColor:
                          const AlwaysStoppedAnimation(WegooColors.primary),
                      minHeight: 8,
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
}

// ─────────────────────────────────────────────────────────────
//  Title Section
// ─────────────────────────────────────────────────────────────
class _TitleSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create your profile',
          style: WegooTextStyles.headline1Mobile.copyWith(
            color: WegooColors.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Let the Wegoo community get to know you before your next adventure.',
          style: WegooTextStyles.bodyMedium.copyWith(
            color: WegooColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Photo Picker
// ─────────────────────────────────────────────────────────────
class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({required this.photoFile, required this.onTap});
  final File? photoFile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Avatar circle
                Container(
                  width: 144,
                  height: 144,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: WegooColors.surfaceContainerHigh,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.10),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    image: photoFile != null
                        ? DecorationImage(
                            image: FileImage(photoFile!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: photoFile == null
                      ? const Icon(
                          Icons.person,
                          size: 64,
                          color: WegooColors.outline,
                        )
                      : null,
                ),

                // Camera FAB
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: WegooColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: WegooColors.primary.withOpacity(0.35),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'UPLOAD PHOTO',
            style: WegooTextStyles.labelCaps.copyWith(
              color: WegooColors.tertiary,
              letterSpacing: 0.05 * 12 * 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Field Label
// ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: WegooTextStyles.labelCaps.copyWith(
        color: WegooColors.onSurfaceVariant,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Wegoo Text Field
// ─────────────────────────────────────────────────────────────
class _WegooTextField extends StatefulWidget {
  const _WegooTextField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.suffixIcon,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final IconData? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;

  @override
  State<_WegooTextField> createState() => _WegooTextFieldState();
}

class _WegooTextFieldState extends State<_WegooTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _focused ? 1.01 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: Focus(
        onFocusChange: (f) => setState(() => _focused = f),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style:
              WegooTextStyles.bodyMedium.copyWith(color: WegooColors.onSurface),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle:
                WegooTextStyles.bodyMedium.copyWith(color: WegooColors.outline),
            filled: true,
            fillColor: WegooColors.surfaceContainerLowest,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            suffixIcon: widget.suffixIcon != null
                ? Icon(widget.suffixIcon,
                    color: WegooColors.outlineVariant, size: 22)
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: WegooColors.outlineVariant, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: WegooColors.outlineVariant, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide:
                  const BorderSide(color: WegooColors.primary, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Nationality Dropdown
// ─────────────────────────────────────────────────────────────
class _NationalityDropdown extends StatelessWidget {
  const _NationalityDropdown({
    required this.value,
    required this.nationalities,
    required this.onChanged,
  });

  final String? value;
  final List<(String, String)> nationalities;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: WegooColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              value != null ? WegooColors.primary : WegooColors.outlineVariant,
          width: value != null ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon:
              const Icon(Icons.keyboard_arrow_down, color: WegooColors.outline),
          style: WegooTextStyles.bodyMedium.copyWith(
            color: value != null ? WegooColors.primary : WegooColors.outline,
            fontWeight: value != null ? FontWeight.w600 : FontWeight.w400,
          ),
          hint: Text(
            'Select',
            style:
                WegooTextStyles.bodyMedium.copyWith(color: WegooColors.outline),
          ),
          dropdownColor: WegooColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          items: nationalities
              .map((n) => DropdownMenuItem(
                    value: n.$1,
                    child: Text(n.$2),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Safety Card
// ─────────────────────────────────────────────────────────────
class _SafetyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: WegooColors.secondaryFixed,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon box
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.verified_user_outlined,
                  color: WegooColors.onSecondaryFixed,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Safety First',
                      style: WegooTextStyles.buttonText.copyWith(
                        color: WegooColors.onSecondaryFixed,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Real profiles build trust within our travel community. Your data is encrypted and secure.',
                      style: WegooTextStyles.bodySmall.copyWith(
                        color: WegooColors.onSecondaryFixed.withOpacity(0.8),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Decorative circle (bottom-right, clipped)
          Positioned(
            bottom: -32,
            right: -32,
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: WegooColors.secondaryFixedDim.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Next Button
// ─────────────────────────────────────────────────────────────
class _NextButton extends StatefulWidget {
  const _NextButton({required this.onTap, required this.isLoading});
  final VoidCallback onTap;
  final bool isLoading; // ← add this

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
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
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: WegooColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: WegooColors.primary.withOpacity(0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
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
                    Text('Next',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.16,
                        )),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Footer Decoration
// ─────────────────────────────────────────────────────────────
class _FooterDecoration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Travel photo placeholder
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 112,
              color: WegooColors.surfaceContainerHigh,
              child: const Icon(
                Icons.landscape_outlined,
                size: 40,
                color: WegooColors.outlineVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Community badge
        Expanded(
          child: Container(
            height: 112,
            decoration: BoxDecoration(
              color: WegooColors.surfaceContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: WegooColors.outlineVariant.withOpacity(0.3),
              ),
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Text(
              'JOIN 50K+\nTRAVELERS',
              textAlign: TextAlign.center,
              style: WegooTextStyles.labelCaps.copyWith(
                color: WegooColors.outline,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
