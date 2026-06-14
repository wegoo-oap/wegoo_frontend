import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────
//  Design Tokens
// ─────────────────────────────────────────────────────────────
class WegooColors {
  static const primary = Color(0xFF0058BC);
  static const primaryContainer = Color(0xFF0070EB);
  static const onPrimary = Colors.white;
  static const onPrimaryContainer = Color(0xFFFEFCFF);
  static const secondaryContainer = Color(0xFFFE9400);
  static const onSecondaryContainer = Color(0xFF633700);
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
  static const _jakarta = 'PlusJakartaSans';

  static const labelCaps = TextStyle(
    fontFamily: _jakarta,
    fontSize: 12,
    height: 16 / 12,
    letterSpacing: 0.6,
    fontWeight: FontWeight.w700,
  );
  static const buttonText = TextStyle(
    fontFamily: _jakarta,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.16,
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
    letterSpacing: -0.56,
    fontWeight: FontWeight.w700,
  );
  static const headline2 = TextStyle(
    fontFamily: _jakarta,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w600,
  );
}

// ─────────────────────────────────────────────────────────────
//  Data models
// ─────────────────────────────────────────────────────────────
enum TravelStyle { relax, active, adventurous }

enum BudgetLevel { economy, balanced, luxury }

class _InterestItem {
  const _InterestItem(this.label, this.value);
  final String label;
  final String value;
}

class _LanguageItem {
  const _LanguageItem(this.label, this.code);
  final String label;
  final String code;
}

class _BudgetOption {
  const _BudgetOption({
    required this.level,
    required this.label,
    required this.subtitle,
    required this.icon,
  });
  final BudgetLevel level;
  final String label;
  final String subtitle;
  final IconData icon;
}

// ─────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────
class ProfileSetupStep2Screen extends StatefulWidget {
  const ProfileSetupStep2Screen({super.key});

  @override
  State<ProfileSetupStep2Screen> createState() =>
      _ProfileSetupStep2ScreenState();
}

class _ProfileSetupStep2ScreenState extends State<ProfileSetupStep2Screen>
    with SingleTickerProviderStateMixin {
  // ── State variables ────────────────────────────────────────
  TravelStyle _travelStyle = TravelStyle.relax;
  BudgetLevel _budget = BudgetLevel.balanced;
  final Set<String> _selectedInterests = {};
  final Set<String> _selectedLanguages = {};
  bool _isLoading = false; // ← FIX 1: was missing
  bool _showSuccess = false;

  // ── Progress animation ─────────────────────────────────────
  late AnimationController _progressCtrl;
  late Animation<double> _progressAnim;

  static const _interests = [
    _InterestItem('Hiking', 'hiking'),
    _InterestItem('Foodie', 'foodie'),
    _InterestItem('Culture', 'culture'),
    _InterestItem('Beaches', 'beaches'),
    _InterestItem('Nightlife', 'nightlife'),
    _InterestItem('Photography', 'photography'),
    _InterestItem('History', 'history'),
    _InterestItem('Wellness', 'wellness'),
    _InterestItem('Architecture', 'architecture'),
  ];

  static const _languages = [
    _LanguageItem('English', 'en'),
    _LanguageItem('Spanish', 'es'),
    _LanguageItem('French', 'fr'),
    _LanguageItem('German', 'de'),
    _LanguageItem('Chinese', 'zh'),
    _LanguageItem('Arabic', 'ar'),
  ];

  static const _budgetOptions = [
    _BudgetOption(
      level: BudgetLevel.economy,
      label: 'Economy',
      subtitle: 'Hostels and street food adventures.',
      icon: Icons.payments_outlined,
    ),
    _BudgetOption(
      level: BudgetLevel.balanced,
      label: 'Balanced',
      subtitle: 'Comfortable stays and local dining.',
      icon: Icons.savings_outlined,
    ),
    _BudgetOption(
      level: BudgetLevel.luxury,
      label: 'Luxury',
      subtitle: 'Premium resorts and fine dining.',
      icon: Icons.diamond_outlined,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _progressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _progressAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _progressCtrl, curve: Curves.easeOut),
    );
    _progressCtrl.forward();
  }

  @override
  void dispose() {
    _progressCtrl.dispose();
    super.dispose();
  }

  void _toggleInterest(String value) {
    setState(() {
      if (_selectedInterests.contains(value)) {
        _selectedInterests.remove(value);
      } else if (_selectedInterests.length < 6) {
        _selectedInterests.add(value);
      }
    });
  }

  void _toggleLanguage(String code) {
    setState(() {
      if (_selectedLanguages.contains(code)) {
        _selectedLanguages.remove(code);
      } else {
        _selectedLanguages.add(code);
      }
    });
  }

  // ── FIX 2: complete _onComplete with proper loading state ──
  Future<void> _onComplete() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'languages': _selectedLanguages.toList(),
        'interests': _selectedInterests.toList(),
        'travelStyle': _travelStyle.name.toUpperCase(),
        'budgetLevel': _budget.name.toUpperCase(),
        'lastActive': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _showSuccess = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) context.go('/home');
    } catch (e) {
      if (!mounted) return;
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
        body: Stack(
          children: [
            // ── Main content ──────────────────────────────
            Column(
              children: [
                _AppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _ProgressBar(anim: _progressAnim),
                        const SizedBox(height: 32),

                        Text(
                          'Tailor your profile',
                          style: WegooTextStyles.headline1Mobile
                              .copyWith(color: WegooColors.onSurface),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Help us find your perfect travel buddies and destinations.',
                          style: WegooTextStyles.bodyMedium
                              .copyWith(color: WegooColors.onSurfaceVariant),
                        ),
                        const SizedBox(height: 32),

                        // Travel Style
                        const _SectionLabel('TRAVEL STYLE'),
                        const SizedBox(height: 8),
                        _TravelStyleToggle(
                          selected: _travelStyle,
                          onChanged: (s) => setState(() => _travelStyle = s),
                        ),
                        const SizedBox(height: 32),

                        // Interests
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const _SectionLabel('INTERESTS'),
                            Text(
                              '${_selectedInterests.length} / 6 selected',
                              style: WegooTextStyles.labelCaps.copyWith(
                                color: _selectedInterests.length == 6
                                    ? WegooColors.secondaryContainer
                                    : WegooColors.tertiary,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        _InterestChips(
                          items: _interests,
                          selected: _selectedInterests,
                          onToggle: _toggleInterest,
                        ),
                        const SizedBox(height: 32),

                        // Languages
                        const _SectionLabel('LANGUAGES'),
                        const SizedBox(height: 8),
                        _LanguageChips(
                          items: _languages,
                          selected: _selectedLanguages,
                          onToggle: _toggleLanguage,
                        ),
                        const SizedBox(height: 32),

                        // Budget
                        const _SectionLabel('BUDGET LEVEL'),
                        const SizedBox(height: 8),
                        _BudgetSelector(
                          options: _budgetOptions,
                          selected: _budget,
                          onChanged: (b) => setState(() => _budget = b),
                        ),
                        const SizedBox(height: 32),

                        // ── FIX 3: pass isLoading to button ──
                        _CompleteButton(
                          isLoading: _isLoading,
                          onTap: _onComplete,
                        ),

                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            'You can change these later in settings.',
                            style: WegooTextStyles.labelCaps.copyWith(
                              color:
                                  WegooColors.onSurfaceVariant.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Success overlay ───────────────────────────
            if (_showSuccess) const _SuccessOverlay(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  App Bar
// ─────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: WegooColors.surface,
      padding: EdgeInsets.fromLTRB(8, top, 20, 0),
      height: top + 64,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: WegooColors.primary),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              Text(
                'Wegoo',
                style: WegooTextStyles.headline1Mobile.copyWith(
                  color: WegooColors.primary,
                  letterSpacing: -0.56,
                ),
              ),
            ],
          ),
          Text(
            'Step 2 of 2',
            style: WegooTextStyles.labelCaps
                .copyWith(color: WegooColors.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Progress Bar
// ─────────────────────────────────────────────────────────────
class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.anim});
  final Animation<double> anim;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: SizedBox(
        height: 6,
        child: AnimatedBuilder(
          animation: anim,
          builder: (_, __) => LinearProgressIndicator(
            value: anim.value,
            backgroundColor: WegooColors.surfaceContainerHigh,
            valueColor:
                const AlwaysStoppedAnimation(WegooColors.primaryContainer),
            minHeight: 6,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Section Label
// ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: WegooTextStyles.labelCaps
          .copyWith(color: WegooColors.onSurfaceVariant),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Travel Style Toggle
// ─────────────────────────────────────────────────────────────
class _TravelStyleToggle extends StatelessWidget {
  const _TravelStyleToggle({
    required this.selected,
    required this.onChanged,
  });
  final TravelStyle selected;
  final ValueChanged<TravelStyle> onChanged;

  static const _options = [
    (TravelStyle.relax, 'Relax'),
    (TravelStyle.active, 'Active'),
    (TravelStyle.adventurous, 'Adventurous'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: WegooColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: _options.map((opt) {
          final isActive = selected == opt.$1;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(opt.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: isActive
                      ? WegooColors.surfaceContainerLowest
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: Text(
                  opt.$2,
                  style: WegooTextStyles.buttonText.copyWith(
                    color: isActive
                        ? WegooColors.primary
                        : WegooColors.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Interest Chips
// ─────────────────────────────────────────────────────────────
class _InterestChips extends StatelessWidget {
  const _InterestChips({
    required this.items,
    required this.selected,
    required this.onToggle,
  });
  final List<_InterestItem> items;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isActive = selected.contains(item.value);
        final isDisabled = !isActive && selected.length >= 6;
        return GestureDetector(
          onTap: isDisabled ? null : () => onToggle(item.value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isActive
                  ? WegooColors.secondaryContainer
                  : isDisabled
                      ? WegooColors.surfaceContainerHighest
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: isActive
                    ? WegooColors.secondaryContainer
                    : WegooColors.outlineVariant,
              ),
            ),
            child: Text(
              item.label,
              style: WegooTextStyles.buttonText.copyWith(
                fontSize: 14,
                color: isActive
                    ? WegooColors.onSecondaryContainer
                    : isDisabled
                        ? WegooColors.outlineVariant
                        : WegooColors.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Language Chips
// ─────────────────────────────────────────────────────────────
class _LanguageChips extends StatelessWidget {
  const _LanguageChips({
    required this.items,
    required this.selected,
    required this.onToggle,
  });
  final List<_LanguageItem> items;
  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: items.map((item) {
        final isSelected = selected.contains(item.code);
        return GestureDetector(
          onTap: () => onToggle(item.code),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? WegooColors.primaryContainer
                  : WegooColors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: isSelected
                    ? WegooColors.primaryContainer
                    : WegooColors.outlineVariant,
              ),
            ),
            child: Text(
              item.label,
              style: WegooTextStyles.buttonText.copyWith(
                fontSize: 14,
                color: isSelected
                    ? WegooColors.onPrimaryContainer
                    : WegooColors.onSurface,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Budget Selector
// ─────────────────────────────────────────────────────────────
class _BudgetSelector extends StatelessWidget {
  const _BudgetSelector({
    required this.options,
    required this.selected,
    required this.onChanged,
  });
  final List<_BudgetOption> options;
  final BudgetLevel selected;
  final ValueChanged<BudgetLevel> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((opt) {
        final isSelected = selected == opt.level;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _BudgetCard(
            option: opt,
            isSelected: isSelected,
            onTap: () => onChanged(opt.level),
          ),
        );
      }).toList(),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });
  final _BudgetOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: WegooColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? WegooColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.10 : 0.05),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected
                    ? WegooColors.primaryContainer
                    : WegooColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                option.icon,
                color: isSelected
                    ? WegooColors.onPrimaryContainer
                    : WegooColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.label,
                    style: WegooTextStyles.buttonText.copyWith(
                      color: isSelected
                          ? WegooColors.primary
                          : WegooColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    option.subtitle,
                    style: WegooTextStyles.bodySmall
                        .copyWith(color: WegooColors.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(
                Icons.check_circle,
                color: WegooColors.primary,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Complete Button — now accepts isLoading
// ─────────────────────────────────────────────────────────────
class _CompleteButton extends StatefulWidget {
  const _CompleteButton({
    required this.onTap,
    required this.isLoading, // ← FIX 4: added
  });
  final VoidCallback onTap;
  final bool isLoading;

  @override
  State<_CompleteButton> createState() => _CompleteButtonState();
}

class _CompleteButtonState extends State<_CompleteButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.isLoading ? null : (_) => setState(() => _pressed = true),
      onTapUp: widget.isLoading
          ? null
          : (_) {
              setState(() => _pressed = false);
              widget.onTap();
            },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedOpacity(
          opacity: widget.isLoading ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: WegooColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: WegooColors.primary.withOpacity(0.28),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            // ── FIX 5: show spinner when loading ──────────
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
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Complete',
                          style: WegooTextStyles.buttonText
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.chevron_right,
                            color: Colors.white, size: 22),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Success Overlay
// ─────────────────────────────────────────────────────────────
class _SuccessOverlay extends StatefulWidget {
  const _SuccessOverlay();

  @override
  State<_SuccessOverlay> createState() => _SuccessOverlayState();
}

class _SuccessOverlayState extends State<_SuccessOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scale = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(_ctrl);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Opacity(opacity: _fade.value, child: child),
      child: Container(
        color: const Color(0xFF1C1B1B).withOpacity(0.4),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ScaleTransition(
                scale: _scale,
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 320),
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: WegooColors.surface,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 40,
                        offset: const Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: WegooColors.secondaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.travel_explore,
                          size: 40,
                          color: WegooColors.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'All set!',
                        style: WegooTextStyles.headline2
                            .copyWith(color: WegooColors.onSurface),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your adventurous journey with Wegoo begins now.',
                        textAlign: TextAlign.center,
                        style: WegooTextStyles.bodyMedium
                            .copyWith(color: WegooColors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          // ── FIX 6: real navigation ──────
                          onPressed: () => context.go('/home'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: WegooColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Go to Dashboard',
                            style: WegooTextStyles.buttonText
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
