import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────────────────────
class _Adventure {
  const _Adventure({
    required this.title,
    required this.imageUrl,
    this.subtitle,
  });
  final String title;
  final String imageUrl;
  final String? subtitle;
}

// ─────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────
class TravelerProfileScreen extends StatefulWidget {
  const TravelerProfileScreen({super.key, required this.userId});
  final String userId;

  @override
  State<TravelerProfileScreen> createState() => _TravelerProfileScreenState();
}

class _TravelerProfileScreenState extends State<TravelerProfileScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  bool _headerElevated = false;

  // Fake data — replaced by Firestore read in logic phase
  static const _heroImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDKhRF39qw849I5cxj485ncFeA5zrSgS928XPvMWEMTZPYYW5ZvQD2aJaOdNoIqNUEq1ePazHyTZSv8ozxWXGbx8gGWysoVMdW1eqIK7o5I-1wgP_N_Hh9irneOOyI3t1p_L167Wm5igraWK_YxgeFGibkaSQq_n3u-ulbRRGsAEUdPYV-Cy-EFGLWHajssA6tFX79l3YKHiO9jtZi3PyKU1MbWmkcoHqHMjNqt90CH263h0zedquzj-QqrG8aj2kaVSXD1Ce7_WU9C';
  static const _avatarImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDY7omi6LjcosYBi5Zii6frPQjH3VfF8d-55bO7_ismtvoQozkxOio56dQ7rBBO5skdNKb9sFMTmotHpLXxeh22MU83dDwKMXvlefvWQX0wI7hMO9iuIVOyugvNEZIXTgPnBazrh1KPE_Cdp-7U6F0iccVCzXbOBWyXat-yNfAyBGhKjDdKN0UhJVcObFN3pMO2kcmGkC5ua9XIttIjAlgdnhvvTWvnMBFQ_a1B9XNg0rw3-fgZpGz6te7PQaQH5hLdhMRFod8PosW8';
  static const _userAvatarImage =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAkZEPx-qggHP7T8TcNGYR_ogzOZd3pnnp6TTySys6-OIc0CGgPnoseov520I7AFgxIIIDNTDZFnSWHJncXkpInxj658AiJYX16D9nb6BIZE5cj-49MfosOq_W2mRMt_o2UvqD0JybfWDftHwsH0PmedL3mJ2NPTK7tPlq_s02DkXoqN_q6G-VjbeCTRc5qOF9xX7WOxtrMlno0XWCo0Z443ycf47FF8jRAAelxtq6s-q5213OnnzHpYCAZnBw4DYHqC7pNhoJHjIHw';

  static const _adventures = [
    _Adventure(
      title: 'Santorini Escape',
      subtitle: 'July 2023',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBPEtU4jPMwTclLOXJXGFWvYuf-0u3jJ5aUN2oL1vxpKF1L18onnaUThRONZMx3LVPF5vTJLfbQM0gMU3H4PZcDI-hfrIaNtxgkZw8JZ4xFCtHZBqZ1R2q39vUBZ8LKVdNfGP-VPqvUJwLGXYN17r9CHA5-arvkGMXoZKN1Z3oAEWDaK47i4z7SF-EU1uOIOGg_xwzSvMz8-qGY6-7qBJrN5Rxlik5YS1waHLRwexhOq8jHPPEWLxgDR6Q0XQiJ7N6bzg2qJv7ly7d7',
    ),
    _Adventure(
      title: 'Venice Hidden Gems',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAU3YlTD72fyt40UsfqXv0pQB7ueptDNRc4p8JoMZKxztbKJTJ_T3x6WXViIkGiqwo9e9e5C6D0IQPglU7J6ho2wjFGhIcIzhymyMTl7xdi_Wo2ZgYc9VcmwkonsHTCcoh3QERhFFwBAoKvfJDdXkOxGQm1DFkrlK_-RLH8bU3gfH68u6sWl0bFm5r9roiSsRT9Ierr0aMc2Z5KnUqI8fWXKgYXog44PnetcDHw0RJq7qUqn3B18eLrCv5Us2NOygbA8oCIGi5nv5B5',
    ),
    _Adventure(
      title: 'Taste of Amalfi',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDIvTKfFHxGBIa0RjtBJmyeH6iV1vqXv2UyrEs6CFoDTLfj2BaSSszJaflQ7Gcly1agxrXJEgHOHHgr2k_fTf6WEvrWCQ4vssaeQv10-JBmKBp0GASrdPzAKSuz6cf2sHyC01Ow4bI1XPYNe1q6BWitlYwePRd_SG83y1Jlc_IpdIInjZzYt5okcVorFzewvNc2oByMCDDoaIJ9mkRxSCRtzAriXOpHFDiuY1f9WOkZvxGk6-B3JuRzSCl-gBodGLvmG19UQ9kGXiMj',
    ),
  ];

  static const _interests = [
    'Hiking',
    'Photography',
    'Foodie',
    'Sailing',
  ];

  bool _messageSent = false;
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      final elevated = _scrollCtrl.offset > 50;
      if (elevated != _headerElevated) {
        setState(() => _headerElevated = elevated);
      }
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCF9F8),
        body: Column(
          children: [
            // ── Top bar ─────────────────────────────────
            _TopBar(
              elevated: _headerElevated,
              userAvatarUrl: _userAvatarImage,
            ),

            // ── Scrollable content ───────────────────────
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollCtrl,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero section with cover + profile info
                    _HeroSection(
                      heroImage: _heroImage,
                      avatarImage: _avatarImage,
                      connected: _connected,
                      onMessage: () {
                        setState(() => _messageSent = true);
                        // TODO: navigate to chat
                        context.push('/chat/fake-chat-id');
                      },
                      onConnect: () => setState(() => _connected = true),
                    ),

                    // Stats + About + Gallery
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats row
                          _StatsCard(),
                          const SizedBox(height: 24),

                          // About section
                          _AboutSection(interests: _interests),
                          const SizedBox(height: 24),

                          // Recent adventures
                          _AdventuresSection(adventures: _adventures),
                        ],
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
}

// ─────────────────────────────────────────────────────────────
//  Top Bar
// ─────────────────────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar({required this.elevated, required this.userAvatarUrl});
  final bool elevated;
  final String userAvatarUrl;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: const Color(0xFFFCF9F8),
      padding: EdgeInsets.fromLTRB(8, top, 16, 0),
      height: top + 56,
      decoration: BoxDecoration(
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon:
                    const Icon(Icons.menu, color: Color(0xFF0058BC), size: 24),
                onPressed: () {},
              ),
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
            ],
          ),
          ClipOval(
            child: Image.network(
              userAvatarUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: 40,
                height: 40,
                color: const Color(0xFF0070EB),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Hero Section — cover image + avatar overlay + action buttons
// ─────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.heroImage,
    required this.avatarImage,
    required this.connected,
    required this.onMessage,
    required this.onConnect,
  });
  final String heroImage;
  final String avatarImage;
  final bool connected;
  final VoidCallback onMessage;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 397,
      child: Stack(
        children: [
          // Cover image
          Positioned.fill(
            child: Image.network(
              heroImage,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                color: const Color(0xFFEBE7E7),
                child: const Icon(Icons.landscape_outlined,
                    size: 80, color: Color(0xFF717786)),
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFFCF9F8).withOpacity(0.9),
                    const Color(0xFFFCF9F8),
                  ],
                  stops: const [0.3, 0.75, 1.0],
                ),
              ),
            ),
          ),

          // Profile info at bottom
          Positioned(
            bottom: 0,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border:
                        Border.all(color: const Color(0xFFFCF9F8), width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      avatarImage,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        color: const Color(0xFFEBE7E7),
                        child: const Icon(Icons.person,
                            size: 40, color: Color(0xFF717786)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Name + badge
                Row(
                  children: [
                    const Text(
                      'Alex Wanderer',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.52,
                        color: Color(0xFF1C1B1B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE9400),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified,
                              size: 14, color: Color(0xFF633700)),
                          SizedBox(width: 4),
                          Text(
                            'Pro Explorer',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: Color(0xFF633700),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Location
                const Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 16, color: Color(0xFF414755)),
                    SizedBox(width: 4),
                    Text(
                      'Based in Palma, Mallorca',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        color: Color(0xFF414755),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Action buttons
                Row(
                  children: [
                    _HeroButton(
                      label: 'Send Message',
                      icon: Icons.send_outlined,
                      backgroundColor: const Color(0xFF0058BC),
                      textColor: Colors.white,
                      onTap: onMessage,
                    ),
                    const SizedBox(width: 10),
                    _HeroButton(
                      label: connected ? 'Connected' : 'Connect',
                      icon: connected
                          ? Icons.check_circle_outline
                          : Icons.person_add_outlined,
                      backgroundColor: connected
                          ? const Color(0xFFEBE7E7)
                          : const Color(0xFFFE9400),
                      textColor: connected
                          ? const Color(0xFF414755)
                          : const Color(0xFF633700),
                      onTap: connected ? null : onConnect,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatefulWidget {
  const _HeroButton({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback? onTap;

  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:
          widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap!();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: widget.backgroundColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.textColor, size: 18),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Stats Card
// ─────────────────────────────────────────────────────────────
class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFC1C6D7).withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(value: '128', label: 'Trips'),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFC1C6D7).withOpacity(0.4),
          ),
          _StatItem(value: '42', label: 'Countries'),
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFC1C6D7).withOpacity(0.4),
          ),
          _StatItem(value: '15', label: 'Tribes'),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0058BC),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
            color: Color(0xFF414755),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  About Section
// ─────────────────────────────────────────────────────────────
class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.interests});
  final List<String> interests;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFE5E2E1).withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About Me',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "I'm a storyteller and nomad at heart, with a deep passion for Mediterranean hidden gems. Whether it's finding the perfect secluded cove in Menorca or sharing a meal with locals in a Sicilian village, I believe travel is about the people you meet and the stories you bring home. Always looking for new wanderers to join my next adventure!",
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 15,
              color: Color(0xFF414755),
              height: 1.6,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests
                .map(
                  (i) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD8E2FF),
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      i,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: Color(0xFF004493),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Adventures Section — bento grid gallery
// ─────────────────────────────────────────────────────────────
class _AdventuresSection extends StatelessWidget {
  const _AdventuresSection({required this.adventures});
  final List<_Adventure> adventures;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Adventures',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1B1B),
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: const Row(
                children: [
                  Text(
                    'View All',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0058BC),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 18, color: Color(0xFF0058BC)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Bento grid: large left card + 2 small right cards
        SizedBox(
          height: 340,
          child: Row(
            children: [
              // Large card — Santorini
              Expanded(
                flex: 2,
                child: _GalleryCard(
                  adventure: adventures[0],
                  borderRadius: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Two small cards stacked
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Expanded(
                      child: _GalleryCard(
                        adventure: adventures[1],
                        borderRadius: 20,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _GalleryCard(
                        adventure: adventures[2],
                        borderRadius: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GalleryCard extends StatefulWidget {
  const _GalleryCard({
    required this.adventure,
    required this.borderRadius,
  });
  final _Adventure adventure;
  final double borderRadius;

  @override
  State<_GalleryCard> createState() => _GalleryCardState();
}

class _GalleryCardState extends State<_GalleryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) => setState(() => _hovered = false),
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovered ? 0.15 : 0.08),
              blurRadius: _hovered ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Image
              Image.network(
                widget.adventure.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  color: const Color(0xFFEBE7E7),
                  child: const Icon(Icons.landscape_outlined,
                      size: 32, color: Color(0xFF717786)),
                ),
              ),

              // Hover gradient overlay
              AnimatedOpacity(
                opacity: _hovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Color(0x99000000),
                      ],
                    ),
                  ),
                ),
              ),

              // Title overlay at bottom (always visible)
              Positioned(
                bottom: 10,
                left: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.adventure.title,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Color(0x88000000),
                          ),
                        ],
                      ),
                    ),
                    if (widget.adventure.subtitle != null)
                      Text(
                        widget.adventure.subtitle!,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          color: Colors.white70,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Color(0x88000000),
                            ),
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
    );
  }
}
