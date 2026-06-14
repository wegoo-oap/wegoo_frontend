import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ConnectionRequestsScreen extends StatefulWidget {
  const ConnectionRequestsScreen({super.key});

  @override
  State<ConnectionRequestsScreen> createState() =>
      _ConnectionRequestsScreenState();
}

class _ConnectionRequestsScreenState extends State<ConnectionRequestsScreen> {
  final List<_RequestData> _requests = [
    _RequestData(
      name: 'Elena Rossi',
      style: 'Solo Traveler • Adventure',
      matchScore: 98,
      isProMatch: true,
      tripTitle: 'Exploring Amalfi Coast',
      tripIcon: Icons.travel_explore,
      dates: '12 - 18 Oct',
      tags: ['Photography', 'Foodie'],
      message:
          '"Hey! I saw your itinerary for Positano. I\'m a landscape photographer based in Milan and I\'d love to join for the hiking parts!"',
    ),
    _RequestData(
      name: 'Mark Thompson',
      style: 'Explorer • Hiking Enthusiast',
      matchScore: 84,
      isProMatch: false,
      tripTitle: 'Dolomites Hut-to-Hut',
      tripIcon: Icons.landscape,
      dates: 'Sept 05 - 12',
      tags: ['Expert'],
      message:
          '"I\'ve done the Alta Via 1 before and would love to repeat it with a group. I can handle the navigation and gear checks!"',
    ),
    _RequestData(
      name: 'Sarah Chen',
      style: 'Backpacker • Culture Seeker',
      matchScore: 72,
      isProMatch: false,
      tripTitle: 'Tokyo Food Tour',
      tripIcon: Icons.restaurant,
      dates: 'Nov 20 - Dec 01',
      tags: [],
      message:
          '"Looking for some fun people to explore the hidden izakayas with! I speak basic Japanese."',
    ),
  ];

  final Set<int> _dismissed = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Connection Requests',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.56,
                      color: Color(0xFF1C1B1B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Travelers who want to join your journey',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      color: Color(0xFF414755),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Request cards
                  ..._requests
                      .asMap()
                      .entries
                      .where(
                        (e) => !_dismissed.contains(e.key),
                      )
                      .map(
                        (e) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _RequestCard(
                            data: e.value,
                            onAccept: () {
                              setState(() => _dismissed.add(e.key));
                              _showSnackbar(context,
                                  '✓ Connected with ${e.value.name}!', true);
                            },
                            onDecline: () {
                              setState(() => _dismissed.add(e.key));
                              _showSnackbar(
                                  context,
                                  'Request from ${e.value.name} declined',
                                  false);
                            },
                          ),
                        ),
                      ),

                  if (_dismissed.length == _requests.length) _buildEmptyState(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackbar(BuildContext context, String message, bool isSuccess) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor:
            isSuccess ? const Color(0xFF0058BC) : const Color(0xFF717786),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined,
                size: 64, color: const Color(0xFF414755).withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              'No pending requests',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF414755),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'All caught up! Check back later.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Color(0xFF717786),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFFCF9F8),
          border: Border(
            bottom: BorderSide(color: Color(0x1AC1C6D7)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
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
            const Icon(Icons.notifications_outlined,
                color: Color(0xFF0058BC), size: 24),
          ],
        ),
      ),
    );
  }
}

// ── Request Data Model ────────────────────────────────────────

class _RequestData {
  final String name;
  final String style;
  final int matchScore;
  final bool isProMatch;
  final String tripTitle;
  final IconData tripIcon;
  final String dates;
  final List<String> tags;
  final String message;

  const _RequestData({
    required this.name,
    required this.style,
    required this.matchScore,
    required this.isProMatch,
    required this.tripTitle,
    required this.tripIcon,
    required this.dates,
    required this.tags,
    required this.message,
  });
}

// ── Request Card ──────────────────────────────────────────────

class _RequestCard extends StatelessWidget {
  final _RequestData data;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _RequestCard({
    required this.data,
    required this.onAccept,
    required this.onDecline,
  });

  Color get _scoreColor {
    if (data.matchScore >= 90) return const Color(0xFF0058BC);
    if (data.matchScore >= 80) return const Color(0xFF8C5000);
    return const Color(0xFF717786);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC1C6D7).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + score badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD8E2FF),
                        border: Border.all(
                          color: const Color(0xFF0058BC).withOpacity(0.1),
                          width: 3,
                        ),
                      ),
                      child: const ClipOval(
                        child: Icon(Icons.person,
                            size: 40, color: Color(0xFF0058BC)),
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFE9400),
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Text(
                          '${data.matchScore}%',
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF633700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                // Name + style + pro badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        data.name,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        data.style.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                          color: Color(0xFF0058BC),
                        ),
                      ),
                      if (data.isProMatch) ...[
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0070EB).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_user,
                                  size: 12, color: Color(0xFF0070EB)),
                              SizedBox(width: 4),
                              Text(
                                'PRO MATCH',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  color: Color(0xFF0070EB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Trip interest card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3F2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFC1C6D7).withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(data.tripIcon,
                          size: 16, color: const Color(0xFF8C5000)),
                      const SizedBox(width: 6),
                      const Text(
                        'TRIP INTEREST',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          color: Color(0xFF414755),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.tripTitle,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1B1B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      // Date chip
                      _TripChip(
                        icon: Icons.calendar_month,
                        label: data.dates,
                      ),
                      // Tag chips
                      ...data.tags.map(
                        (t) => _TripChip(label: t),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Message
            Text(
              data.message,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Color(0xFF414755),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: _CardButton(
                    label: 'Decline',
                    isPrimary: false,
                    onTap: onDecline,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _CardButton(
                    label: 'Accept',
                    isPrimary: true,
                    icon: Icons.check_circle,
                    onTap: onAccept,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Trip Chip ─────────────────────────────────────────────────

class _TripChip extends StatelessWidget {
  final IconData? icon;
  final String label;

  const _TripChip({this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFC1C6D7).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: const Color(0xFF414755)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF414755),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card Button ───────────────────────────────────────────────

class _CardButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final IconData? icon;
  final VoidCallback onTap;

  const _CardButton({
    required this.label,
    required this.isPrimary,
    this.icon,
    required this.onTap,
  });

  @override
  State<_CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<_CardButton> {
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
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color:
                widget.isPrimary ? const Color(0xFF0058BC) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: widget.isPrimary
                ? null
                : Border.all(
                    color: const Color(0xFFC1C6D7),
                    width: 2,
                  ),
            boxShadow: widget.isPrimary
                ? [
                    BoxShadow(
                      color: const Color(0xFF0058BC).withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(
                  widget.icon,
                  size: 16,
                  color:
                      widget.isPrimary ? Colors.white : const Color(0xFF414755),
                ),
                const SizedBox(width: 6),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color:
                      widget.isPrimary ? Colors.white : const Color(0xFF414755),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
