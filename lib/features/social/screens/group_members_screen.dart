import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupMembersScreen extends StatefulWidget {
  final String groupId;
  const GroupMembersScreen({super.key, required this.groupId});

  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_MemberData> _members = [
    _MemberData(
      name: 'Marco Rossi',
      subtitle: 'Heading to: Positano',
      role: 'Admin',
      isVerified: true,
      avatarColor: const Color(0xFFD8E2FF),
    ),
    _MemberData(
      name: 'Elena Vance',
      subtitle: 'Passionate hiker & landscape photographer',
      role: 'Pro Explorer',
      isVerified: true,
      avatarColor: const Color(0xFFFFDCBF),
    ),
    _MemberData(
      name: 'Julian Peters',
      subtitle: 'Heading to: Amalfi Town',
      role: null,
      isVerified: false,
      avatarColor: const Color(0xFFD8E2FF),
    ),
    _MemberData(
      name: 'Sofia Moretti',
      subtitle: 'Local guide & foodie expert',
      role: 'Pro Explorer',
      isVerified: true,
      avatarColor: const Color(0xFFFFDCBF),
    ),
    _MemberData(
      name: 'Chloe Bennett',
      subtitle: 'Heading to: Ravello',
      role: null,
      isVerified: false,
      avatarColor: const Color(0xFFE4E2E2),
    ),
  ];

  List<_MemberData> get _filtered {
    if (_query.isEmpty) return _members;
    return _members
        .where((m) =>
            m.name.toLowerCase().contains(_query.toLowerCase()) ||
            m.subtitle.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              child: Column(
                children: [
                  // Context card
                  _buildContextCard(),
                  const SizedBox(height: 24),

                  // Search
                  _buildSearch(),
                  const SizedBox(height: 24),

                  // Members list
                  if (_filtered.isEmpty)
                    _buildEmptyState()
                  else
                    ..._filtered.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _MemberRow(
                            member: m,
                            onChat: () => context.go(
                                '/chat/${m.name.toLowerCase().replaceAll(' ', '_')}'),
                            onTap: () {},
                          ),
                        )),
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
                  color: Color(0xFF414755), size: 22),
            ),
            const SizedBox(width: 16),
            const Text(
              'Tribe Members',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.48,
                color: Color(0xFF0058BC),
              ),
            ),
            const Spacer(),
            // Invite button
            GestureDetector(
              onTap: () {},
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF0058BC),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.person_add, color: Colors.white, size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Invite',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
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
    );
  }

  Widget _buildContextCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F2),
        borderRadius: BorderRadius.circular(12),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Amalfi Coast Explorers',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1B1B),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '42 active members trekking the Italian coast',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    color: Color(0xFF414755),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Overlapping avatars
          SizedBox(
            width: 88,
            height: 40,
            child: Stack(
              children: [
                _OlapAvatar(offset: 0, color: const Color(0xFFD8E2FF)),
                _OlapAvatar(offset: 20, color: const Color(0xFFFFDCBF)),
                Positioned(
                  left: 40,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0070EB),
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFF6F3F2), width: 2),
                    ),
                    child: const Center(
                      child: Text(
                        '+39',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 10,
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
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC1C6D7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: Color(0xFF717786), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _query = v),
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 15,
                color: Color(0xFF1C1B1B),
              ),
              decoration: const InputDecoration(
                hintText: 'Find a tribe member...',
                hintStyle: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  color: Color(0xFF717786),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.search_off,
              size: 56, color: const Color(0xFF414755).withOpacity(0.3)),
          const SizedBox(height: 16),
          const Text(
            'No members found',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 16,
              color: Color(0xFF414755),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Member Row ────────────────────────────────────────────────

class _MemberRow extends StatefulWidget {
  final _MemberData member;
  final VoidCallback onChat;
  final VoidCallback onTap;

  const _MemberRow({
    required this.member,
    required this.onChat,
    required this.onTap,
  });

  @override
  State<_MemberRow> createState() => _MemberRowState();
}

class _MemberRowState extends State<_MemberRow> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final m = widget.member;

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _pressed ? const Color(0xFFEBE7E7) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? const Color(0xFFC1C6D7) : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovered ? 0.08 : 0.04),
                blurRadius: _hovered ? 12 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Avatar with verified badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: m.avatarColor,
                      border: m.isVerified
                          ? Border.all(color: const Color(0xFF0058BC), width: 2)
                          : null,
                    ),
                    child: const ClipOval(
                      child:
                          Icon(Icons.person, size: 36, color: Colors.white70),
                    ),
                  ),
                  if (m.isVerified)
                    Positioned(
                      bottom: -2,
                      right: -2,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0058BC),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.verified,
                            color: Colors.white, size: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            m.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1B1B),
                            ),
                          ),
                        ),
                        if (m.role != null) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFE9400),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              m.role!.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: Color(0xFF633700),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      m.subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: Color(0xFF414755),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Chat icon
              GestureDetector(
                onTap: widget.onChat,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.chat_bubble_outline,
                    color: Color(0xFF717786),
                    size: 22,
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

// ── Overlapping Avatar ────────────────────────────────────────

class _OlapAvatar extends StatelessWidget {
  final double offset;
  final Color color;

  const _OlapAvatar({required this.offset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFF6F3F2), width: 2),
        ),
        child: const Icon(Icons.person, size: 22, color: Colors.white70),
      ),
    );
  }
}

// ── Member Data Model ─────────────────────────────────────────

class _MemberData {
  final String name;
  final String subtitle;
  final String? role;
  final bool isVerified;
  final Color avatarColor;

  const _MemberData({
    required this.name,
    required this.subtitle,
    required this.role,
    required this.isVerified,
    required this.avatarColor,
  });
}
