import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _activeFilter = 'All';

  final List<String> _filters = ['All', 'Requests', 'Messages', 'Trips'];

  final List<_NotifData> _newNotifs = [
    _NotifData(
      id: 'n1',
      type: _NotifType.request,
      title: 'wants to join your trip to',
      highlight1: 'Sarah',
      highlight2: 'Sidi Bou Said',
      time: '2m ago',
      borderColor: const Color(0xFF8C5000),
      badgeColor: const Color(0xFF8C5000),
      badgeIcon: Icons.handshake,
      hasActions: true,
    ),
    _NotifData(
      id: 'n2',
      type: _NotifType.message,
      title: 'sent a message in',
      highlight1: 'Alex',
      highlight2: 'Amalfi Coast Tribe',
      preview:
          '"Hey everyone! Does anyone have a preference for the boat tour time?"',
      time: '15m ago',
      borderColor: const Color(0xFF0058BC),
      badgeColor: const Color(0xFF0058BC),
      badgeIcon: Icons.chat_bubble,
      hasActions: false,
    ),
  ];

  final List<_NotifData> _earlierNotifs = [
    _NotifData(
      id: 'n3',
      type: _NotifType.trip,
      title: 'Your flight to Tunis was added to the itinerary.',
      highlight1: '',
      highlight2: '',
      time: '2h ago',
      borderColor: Colors.transparent,
      badgeColor: const Color(0xFF0070EB),
      badgeIcon: Icons.flight_takeoff,
      hasActions: false,
      hasLink: true,
      linkLabel: 'View Itinerary',
      isRead: false,
    ),
    _NotifData(
      id: 'n4',
      type: _NotifType.system,
      title: 'Verification complete!',
      subtitle:
          'You are now a Verified Traveler. This badge helps you build trust in the community.',
      highlight1: '',
      highlight2: '',
      time: 'Yesterday',
      borderColor: Colors.transparent,
      badgeColor: const Color(0xFFFE9400),
      badgeIcon: Icons.verified_user,
      hasActions: false,
      isTitleBold: true,
      isRead: false,
    ),
    _NotifData(
      id: 'n5',
      type: _NotifType.trip,
      title: 'Packing list updated for Atlas Mountains Hike.',
      highlight1: '',
      highlight2: 'Atlas Mountains Hike',
      time: '2d ago',
      borderColor: Colors.transparent,
      badgeColor: const Color(0xFFE5E2E1),
      badgeIcon: Icons.calendar_month,
      hasActions: false,
      isRead: true,
    ),
  ];

  final Set<String> _dismissed = {};

  List<_NotifData> get _filteredNew {
    if (_activeFilter == 'All')
      return _newNotifs.where((n) => !_dismissed.contains(n.id)).toList();
    if (_activeFilter == 'Requests')
      return _newNotifs
          .where(
              (n) => n.type == _NotifType.request && !_dismissed.contains(n.id))
          .toList();
    if (_activeFilter == 'Messages')
      return _newNotifs
          .where(
              (n) => n.type == _NotifType.message && !_dismissed.contains(n.id))
          .toList();
    return [];
  }

  List<_NotifData> get _filteredEarlier {
    if (_activeFilter == 'All') return _earlierNotifs;
    if (_activeFilter == 'Trips')
      return _earlierNotifs.where((n) => n.type == _NotifType.trip).toList();
    return _earlierNotifs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filter chips
                  _buildFilterChips(),
                  const SizedBox(height: 24),

                  // NEW section
                  if (_filteredNew.isNotEmpty) ...[
                    _buildSectionHeader('NEW',
                        badge: '${_filteredNew.length} NEW'),
                    const SizedBox(height: 12),
                    ..._filteredNew.map((n) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _NewNotifCard(
                            notif: n,
                            onAccept: () =>
                                setState(() => _dismissed.add(n.id)),
                            onDecline: () =>
                                setState(() => _dismissed.add(n.id)),
                          ),
                        )),
                    const SizedBox(height: 24),
                  ],

                  // EARLIER section
                  if (_filteredEarlier.isNotEmpty) ...[
                    _buildSectionHeader('EARLIER'),
                    const SizedBox(height: 12),
                    ..._filteredEarlier.map((n) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _EarlierNotifCard(
                            notif: n,
                            onLinkTap: () => context.go('/home'),
                          ),
                        )),
                  ],
                ],
              ),
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
        decoration: BoxDecoration(
          color: const Color(0xFFFCF9F8),
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
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back,
                  color: Color(0xFF0058BC), size: 22),
            ),
            const SizedBox(width: 16),
            const Text(
              'Notifications',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.52,
                color: Color(0xFF0058BC),
              ),
            ),
            const Spacer(),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFEBE7E7),
                border: Border.all(color: const Color(0xFF0058BC), width: 2),
              ),
              child:
                  const Icon(Icons.person, size: 18, color: Color(0xFF0058BC)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filters.map((f) {
          final isActive = _activeFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _activeFilter = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF0058BC)
                      : const Color(0xFFEBE7E7),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : const Color(0xFF414755),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: Color(0xFF717786),
          ),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFE9400),
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              badge,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF633700),
              ),
            ),
          ),
      ],
    );
  }
}

// ── New Notif Card ────────────────────────────────────────────

class _NewNotifCard extends StatefulWidget {
  final _NotifData notif;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const _NewNotifCard({
    required this.notif,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  State<_NewNotifCard> createState() => _NewNotifCardState();
}

class _NewNotifCardState extends State<_NewNotifCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final n = widget.notif;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: n.borderColor, width: 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar + badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD8E2FF),
                      ),
                      child: const Icon(Icons.person,
                          color: Color(0xFF0058BC), size: 28),
                    ),
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: n.badgeColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(n.badgeIcon, color: Colors.white, size: 10),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildRichText(n),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            n.time,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 11,
                              color: Color(0xFF717786),
                            ),
                          ),
                        ],
                      ),

                      // Preview
                      if (n.preview != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          n.preview!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Color(0xFF414755),
                          ),
                        ),
                      ],

                      // Action buttons
                      if (n.hasActions) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _ActionBtn(
                                label: 'Accept',
                                isPrimary: true,
                                onTap: widget.onAccept,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ActionBtn(
                                label: 'Decline',
                                isPrimary: false,
                                onTap: widget.onDecline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRichText(_NotifData n) {
    if (n.type == _NotifType.request) {
      return RichText(
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 15,
            color: Color(0xFF1C1B1B),
          ),
          children: [
            TextSpan(
              text: n.highlight1,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF0058BC),
              ),
            ),
            TextSpan(text: ' ${n.title} '),
            TextSpan(
              text: n.highlight2,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF8C5000),
              ),
            ),
          ],
        ),
      );
    }
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 15,
          color: Color(0xFF1C1B1B),
        ),
        children: [
          TextSpan(
            text: n.highlight1,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF0058BC),
            ),
          ),
          TextSpan(text: ' ${n.title} '),
          TextSpan(
            text: n.highlight2,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── Earlier Notif Card ────────────────────────────────────────

class _EarlierNotifCard extends StatelessWidget {
  final _NotifData notif;
  final VoidCallback onLinkTap;

  const _EarlierNotifCard({
    required this.notif,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final n = notif;
    return AnimatedOpacity(
      opacity: n.isRead ? 0.7 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F3F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon box
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: n.badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                n.badgeIcon,
                color: n.badgeColor == const Color(0xFFE5E2E1)
                    ? const Color(0xFF717786)
                    : Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                            fontWeight: n.isTitleBold
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: const Color(0xFF1C1B1B),
                            height: 1.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        n.time,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 11,
                          color: Color(0xFF717786),
                        ),
                      ),
                    ],
                  ),

                  // Subtitle
                  if (n.subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      n.subtitle!,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: Color(0xFF414755),
                        height: 1.4,
                      ),
                    ),
                  ],

                  // Link
                  if (n.hasLink) ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: onLinkTap,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'View Itinerary',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0058BC),
                            ),
                          ),
                          Icon(Icons.chevron_right,
                              color: Color(0xFF0058BC), size: 16),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Action Button ─────────────────────────────────────────────

class _ActionBtn extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_ActionBtn> createState() => _ActionBtnState();
}

class _ActionBtnState extends State<_ActionBtn> {
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
          height: 40,
          decoration: BoxDecoration(
            color:
                widget.isPrimary ? const Color(0xFF0058BC) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: widget.isPrimary
                ? null
                : Border.all(color: const Color(0xFFC1C6D7)),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color:
                    widget.isPrimary ? Colors.white : const Color(0xFF414755),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Data Models ───────────────────────────────────────────────

enum _NotifType { request, message, trip, system }

class _NotifData {
  final String id;
  final _NotifType type;
  final String title;
  final String highlight1;
  final String highlight2;
  final String? preview;
  final String? subtitle;
  final String time;
  final Color borderColor;
  final Color badgeColor;
  final IconData badgeIcon;
  final bool hasActions;
  final bool hasLink;
  final String? linkLabel;
  final bool isTitleBold;
  final bool isRead;

  const _NotifData({
    required this.id,
    required this.type,
    required this.title,
    required this.highlight1,
    required this.highlight2,
    this.preview,
    this.subtitle,
    required this.time,
    required this.borderColor,
    required this.badgeColor,
    required this.badgeIcon,
    required this.hasActions,
    this.hasLink = false,
    this.linkLabel,
    this.isTitleBold = false,
    this.isRead = false,
  });
}
