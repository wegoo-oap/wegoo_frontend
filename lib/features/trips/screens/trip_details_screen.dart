import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripDetailsScreen extends StatefulWidget {
  const TripDetailsScreen({super.key});

  @override
  State<TripDetailsScreen> createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  String _tripType = 'solo';
  final Set<String> _selectedVibes = {};
  final TextEditingController _bioController = TextEditingController();
  bool _isPublic = true;
  bool _isLoading = false;

  final List<Map<String, dynamic>> _vibes = [
    {'label': 'Relax', 'icon': Icons.spa_outlined},
    {'label': 'Party', 'icon': Icons.celebration_outlined},
    {'label': 'Adventure', 'icon': Icons.hiking_outlined},
    {'label': 'Foodie', 'icon': Icons.restaurant_outlined},
    {'label': 'Culture', 'icon': Icons.museum_outlined},
    {'label': 'Beach', 'icon': Icons.beach_access_outlined},
  ];

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero image
                      _buildHeroImage(),
                      const SizedBox(height: 32),

                      // Trip type
                      _buildSectionLabel('WHO ARE YOU TRAVELING WITH?'),
                      const SizedBox(height: 10),
                      _buildTripTypeSelector(),
                      const SizedBox(height: 32),

                      // Vibe chips
                      _buildSectionLabel("WHAT'S THE VIBE?"),
                      const SizedBox(height: 10),
                      _buildVibeChips(),
                      const SizedBox(height: 32),

                      // Bio
                      _buildSectionLabel('TELL THE COMMUNITY ABOUT YOUR TRIP'),
                      const SizedBox(height: 10),
                      _buildBioField(),
                      const SizedBox(height: 32),

                      // Visibility
                      _buildVisibilityToggle(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom CTA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomCta(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFFCF9F8),
          boxShadow: [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => context.go('/trip/new/dates'),
              child: const Icon(Icons.arrow_back,
                  color: Color(0xFF0058BC), size: 22),
            ),
            const SizedBox(width: 16),
            const Text(
              'Tell us more',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0058BC),
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEBE7E7),
                borderRadius: BorderRadius.circular(99),
              ),
              child: const Text(
                'Step 3 of 4',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Color(0xFF414755),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
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
                  size: 56, color: Colors.white38),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0x99000000), Colors.transparent],
                ),
              ),
            ),
            const Positioned(
              bottom: 16,
              left: 16,
              child: Text(
                'Your Adventure Starts Here',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        color: Color(0xFF414755),
      ),
    );
  }

  Widget _buildTripTypeSelector() {
    final types = [
      {'key': 'solo', 'label': 'Solo'},
      {'key': 'couple', 'label': 'Couple'},
      {'key': 'group', 'label': 'Group'},
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: types.map((t) {
          final isActive = _tripType == t['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _tripType = t['key']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color:
                      isActive ? const Color(0xFFFE9400) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Text(
                    t['label']!,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? const Color(0xFF633700)
                          : const Color(0xFF414755),
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVibeChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _vibes.map((v) {
        final isSelected = _selectedVibes.contains(v['label']);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedVibes.remove(v['label']);
              } else {
                _selectedVibes.add(v['label'] as String);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF0058BC) : Colors.transparent,
              borderRadius: BorderRadius.circular(99),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF0058BC)
                    : const Color(0xFFC1C6D7),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  v['icon'] as IconData,
                  size: 16,
                  color: isSelected ? Colors.white : const Color(0xFF414755),
                ),
                const SizedBox(width: 6),
                Text(
                  v['label'] as String,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF414755),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBioField() {
    return Stack(
      children: [
        TextField(
          controller: _bioController,
          maxLines: 4,
          maxLength: 200,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 16,
            color: Color(0xFF1C1B1B),
          ),
          decoration: InputDecoration(
            hintText:
                "I'm planning to explore the hidden coves and find the best seafood spots...",
            hintStyle: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              color: Color(0xFF717786),
            ),
            counterText: '',
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFC1C6D7)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFC1C6D7)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0058BC), width: 2),
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 12,
          child: Text(
            '${_bioController.text.length}/200',
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 10,
              color: Color(0xFF717786),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVisibilityToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDEC)),
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
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFD8E2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _isPublic ? Icons.public : Icons.lock_outline,
              color: const Color(0xFF0058BC),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isPublic ? 'Public Visibility' : 'Private Trip',
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1B1B),
                  ),
                ),
                Text(
                  _isPublic
                      ? 'Everyone can see and join'
                      : 'Only invited members can see',
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    color: Color(0xFF414755),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isPublic,
            onChanged: (v) => setState(() => _isPublic = v),
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF0058BC),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFC1C6D7),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCta(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: _PublishButton(
        isLoading: _isLoading,
        onTap: () async {
          setState(() => _isLoading = true);
          await Future.delayed(const Duration(milliseconds: 1200));
          if (mounted) {
            setState(() => _isLoading = false);
            context.go('/trip/new/success');
          }
        },
      ),
    );
  }
}

// ── Publish Button ───────────────────────────────────────────

class _PublishButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _PublishButton({required this.isLoading, required this.onTap});

  @override
  State<_PublishButton> createState() => _PublishButtonState();
}

class _PublishButtonState extends State<_PublishButton> {
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
        duration: const Duration(milliseconds: 150),
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
                    'Publish Trip',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.16,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
