import 'dart:async';
import 'package:flutter/material.dart';

class DirectChatScreen extends StatefulWidget {
  final String chatId;
  const DirectChatScreen({super.key, required this.chatId});

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _otherTyping = true; // simulated

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      text:
          "Hey! I'm planning my route through Amalfi tomorrow. Are you still thinking of heading to Positano? 🍋",
      isMe: false,
      time: '10:42 AM',
    ),
    _ChatMessage(
      text:
          "Definitely! I just booked a tiny boat for a sunset tour. You should join!",
      isMe: true,
      time: '10:45 AM',
    ),
    _ChatMessage(
      text: "Look at this view! We can leave around 5 PM.",
      isMe: true,
      time: '10:46 AM',
      hasImage: true,
      isRead: true,
    ),
  ];

  late AnimationController _dot1Controller;
  late AnimationController _dot2Controller;
  late AnimationController _dot3Controller;

  @override
  void initState() {
    super.initState();

    _dot1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _dot2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _dot2Controller.repeat(reverse: true);
    });

    _dot3Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _dot3Controller.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _dot1Controller.dispose();
    _dot2Controller.dispose();
    _dot3Controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(
        text: text,
        isMe: true,
        time: 'Just now',
      ));
      _inputController.clear();
    });

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
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
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              itemCount: _messages.length + 2, // +date pill +typing
              itemBuilder: (context, i) {
                if (i == 0) return _buildDatePill();
                if (i == _messages.length + 1) {
                  return _otherTyping
                      ? _buildTypingIndicator()
                      : const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: _buildBubble(_messages[i - 1]),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
            // Back
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Icon(Icons.arrow_back,
                    color: Color(0xFF414755), size: 22),
              ),
            ),
            const SizedBox(width: 8),

            // Avatar + online dot
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFD8E2FF),
                    border:
                        Border.all(color: const Color(0xFF0070EB), width: 2),
                  ),
                  child: const ClipOval(
                    child:
                        Icon(Icons.person, size: 24, color: Color(0xFF0058BC)),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFF22C55E),
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: const Color(0xFFFCF9F8), width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // Name + status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Elena Rossi',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1B1B),
                      height: 1,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Active now',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      color: Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ),

            // Action icons
            _HeaderIconBtn(icon: Icons.videocam_outlined, onTap: () {}),
            _HeaderIconBtn(icon: Icons.call_outlined, onTap: () {}),
            _HeaderIconBtn(icon: Icons.more_vert, onTap: () {}),
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
            color: const Color(0xFFF0EDEC),
            borderRadius: BorderRadius.circular(99),
          ),
          child: const Text(
            'TODAY',
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

  Widget _buildBubble(_ChatMessage msg) {
    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
          crossAxisAlignment:
              msg.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Image if present
            if (msg.hasImage)
              Container(
                margin: const EdgeInsets.only(bottom: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF0058BC), width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 240,
                    height: 160,
                    color: const Color(0xFFF0EDEC),
                    child: const Icon(Icons.image,
                        size: 48, color: Color(0xFF0058BC)),
                  ),
                ),
              ),

            // Text bubble
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: msg.isMe
                    ? const Color(0xFF0058BC)
                    : const Color(0xFFE5E2E1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: msg.isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(4),
                  bottomRight: msg.isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(msg.isMe ? 0.12 : 0.04),
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
                  color: msg.isMe ? Colors.white : const Color(0xFF1C1B1B),
                  height: 1.4,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Time + read receipt
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
                if (msg.isMe && msg.isRead) ...[
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

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE5E2E1),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BouncingDot(controller: _dot1Controller),
              const SizedBox(width: 4),
              _BouncingDot(controller: _dot2Controller),
              const SizedBox(width: 4),
              _BouncingDot(controller: _dot3Controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Add button
          GestureDetector(
            onTap: () {},
            child: const Icon(Icons.add_circle_outline,
                color: Color(0xFF0058BC), size: 28),
          ),
          const SizedBox(width: 10),

          // Text field
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F3F2),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
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
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {},
                      child: const Icon(Icons.camera_alt_outlined,
                          color: Color(0xFF414755), size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isTyping
                    ? const Color(0xFF8C5000)
                    : const Color(0xFF8C5000).withOpacity(0.5),
                shape: BoxShape.circle,
                boxShadow: _isTyping
                    ? [
                        BoxShadow(
                          color: const Color(0xFF8C5000).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat Message Model ────────────────────────────────────────

class _ChatMessage {
  final String text;
  final bool isMe;
  final String time;
  final bool hasImage;
  final bool isRead;

  const _ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
    this.hasImage = false,
    this.isRead = false,
  });
}

// ── Bouncing Dot ──────────────────────────────────────────────

class _BouncingDot extends StatelessWidget {
  final AnimationController controller;

  const _BouncingDot({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -4 * controller.value),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF414755),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

// ── Header Icon Button ────────────────────────────────────────

class _HeaderIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
        ),
        child: Icon(icon, color: const Color(0xFF0058BC), size: 22),
      ),
    );
  }
}
