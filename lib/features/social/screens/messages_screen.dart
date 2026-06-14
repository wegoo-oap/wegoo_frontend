import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final List<_ChatItem> _chats = [
    _ChatItem(
      id: 'sarah',
      name: 'Sarah Mitchell',
      lastMessage: "I just saw those flight prices! Let's book...",
      time: '12:45 PM',
      isUnread: true,
      unreadCount: 1,
      isGroup: false,
      initials: '',
      avatarColor: const Color(0xFFD8E2FF),
    ),
    _ChatItem(
      id: 'cinque',
      name: 'Cinque Terre Group',
      lastMessage: 'Marco: Should we take the train from Rome?',
      time: '10:12 AM',
      isUnread: true,
      unreadCount: 3,
      isGroup: true,
      initials: 'CT',
      avatarColor: const Color(0xFFFE9400),
    ),
    _ChatItem(
      id: 'marcus',
      name: 'Marcus Chen',
      lastMessage: 'Thanks for the recommendation! The hotel was...',
      time: 'Yesterday',
      isUnread: false,
      unreadCount: 0,
      isGroup: false,
      initials: '',
      avatarColor: const Color(0xFFFFDCBF),
    ),
    _ChatItem(
      id: 'elena',
      name: 'Elena Rossi',
      lastMessage: "I'll send the itinerary once I get home.",
      time: 'Tuesday',
      isUnread: false,
      unreadCount: 0,
      isGroup: false,
      initials: '',
      avatarColor: const Color(0xFFD8E2FF),
    ),
    _ChatItem(
      id: 'tokyo',
      name: 'Tokyo Adventure',
      lastMessage: "Yuki: Don't forget the sushi tour at 6!",
      time: 'Aug 12',
      isUnread: false,
      unreadCount: 0,
      isGroup: true,
      initials: 'TA',
      avatarColor: const Color(0xFF757474),
    ),
    _ChatItem(
      id: 'david',
      name: 'David Cooper',
      lastMessage: 'The gear list for the hike is attached...',
      time: 'Aug 10',
      isUnread: false,
      unreadCount: 0,
      isGroup: false,
      initials: '',
      avatarColor: const Color(0xFFE4E2E2),
    ),
  ];

  List<_ChatItem> get _filtered {
    if (_query.isEmpty) return _chats;
    return _chats
        .where((c) =>
            c.name.toLowerCase().contains(_query.toLowerCase()) ||
            c.lastMessage.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  void _markAllRead() {
    setState(() {
      for (var c in _chats) {
        c.isUnread = false;
        c.unreadCount = 0;
      }
    });
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
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search bar
                      _buildSearchBar(),
                      const SizedBox(height: 24),

                      // Section title
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Recent Chats',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1B1B),
                            ),
                          ),
                          GestureDetector(
                            onTap: _markAllRead,
                            child: const Text(
                              'Mark all read',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0058BC),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Quick test buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.push('/chat/fake-chat-id'),
                              child: const Text('Test Direct Chat'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.push('/groups/fake-group-id/chat'),
                              child: const Text('Test Group Chat'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Chat list
                      if (_filtered.isEmpty)
                        _buildEmptyState()
                      else
                        ..._filtered.map(
                          (chat) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _ChatRow(
                              chat: chat,
                              onTap: () {
                                if (chat.isGroup) {
                                  context.go('/groups/${chat.id}/chat');
                                } else {
                                  context.go('/chat/${chat.id}');
                                }
                              },
                            ),
                          ),
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
            child: _FabButton(onTap: () => context.push('/groups/new')),
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
            const Icon(Icons.menu, color: Color(0xFF0058BC), size: 24),
            const SizedBox(width: 16),
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
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFD8E2FF),
                border: Border.all(color: const Color(0xFFD8E2FF), width: 2),
              ),
              child:
                  const Icon(Icons.person, size: 18, color: Color(0xFF0058BC)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC1C6D7)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: Color(0xFF717786), size: 22),
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
                hintText: 'Search conversations...',
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.search_off,
                size: 56, color: const Color(0xFF414755).withOpacity(0.3)),
            const SizedBox(height: 16),
            const Text(
              'No conversations found',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 16,
                color: Color(0xFF414755),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Chat Item Model ───────────────────────────────────────────

class _ChatItem {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  bool isUnread;
  int unreadCount;
  final bool isGroup;
  final String initials;
  final Color avatarColor;

  _ChatItem({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.isUnread,
    required this.unreadCount,
    required this.isGroup,
    required this.initials,
    required this.avatarColor,
  });
}

// ── Chat Row ──────────────────────────────────────────────────

class _ChatRow extends StatefulWidget {
  final _ChatItem chat;
  final VoidCallback onTap;

  const _ChatRow({required this.chat, required this.onTap});

  @override
  State<_ChatRow> createState() => _ChatRowState();
}

class _ChatRowState extends State<_ChatRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final chat = widget.chat;
    final isUnread = chat.isUnread;

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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isUnread ? Colors.white : const Color(0xFFF6F3F2),
            borderRadius: BorderRadius.circular(12),
            border: isUnread
                ? Border(
                    left: BorderSide(
                      color: const Color(0xFF0070EB),
                      width: 4,
                    ),
                  )
                : null,
            boxShadow: isUnread
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // Avatar
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: chat.avatarColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: chat.isGroup
                        ? Center(
                            child: Text(
                              chat.initials,
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.person,
                            size: 30, color: Colors.white70),
                  ),
                  // Unread badge
                  if (isUnread)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: chat.unreadCount > 1 ? 20 : 14,
                        height: chat.unreadCount > 1 ? 20 : 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0070EB),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: chat.unreadCount > 1
                            ? Center(
                                child: Text(
                                  '${chat.unreadCount}',
                                  style: const TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            : null,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            chat.name,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1C1B1B),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          chat.time,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                            color: isUnread
                                ? const Color(0xFF0058BC)
                                : const Color(0xFF717786),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chat.lastMessage,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        fontWeight:
                            isUnread ? FontWeight.w600 : FontWeight.w400,
                        color: isUnread
                            ? const Color(0xFF1C1B1B)
                            : const Color(0xFF414755),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── FAB ──────────────────────────────────────────────────────

class _FabButton extends StatefulWidget {
  final VoidCallback onTap;
  const _FabButton({required this.onTap});

  @override
  State<_FabButton> createState() => _FabButtonState();
}

class _FabButtonState extends State<_FabButton> {
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
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF0070EB),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0070EB).withOpacity(0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.edit_square, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}
