import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GroupChatScreen extends StatefulWidget {
  final String groupId;
  const GroupChatScreen({super.key, required this.groupId});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<_GroupMessage> _messages = [
    _GroupMessage(
      senderId: 'sarah',
      senderName: 'Sarah',
      text:
          "Hey everyone! Just checked the ferry schedule from Riomaggiore. It leaves at 9:30 AM tomorrow. Should we book now? ⛴️",
      time: '09:12 AM',
      type: _MsgType.received,
      color: const Color(0xFF0058BC),
      nameColor: const Color(0xFF0058BC),
      bubbleColor: const Color(0xFF0058BC),
      textColor: Colors.white,
    ),
    _GroupMessage(
      senderId: 'marco',
      senderName: 'Marco',
      text:
          "Yes! The morning ferries fill up fast. I can grab the tickets if you guys are in. 🎟️",
      time: '09:15 AM',
      type: _MsgType.received,
      color: const Color(0xFF8C5000),
      nameColor: const Color(0xFF8C5000),
      bubbleColor: const Color(0xFFFE9400),
      textColor: const Color(0xFF633700),
    ),
    _GroupMessage(
      senderId: 'me',
      senderName: 'Me',
      text:
          "Just saw this view from the balcony! Totally in for the ferry. Can't wait!",
      time: '09:20 AM',
      type: _MsgType.sent,
      hasImage: true,
      isRead: true,
      color: const Color(0xFF414755),
      nameColor: const Color(0xFF414755),
      bubbleColor: const Color(0xFFE5E2E1),
      textColor: const Color(0xFF1C1B1B),
    ),
    _GroupMessage(
      senderId: 'elena',
      senderName: 'Elena',
      text:
          "I'm in! Also, does anyone want to try that pesto place for dinner tonight? I heard it's the best in Manarola. 🍝",
      time: '09:22 AM',
      type: _MsgType.received,
      color: const Color(0xFF5C5C5C),
      nameColor: const Color(0xFF5C5C5C),
      bubbleColor: const Color(0xFFF6F3F2),
      textColor: const Color(0xFF1C1B1B),
      hasBorder: true,
    ),
  ];

  late AnimationController _dot1;
  late AnimationController _dot2;
  late AnimationController _dot3;

  @override
  void initState() {
    super.initState();
    _dot1 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _dot2 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _dot3 = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    Future.delayed(const Duration(milliseconds: 200),
        () => mounted ? _dot2.repeat(reverse: true) : null);
    Future.delayed(const Duration(milliseconds: 400),
        () => mounted ? _dot3.repeat(reverse: true) : null);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _dot1.dispose();
    _dot2.dispose();
    _dot3.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_GroupMessage(
        senderId: 'me',
        senderName: 'Me',
        text: text,
        time: 'Just now',
        type: _MsgType.sent,
        color: const Color(0xFF414755),
        nameColor: const Color(0xFF414755),
        bubbleColor: const Color(0xFFE5E2E1),
        textColor: const Color(0xFF1C1B1B),
      ));
      _inputController.clear();
      _isTyping = false;
    });
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
              itemCount: _messages.length + 1,
              itemBuilder: (ctx, i) {
                if (i == 0) return _buildDatePill();
                return Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: _buildMessage(_messages[i - 1]),
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFCF9F8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF0058BC),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Cinque Terre Group',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0058BC),
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    '4 members • Active now',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      color: Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ),

            // Overlapping avatars
            GestureDetector(
              onTap: () => context.go('/groups/${widget.groupId}/members'),
              child: SizedBox(
                width: 100,
                height: 36,
                child: Stack(
                  children: [
                    _MiniAvatar(
                      offset: 0,
                      color: const Color(0xFFD8E2FF),
                    ),
                    _MiniAvatar(
                      offset: 22,
                      color: const Color(0xFFFFDCBF),
                    ),
                    _MiniAvatar(
                      offset: 44,
                      color: const Color(0xFFE4E2E2),
                    ),
                    Positioned(
                      left: 66,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8E2FF),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFFFCF9F8),
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '+1',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF001A41),
                            ),
                          ),
                        ),
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

  Widget _buildDatePill() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEBE7E7),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Text(
            'Today',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Color(0xFF414755),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessage(_GroupMessage msg) {
    if (msg.type == _MsgType.sent) {
      return _buildSentMessage(msg);
    }
    return _buildReceivedMessage(msg);
  }

  Widget _buildReceivedMessage(_GroupMessage msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: msg.bubbleColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: msg.color.withOpacity(0.2)),
          ),
          child: Icon(Icons.person, size: 22, color: msg.color),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sender name
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  msg.senderName,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: msg.nameColor,
                  ),
                ),
              ),
              // Bubble
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: msg.bubbleColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  border: msg.hasBorder
                      ? Border.all(
                          color: const Color(0xFFC1C6D7).withOpacity(0.3))
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  msg.text,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    color: msg.textColor,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Text(
                  msg.time,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    color: Color(0xFF414755),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSentMessage(_GroupMessage msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                color: msg.bubbleColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (msg.hasImage)
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(4),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 160,
                        color: const Color(0xFFD8E2FF),
                        child: const Icon(Icons.landscape,
                            size: 48, color: Color(0xFF0058BC)),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Text(
                      msg.text,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15,
                        color: msg.textColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  msg.time,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    color: Color(0xFF414755),
                  ),
                ),
                if (msg.isRead) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all,
                      size: 12, color: Color(0xFF0058BC)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        border: Border(
          top: BorderSide(color: const Color(0xFFC1C6D7).withOpacity(0.2)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Add button
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFEBE7E7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Color(0xFF0058BC), size: 22),
          ),
          const SizedBox(width: 10),

          // Input field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFC1C6D7)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      maxLines: null,
                      onChanged: (v) =>
                          setState(() => _isTyping = v.isNotEmpty),
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15,
                        color: Color(0xFF1C1B1B),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          color: Color(0xFF717786),
                        ),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                    ),
                  ),
                  // Send inside field
                  Padding(
                    padding: const EdgeInsets.only(right: 8, bottom: 8),
                    child: GestureDetector(
                      onTap: _sendMessage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _isTyping
                              ? const Color(0xFF0058BC)
                              : const Color(0xFF0058BC).withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send,
                            color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Group Message Model ───────────────────────────────────────

enum _MsgType { sent, received }

class _GroupMessage {
  final String senderId;
  final String senderName;
  final String text;
  final String time;
  final _MsgType type;
  final bool hasImage;
  final bool isRead;
  final bool hasBorder;
  final Color color;
  final Color nameColor;
  final Color bubbleColor;
  final Color textColor;

  const _GroupMessage({
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.time,
    required this.type,
    required this.color,
    required this.nameColor,
    required this.bubbleColor,
    required this.textColor,
    this.hasImage = false,
    this.isRead = false,
    this.hasBorder = false,
  });
}

// ── Mini Avatar ───────────────────────────────────────────────

class _MiniAvatar extends StatelessWidget {
  final double offset;
  final Color color;

  const _MiniAvatar({required this.offset, required this.color});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFCF9F8), width: 2),
        ),
        child: const Icon(Icons.person, size: 16, color: Colors.white70),
      ),
    );
  }
}
