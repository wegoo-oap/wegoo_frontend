import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  Wegoo Design Tokens (from HTML tailwind config)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  Screen
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

  // Mirrors the HTML nationality list â€” expand as needed
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
    // Animate progress bar from 0 â†’ 50 % (Step 1 of 2)
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
      // Mock API call
      await Future.delayed(const Duration(seconds: 1));

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
            // â”€â”€ Sticky Header â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
            _StickyHeader(progressAnim: _progressAnim),

            // â”€â”€ Scrollable Body â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

                          // â”€â”€ Title â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                          _TitleSection(),

                          const SizedBox(height: 40),

                          // â”€â”€ Photo Picker â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                          _PhotoPicker(
                            photoFile: _photoFile,
                            onTap: _pickPhoto,
                          ),

                          const SizedBox(height: 48),

                          // â”€â”€ Name â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
                          _FieldLabel('FULL NAME'),
                          const SizedBox(height: 12),
                          _WegooTextField(
                            controller: _nameController,
                            hint: 'Enter your name',
                            keyboardType: TextInputType.name,
                            suffixIcon: Icons.badge_outlined,
                          ),

                          const SizedBox(height: 32),

                          // â”€â”€ Age + Nationality â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
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

                          // --- Safety Card removed ---

                          const SizedBox(height: 32),

                          // ——— Next Button ———————————————————————————
                          _NextButton(
                            isLoading: _isLoading,
                            onTap: _isLoading ? () {} : _onNext,
                          ),

                          const SizedBox(height: 48),

                          // ——— Footer decoration ———————————————————————————
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

// —————————————————————————————————————————————————————————————
//  Sticky Header with animated progress bar
// —————————————————————————————————————————————————————————————
class _StickyHeader extends StatelessWidget {
  const _StickyHeader({required this.progressAnim});
  final Animation<double> progressAnim;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        color: WegooColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, top + 8, 20, 16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/auth/otp'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: WegooColors.surfaceContainerLow,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: WegooColors.primary,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Step 1 of 2',
                    style: WegooTextStyles.labelCaps.copyWith(
                      color: WegooColors.primary,
                    ),
                  ),
                  const Spacer(),
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
                  height: 6,
                  child: AnimatedBuilder(
                    animation: progressAnim,
                    builder: (_, __) => LinearProgressIndicator(
                      value: progressAnim.value,
                      backgroundColor: WegooColors.surfaceContainerHighest,
                      valueColor:
                          const AlwaysStoppedAnimation(WegooColors.primary),
                      minHeight: 6,
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

// —————————————————————————————————————————————————————————————
//  Title Section
// —————————————————————————————————————————————————————————————
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

// —————————————————————————————————————————————————————————————
//  Photo Picker
// —————————————————————————————————————————————————————————————
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
                // Glowing outer border
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        WegooColors.primaryContainer,
                        WegooColors.secondaryContainer,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: WegooColors.primary.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: WegooColors.surfaceContainerLowest,
                      border: Border.all(color: Colors.white, width: 4),
                      image: photoFile != null
                          ? DecorationImage(
                              image: FileImage(photoFile!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: photoFile == null
                        ? Center(
                            child: Icon(
                              Icons.person_rounded,
                              size: 72,
                              color: WegooColors.outline.withOpacity(0.6),
                            ),
                          )
                        : null,
                  ),
                ),

                // Camera FAB Badge
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          WegooColors.primaryContainer,
                          WegooColors.primary,
                        ],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: WegooColors.primary.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
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
            'UPLOAD PROFILE PHOTO',
            style: WegooTextStyles.labelCaps.copyWith(
              color: WegooColors.primary,
              letterSpacing: 1.5,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// —————————————————————————————————————————————————————————————
//  Field Label
// —————————————————————————————————————————————————————————————
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

// —————————————————————————————————————————————————————————————
//  Wegoo Text Field
// —————————————————————————————————————————————————————————————
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: WegooColors.primary.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Focus(
        onFocusChange: (f) => setState(() => _focused = f),
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          style: WegooTextStyles.bodyMedium.copyWith(
            color: WegooColors.onSurface,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: WegooTextStyles.bodyMedium.copyWith(
              color: WegooColors.outline.withOpacity(0.7),
            ),
            filled: true,
            fillColor: _focused
                ? WegooColors.surfaceContainerLowest
                : WegooColors.surfaceContainerLow,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            suffixIcon: widget.suffixIcon != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      widget.suffixIcon,
                      color: _focused ? WegooColors.primary : WegooColors.outline,
                      size: 22,
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              minWidth: 24,
              minHeight: 24,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: WegooColors.outlineVariant.withOpacity(0.5),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: WegooColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// —————————————————————————————————————————————————————————————
//  Nationality Dropdown
// —————————————————————————————————————————————————————————————
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
    final hasValue = value != null;
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: hasValue
            ? WegooColors.surfaceContainerLowest
            : WegooColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasValue
              ? WegooColors.primary
              : WegooColors.outlineVariant.withOpacity(0.5),
          width: hasValue ? 2 : 1,
        ),
        boxShadow: hasValue
            ? [
                BoxShadow(
                  color: WegooColors.primary.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: hasValue ? WegooColors.primary : WegooColors.outline,
            size: 24,
          ),
          style: WegooTextStyles.bodyMedium.copyWith(
            color: WegooColors.onSurface,
            fontWeight: hasValue ? FontWeight.w500 : FontWeight.w400,
          ),
          hint: Text(
            'Select',
            style: WegooTextStyles.bodyMedium.copyWith(
              color: WegooColors.outline.withOpacity(0.7),
            ),
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

class _NextButton extends StatefulWidget {
  const _NextButton({required this.onTap, required this.isLoading});
  final VoidCallback onTap;
  final bool isLoading;

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
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                WegooColors.primaryContainer,
                WegooColors.primary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: WegooColors.primary.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
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
                        'Next Step',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded, color: Colors.white, size: 22),
                    ],
                  ),
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
        // Travel photo decoration
        Expanded(
          child: Container(
            height: 112,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  WegooColors.surfaceContainer,
                  WegooColors.surfaceContainerLow,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: WegooColors.outlineVariant.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.landscape_rounded,
                size: 44,
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
              color: WegooColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: WegooColors.outlineVariant.withOpacity(0.4),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.people_alt_rounded,
                  color: WegooColors.primary,
                  size: 24,
                ),
                const SizedBox(height: 8),
                Text(
                  'JOIN 50K+\nTRAVELERS',
                  textAlign: TextAlign.center,
                  style: WegooTextStyles.labelCaps.copyWith(
                    color: WegooColors.onSurfaceVariant,
                    fontSize: 10,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
