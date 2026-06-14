import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyTripsScreen extends StatefulWidget {
  const MyTripsScreen({super.key});

  @override
  State<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends State<MyTripsScreen> {
  String _filter = 'All';

  final List<_TripData> _trips = [
    _TripData(
      id: '1',
      title: 'Amalfi Coastal Escape',
      location: 'Amalfi Coast, Italy',
      dates: 'Aug 12 - Aug 24, 2024',
      status: 'Active',
      memberCount: 4,
      isActive: true,
    ),
    _TripData(
      id: '2',
      title: 'Swiss Alps Expedition',
      location: 'Interlaken & Grindelwald',
      dates: 'May 2024',
      status: 'Past',
      memberCount: 0,
      isActive: false,
    ),
  ];

  List<_TripData> get _filtered {
    if (_filter == 'All') return _trips;
    return _trips.where((t) => t.status == _filter).toList();
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section header
                      _buildSectionHeader(),
                      const SizedBox(height: 24),

                      // Trip cards
                      ..._filtered.map((trip) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: trip.isActive
                                ? _ActiveTripCard(
                                    trip: trip,
                                    onTap: () {},
                                  )
                                : _PastTripCard(trip: trip),
                          )),

                      // Empty state
                      _EmptyStateCard(
                        onTap: () => context.go('/trip/new/destination'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // FAB
          Positioned(
            bottom: 90,
            right: 20,
            child: _FabBtn(
              onTap: () => context.go('/trip/new/destination'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: const Color(0xFFFCF9F8),
        child: Row(
          children: [
            const Icon(Icons.menu, color: Color(0xFF414755), size: 24),
            const SizedBox(width: 12),
            const Text(
              'Wegoo',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.56,
                color: Color(0xFF0058BC),
              ),
            ),
            const Spacer(),
            const Icon(Icons.notifications_outlined,
                color: Color(0xFF414755), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'ADVENTURES',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: Color(0xFF0058BC),
              ),
            ),
            SizedBox(height: 2),
            Text(
              'My Trips',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1B1B),
              ),
            ),
          ],
        ),

        // Filter tabs
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFEBE7E7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: ['All', 'Active'].map((tab) {
              final isActive = _filter == tab;
              return GestureDetector(
                onTap: () => setState(() => _filter = tab),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? const Color(0xFF0058BC)
                          : const Color(0xFF414755),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

// ── Active Trip Card ──────────────────────────────────────────

class _ActiveTripCard extends StatefulWidget {
  final _TripData trip;
  final VoidCallback onTap;

  const _ActiveTripCard({required this.trip, required this.onTap});

  @override
  State<_ActiveTripCard> createState() => _ActiveTripCardState();
}

class _ActiveTripCardState extends State<_ActiveTripCard> {
  bool _hovered = false;
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
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Column(
                children: [
                  // Image section
                  SizedBox(
                    height: 200,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background
                        AnimatedScale(
                          scale: _hovered ? 1.05 : 1.0,
                          duration: const Duration(milliseconds: 600),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF0058BC).withOpacity(0.6),
                                  const Color(0xFFFE9400).withOpacity(0.7),
                                ],
                              ),
                            ),
                            child: const Icon(Icons.travel_explore,
                                size: 56, color: Colors.white38),
                          ),
                        ),

                        // Active badge
                        Positioned(
                          top: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0070EB),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Gradient + text overlay
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Color(0x99000000),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.trip.dates,
                                  style: const TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11,
                                    color: Colors.white70,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.trip.title,
                                  style: const TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom row
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        // Overlapping avatars
                        SizedBox(
                          width: 80,
                          height: 32,
                          child: Stack(
                            children: [
                              _OlapAvatar(offset: 0),
                              _OlapAvatar(offset: 20),
                              Positioned(
                                left: 40,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFE9400),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      '+2',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Row(
                            children: [
                              Text(
                                'Details',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF0058BC),
                                ),
                              ),
                              Icon(Icons.chevron_right,
                                  color: Color(0xFF0058BC), size: 18),
                            ],
                          ),
                        ),
                      ],
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

// ── Past Trip Card ────────────────────────────────────────────

class _PastTripCard extends StatefulWidget {
  final _TripData trip;
  const _PastTripCard({required this.trip});

  @override
  State<_PastTripCard> createState() => _PastTripCardState();
}

class _PastTripCardState extends State<_PastTripCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedOpacity(
        opacity: _hovered ? 1.0 : 0.8,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F3F2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 88,
                  height: 88,
                  color: const Color(0xFFE5E2E1),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: _hovered
                                ? [
                                    const Color(0xFF0058BC).withOpacity(0.4),
                                    const Color(0xFFFE9400).withOpacity(0.5),
                                  ]
                                : [
                                    Colors.grey.withOpacity(0.4),
                                    Colors.grey.withOpacity(0.3),
                                  ],
                          ),
                        ),
                        child: Icon(
                          Icons.landscape,
                          size: 36,
                          color: _hovered ? Colors.white70 : Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'PAST TRIP',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: Color(0xFF717786),
                          ),
                        ),
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC1C6D7),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          widget.trip.dates,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10,
                            color: Color(0xFF717786),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.trip.title,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1B1B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.trip.location,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: Color(0xFF414755),
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.history, color: Color(0xFF717786), size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Empty State Card ──────────────────────────────────────────

class _EmptyStateCard extends StatelessWidget {
  final VoidCallback onTap;
  const _EmptyStateCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFC1C6D7),
          width: 2,
          // dashed via workaround
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEBE7E7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_location_alt,
                color: Color(0xFF0058BC), size: 30),
          ),
          const SizedBox(height: 16),
          const Text(
            'Planning something new?',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Start a new itinerary and invite your fellow travelers to join the adventure.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 13,
                color: Color(0xFF414755),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                border: Border.all(color: const Color(0xFF0058BC)),
              ),
              child: const Text(
                'Explore Destinations',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0058BC),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Trip Data Model ───────────────────────────────────────────

class _TripData {
  final String id;
  final String title;
  final String location;
  final String dates;
  final String status;
  final int memberCount;
  final bool isActive;

  const _TripData({
    required this.id,
    required this.title,
    required this.location,
    required this.dates,
    required this.status,
    required this.memberCount,
    required this.isActive,
  });
}

// ── Overlapping Avatar ────────────────────────────────────────

class _OlapAvatar extends StatelessWidget {
  final double offset;
  const _OlapAvatar({required this.offset});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFD8E2FF),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.person, size: 16, color: Color(0xFF0058BC)),
      ),
    );
  }
}

// ── FAB ──────────────────────────────────────────────────────

class _FabBtn extends StatefulWidget {
  final VoidCallback onTap;
  const _FabBtn({required this.onTap});

  @override
  State<_FabBtn> createState() => _FabBtnState();
}

class _FabBtnState extends State<_FabBtn> {
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
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: const Color(0xFFFE9400),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE9400).withOpacity(0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
