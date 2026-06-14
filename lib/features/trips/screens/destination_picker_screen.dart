import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DestinationPickerScreen extends StatefulWidget {
  const DestinationPickerScreen({super.key});

  @override
  State<DestinationPickerScreen> createState() =>
      _DestinationPickerScreenState();
}

class _DestinationPickerScreenState extends State<DestinationPickerScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSearchOverlay = false;
  String? _selectedDestination;
  String? _selectedCountry;

  final List<Map<String, String>> _suggestions = [
    {'city': 'Madrid', 'country': 'Spain'},
    {'city': 'Marseille', 'country': 'France'},
    {'city': 'Marrakech', 'country': 'Morocco'},
    {'city': 'Tunis', 'country': 'Tunisia'},
    {'city': 'Istanbul', 'country': 'Turkey'},
    {'city': 'Rome', 'country': 'Italy'},
    {'city': 'Athens', 'country': 'Greece'},
    {'city': 'Lisbon', 'country': 'Portugal'},
  ];

  List<Map<String, String>> _filteredSuggestions = [];

  final List<Map<String, dynamic>> _recent = [
    {
      'city': 'Barcelona',
      'country': 'Spain',
      'subtitle': 'Last viewed 2 days ago',
    },
  ];

  final List<Map<String, dynamic>> _popular = [
    {
      'city': 'Sidi Bou Said',
      'country': 'Tunisia',
      'badge': 'Trending',
      'badgeColor': Color(0xFFFE9400),
      'badgeTextColor': Color(0xFF633700),
    },
    {
      'city': 'Amalfi Coast',
      'country': 'Italy',
      'badge': null,
    },
    {
      'city': 'Santorini',
      'country': 'Greece',
      'badge': 'Highly Rated',
      'badgeColor': Color(0xFF0070EB),
      'badgeTextColor': Color(0xFFFEFCFF),
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredSuggestions = _suggestions;
    _searchController.addListener(() {
      final q = _searchController.text.toLowerCase();
      setState(() {
        _filteredSuggestions = q.isEmpty
            ? _suggestions
            : _suggestions
                .where((s) =>
                    s['city']!.toLowerCase().contains(q) ||
                    s['country']!.toLowerCase().contains(q))
                .toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectDestination(String city, String country) {
    setState(() {
      _selectedDestination = city;
      _selectedCountry = country;
      _showSearchOverlay = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Stack(
        children: [
          // Main content
          Column(
            children: [
              // Header
              _buildHeader(context),

              // Scrollable body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Where are you going?',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.56,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Choose your next Mediterranean adventure.',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          color: Color(0xFF414755),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Search bar
                      _buildSearchBar(),
                      const SizedBox(height: 32),

                      // Selected destination banner
                      if (_selectedDestination != null) ...[
                        _SelectedBanner(
                          city: _selectedDestination!,
                          country: _selectedCountry!,
                          onClear: () => setState(() {
                            _selectedDestination = null;
                            _selectedCountry = null;
                          }),
                        ),
                        const SizedBox(height: 32),
                      ],

                      // Recent
                      _buildSectionHeader('Recent', showClear: true),
                      const SizedBox(height: 12),
                      ..._recent.map((r) => _RecentItem(
                            city: r['city'],
                            subtitle: r['subtitle'],
                            onTap: () => _selectDestination(
                                r['city'], r['country'] ?? ''),
                          )),
                      const SizedBox(height: 32),

                      // Popular destinations
                      _buildSectionHeader('Popular Destinations'),
                      const SizedBox(height: 12),
                      ..._popular.map((d) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _DestinationCard(
                              city: d['city'],
                              country: d['country'],
                              badge: d['badge'],
                              badgeColor: d['badgeColor'],
                              badgeTextColor: d['badgeTextColor'],
                              isSelected: _selectedDestination == d['city'],
                              onTap: () =>
                                  _selectDestination(d['city'], d['country']),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Search overlay
          if (_showSearchOverlay) _buildSearchOverlay(),

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.go('/home'),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Color(0xFF0058BC), size: 22),
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'STEP 1 OF 4',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFF414755),
                  ),
                ),
              ],
            ),
            const Icon(Icons.more_vert, color: Color(0xFF0058BC), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => setState(() => _showSearchOverlay = true),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFC1C6D7)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Icon(Icons.travel_explore,
                color: Color(0xFF717786), size: 22),
            const SizedBox(width: 12),
            Text(
              _selectedDestination ?? 'Search city or country...',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                color: _selectedDestination != null
                    ? const Color(0xFF1C1B1B)
                    : const Color(0xFFC1C6D7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showClear = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Color(0xFF414755),
          ),
        ),
        if (showClear)
          GestureDetector(
            onTap: () {},
            child: const Text(
              'Clear',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0058BC),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchOverlay() {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFFFCF9F8),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() => _showSearchOverlay = false);
                        _searchController.clear();
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: const Icon(Icons.close,
                            color: Color(0xFF1C1B1B), size: 22),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1B1B),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Where to?',
                          hintStyle: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFC1C6D7),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFFE5E2E1)),
              const SizedBox(height: 16),

              // Suggestions label
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'SUGGESTIONS',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFF414755),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Results
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredSuggestions.length,
                  itemBuilder: (context, i) {
                    final s = _filteredSuggestions[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      leading: const Icon(Icons.location_on,
                          color: Color(0xFF0058BC)),
                      title: Text(
                        '${s['city']}, ${s['country']}',
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                      onTap: () =>
                          _selectDestination(s['city']!, s['country']!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      hoverColor: const Color(0xFFF0EDEC),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomCta(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F8).withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: _ContinueButton(
        enabled: _selectedDestination != null,
        onTap: () => context.go('/trip/new/dates'),
      ),
    );
  }
}

// ── Selected Banner ──────────────────────────────────────────

class _SelectedBanner extends StatelessWidget {
  final String city;
  final String country;
  final VoidCallback onClear;

  const _SelectedBanner({
    required this.city,
    required this.country,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0058BC).withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0058BC).withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Color(0xFF0058BC), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$city, $country',
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0058BC),
              ),
            ),
          ),
          GestureDetector(
            onTap: onClear,
            child: const Icon(Icons.close, color: Color(0xFF0058BC), size: 18),
          ),
        ],
      ),
    );
  }
}

// ── Recent Item ──────────────────────────────────────────────

class _RecentItem extends StatefulWidget {
  final String city;
  final String subtitle;
  final VoidCallback onTap;

  const _RecentItem({
    required this.city,
    required this.subtitle,
    required this.onTap,
  });

  @override
  State<_RecentItem> createState() => _RecentItemState();
}

class _RecentItemState extends State<_RecentItem> {
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFC1C6D7).withOpacity(0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFDCBF),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Icon(Icons.history,
                    color: Color(0xFF6A3B00), size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.city,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1B1B),
                      ),
                    ),
                    Text(
                      widget.subtitle,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: Color(0xFF414755),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFFC1C6D7), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Destination Card ─────────────────────────────────────────

class _DestinationCard extends StatefulWidget {
  final String city;
  final String country;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _DestinationCard({
    required this.city,
    required this.country,
    this.badge,
    this.badgeColor,
    this.badgeTextColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_DestinationCard> createState() => _DestinationCardState();
}

class _DestinationCardState extends State<_DestinationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: widget.isSelected
                    ? const Color(0xFF0058BC).withOpacity(0.2)
                    : Colors.black.withOpacity(0.08),
                blurRadius: widget.isSelected ? 16 : 8,
                offset: const Offset(0, 4),
              ),
            ],
            border: widget.isSelected
                ? Border.all(color: const Color(0xFF0058BC), width: 2.5)
                : null,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient placeholder
                  AnimatedScale(
                    scale: _hovered ? 1.08 : 1.0,
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF0058BC).withOpacity(0.4),
                            const Color(0xFFFE9400).withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.travel_explore,
                            size: 48, color: Colors.white54),
                      ),
                    ),
                  ),

                  // Gradient overlay
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xCC000000),
                          Color(0x33000000),
                          Colors.transparent,
                        ],
                        stops: [0, 0.5, 1],
                      ),
                    ),
                  ),

                  // Content
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.badge != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: widget.badgeColor,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              widget.badge!.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: widget.badgeTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                        ],
                        Text(
                          widget.city,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text(
                              widget.country,
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 13,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Selected checkmark
                  if (widget.isSelected)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0058BC),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 16),
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

// ── Continue Button ──────────────────────────────────────────

class _ContinueButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _ContinueButton({required this.enabled, required this.onTap});

  @override
  State<_ContinueButton> createState() => _ContinueButtonState();
}

class _ContinueButtonState extends State<_ContinueButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled
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
          opacity: widget.enabled ? 1.0 : 0.45,
          duration: const Duration(milliseconds: 200),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC),
              borderRadius: BorderRadius.circular(16),
              boxShadow: widget.enabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0058BC).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Continue to Step 2',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.16,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
