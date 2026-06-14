/*import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen> {
  int _activeFilter = 0;

  final List<Map<String, dynamic>> _filters = [
    {'icon': Icons.location_on, 'label': 'Destination'},
    {'icon': Icons.calendar_today, 'label': 'Dates'},
    {'icon': Icons.group, 'label': 'Group Size'},
    {'icon': Icons.tune, 'label': 'Filter'},
  ];

  final List<Map<String, dynamic>> _trendingSmall = [
    {'label': 'Santorini'},
    {'label': 'Ibiza'},
  ];

  final List<Map<String, dynamic>> _feedCards = [
    {
      'name': 'Sarah Mitchell',
      'subtitle': 'Solo Traveler • 12 trips',
      'score': 98,
      'title': 'Cinque Terre Coastal Hike',
      'dates': 'Oct 12 - Oct 18',
      'spots': '4 spots left',
      'price': '\$1,240',
      'tags': ['Hiking', 'Photography'],
    },
    {
      'name': 'Marco Rossi',
      'subtitle': 'Local Guide • 45 trips',
      'score': 94,
      'title': 'Venetian Hidden Gems',
      'dates': 'Nov 02 - Nov 05',
      'spots': '2 spots left',
      'price': '\$850',
      'tags': ['History', 'Foodie'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Top nav
              SliverToBoxAdapter(child: _buildTopNav(context)),

              // Filter chips
              SliverToBoxAdapter(child: _buildFilterChips()),

              // Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Trending Journeys
                      const Text(
                        'Trending Journeys',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.64,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildBentoGrid(),
                      const SizedBox(height: 40),

                      // Planned with Wegoo
                      const Text(
                        'Planned with Wegoo',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.64,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ..._feedCards.map((card) => Padding(
                            padding: const EdgeInsets.only(bottom: 24),
                            child: _TravelCard(data: card),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // FAB
          Positioned(
            bottom: 100,
            right: 20,
            child: _FabButton(onTap: () => context.go('/trip/new/destination')),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav(BuildContext context) {
    return Container(
      height: 72,
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
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Avatar
            GestureDetector(
              onTap: () => context.go('/profile'),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF0070EB),
                    width: 2,
                  ),
                  color: const Color(0xFFD8E2FF),
                ),
                child: const ClipOval(
                  child: Icon(Icons.person, size: 28, color: Color(0xFF0058BC)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Logo
            const Text(
              'Wegoo',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 32,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.64,
                color: Color(0xFF0058BC),
              ),
            ),
            const Spacer(),
            // Search
            _IconBtn(icon: Icons.search, onTap: () {}),
            const SizedBox(width: 8),
            // Notifications
            _IconBtn(icon: Icons.notifications_outlined, onTap: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: const Color(0xFFFCF9F8),
      padding: const EdgeInsets.fromLTRB(20, 16, 0, 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_filters.length, (i) {
            final isActive = i == _activeFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => setState(() => _activeFilter = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF0058BC)
                        : const Color(0xFFEBE7E7),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _filters[i]['icon'] as IconData,
                        size: 18,
                        color:
                            isActive ? Colors.white : const Color(0xFF414755),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _filters[i]['label'] as String,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color:
                              isActive ? Colors.white : const Color(0xFF414755),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBentoGrid() {
    return Column(
      children: [
        // Large card
        _BentoCard(
          height: 260,
          borderRadius: 24,
          label: 'Mediterranean Dream',
          title: 'Amalfi Coast, Italy',
          showRating: true,
          rating: '4.9',
        ),
        const SizedBox(height: 12),
        // Two small cards
        Row(
          children: [
            Expanded(
              child: _BentoCard(
                height: 160,
                borderRadius: 24,
                title: 'Santorini',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _BentoCard(
                height: 160,
                borderRadius: 24,
                title: 'Ibiza',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Bento Card ───────────────────────────────────────────────

class _BentoCard extends StatefulWidget {
  final double height;
  final double borderRadius;
  final String? label;
  final String title;
  final bool showRating;
  final String? rating;

  const _BentoCard({
    required this.height,
    required this.borderRadius,
    this.label,
    required this.title,
    this.showRating = false,
    this.rating,
  });

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: const Color(0xFFF0EDEC),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder gradient background
              AnimatedScale(
                scale: _hovered ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 400),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0058BC).withOpacity(0.3),
                        const Color(0xFFFE9400).withOpacity(0.4),
                      ],
                    ),
                  ),
                  child: const Icon(Icons.travel_explore,
                      size: 48, color: Colors.white54),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xB3000000),
                      Colors.transparent,
                    ],
                    stops: [0, 0.6],
                  ),
                ),
              ),
              // Content
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.label != null) ...[
                            Text(
                              widget.label!.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: widget.label != null ? 24 : 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.showRating && widget.rating != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFE9400),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                size: 16, color: Color(0xFF633700)),
                            const SizedBox(width: 4),
                            Text(
                              widget.rating!,
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF633700),
                              ),
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

// ── Travel Card ──────────────────────────────────────────────

class _TravelCard extends StatefulWidget {
  final Map<String, dynamic> data;
  const _TravelCard({required this.data});

  @override
  State<_TravelCard> createState() => _TravelCardState();
}

class _TravelCardState extends State<_TravelCard> {
  bool _joinPressed = false;

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0EDEC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFFDCBF),
                  ),
                  child: const Icon(Icons.person,
                      color: Color(0xFF8C5000), size: 28),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d['name'] as String,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C1B1B),
                      ),
                    ),
                    Text(
                      d['subtitle'] as String,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13,
                        color: Color(0xFF414755),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.more_vert, color: Color(0xFF0058BC), size: 26),
              ],
            ),
          ),

          // Image with score badge
          Stack(
            children: [
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EDEC),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF0058BC).withOpacity(0.2),
                      const Color(0xFFFE9400).withOpacity(0.3),
                    ],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.landscape, size: 56, color: Colors.white60),
                ),
              ),
              // Score badge
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(99),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bolt,
                          size: 18, color: Color(0xFF8C5000)),
                      const SizedBox(width: 4),
                      Text(
                        'Score ${d['score']}',
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Card content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d['title'] as String,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.44,
                              color: Color(0xFF1C1B1B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${d['dates']} • ${d['spots']}',
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 15,
                              color: Color(0xFF414755),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      d['price'] as String,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0058BC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 8,
                  children: (d['tags'] as List<String>).map((tag) {
                    final isFirst =
                        (d['tags'] as List<String>).indexOf(tag) == 0;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: isFirst
                            ? const Color(0xFFD8E2FF)
                            : const Color(0xFFFFDCBF),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        tag,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: isFirst
                              ? const Color(0xFF001A41)
                              : const Color(0xFF6A3B00),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTapDown: (_) => setState(() => _joinPressed = true),
                        onTapUp: (_) => setState(() => _joinPressed = false),
                        onTapCancel: () => setState(() => _joinPressed = false),
                        child: AnimatedScale(
                          scale: _joinPressed ? 0.97 : 1.0,
                          duration: const Duration(milliseconds: 150),
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0058BC),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Center(
                              child: Text(
                                'Join Group',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8C5000),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.chat_bubble_outline,
                            color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFFFE9400),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE9400).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Color(0xFF633700), size: 32),
        ),
      ),
    );
  }
}

// ── Icon Button ──────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          color: Colors.transparent,
        ),
        child: Icon(icon, color: const Color(0xFF0058BC), size: 26),
      ),
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:wegoo/features/home/widgets/travel_match_overlay.dart';

// ─────────────────────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────────────────────
class _TravelerCard {
  const _TravelerCard({
    required this.name,
    required this.age,
    required this.location,
    required this.photoUrl,
    required this.travelStyle,
    required this.budget,
    required this.date,
    this.university,
    this.isVerified = false,
  });
  final String name;
  final int age;
  final String location;
  final String photoUrl;
  final String travelStyle;
  final String budget;
  final String date;
  final String? university;
  final bool isVerified;
}

// ─────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────
class DiscoveryFeedScreen extends StatefulWidget {
  const DiscoveryFeedScreen({super.key});

  @override
  State<DiscoveryFeedScreen> createState() => _DiscoveryFeedScreenState();
}

class _DiscoveryFeedScreenState extends State<DiscoveryFeedScreen>
    with SingleTickerProviderStateMixin {
  // Fake cards — replaced by Firestore stream in logic phase
  final List<_TravelerCard> _cards = const [
    _TravelerCard(
      name: 'Alex',
      age: 24,
      location: 'Tozeur, Tunisia',
      photoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC75Go7xPFN5gf31gOMM6WsSpL9LMD16C2cQmQlf2XH0Px3jpNtxap6v2211mtOCJ1bA65XYcYTwxi2tC-Qyb3_jWP0xVkDYOgoHeAtgp2AvxWIBGK1FbM2jpSgGa1tzsEyjpTVgtHqAFG3mKcAhxmnwSsmONqux3j7FoekdQY5RPS_EinwyDqZQm4irSRCuqIE2etkjPiB0J6bv8nKTloWhfvJWqKhCK1b2LoNqvpS9cCFsV5t5tpnVkml25edRjem9fJmq3aztBai',
      travelStyle: 'Adventure',
      budget: 'Medium',
      date: 'July 15',
      university: 'University of Tunis',
      isVerified: true,
    ),
    _TravelerCard(
      name: 'Sara',
      age: 22,
      location: 'Djerba, Tunisia',
      photoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDWuxx-c4vARyJ4ZHdzGt0MdaiBWNKOqoSyQKDUKQdP3Of4wnePndAr7oAhO64Bg8FRXAHMiaAvXNXH90-3QgFlwco8eZd_a78yTwsdF8ZBO1hA3uU0qFrW_g_5EiFHQTt0qcdozNlTEIhYLXhkYoAZsDtSKldYFSZi1kqQTYXeV7aajCj5ACJSIxgFCio8tABxQkdJo9uZnY3KJTvvP40cKVGoFTf387H7nzthK8QJhXvrxoFzSyb-7j3vgAZ8_9ClTemH9CQl1jET',
      travelStyle: 'Chill',
      budget: 'Budget',
      date: 'Aug 3',
      isVerified: true,
    ),
    _TravelerCard(
      name: 'Karim',
      age: 26,
      location: 'Hammamet, Tunisia',
      photoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCzsG0_a6WzPNAFeRGurgSoWqJiP_7gNybp-HQ49VEXnDBPXnLWH6PnpRBSjgoJCXA4UdI4mD7kRvG4lChSH0SvQlTyEWg_XSlDmGJpAV9aXxhmOdr0qZ1qPy0eBw20RU1gt0A67LxIa_Cu_Uj0PazXHQZjU4shZVGNeQ6b0FnWuBq3FlbIiWDkeuTXCQei5I-lHVI6rnIqzaJQSz90vwzdI1zJEWH24m8G82Le9wLtdhPU1oMaXBF7R-eHkIfJlEaU_C2ef9KuLLym',
      travelStyle: 'Explorer',
      budget: 'Luxury',
      date: 'Sept 10',
    ),
  ];

  int _currentIndex = 0;
  String _activeFilter = 'FILTERS';

  // Swipe animation
  late AnimationController _swipeCtrl;
  late Animation<Offset> _swipeAnim;
  late Animation<double> _rotateAnim;
  bool _isSwiping = false;

  // Drag state
  Offset _dragOffset = Offset.zero;
  bool _isDragging = false;

  static const _filters = [
    'FILTERS',
    'NEAR ME',
    'SOLO ONLY',
    'NEXT 30 DAYS',
  ];

  @override
  void initState() {
    super.initState();
    _swipeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _swipeAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _swipeCtrl,
      curve: Curves.easeOut,
    ));
    _rotateAnim = Tween<double>(begin: 0, end: 0).animate(_swipeCtrl);
  }

  @override
  void dispose() {
    _swipeCtrl.dispose();
    super.dispose();
  }

  void _swipe(String direction) {
    if (_isSwiping || _currentIndex >= _cards.length) return;
    _isSwiping = true;

    final dx = direction == 'left' ? -1.5 : 1.5;
    final rot = direction == 'left' ? -0.35 : 0.35;

    _swipeAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(dx, -0.2),
    ).animate(CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeOut));

    _rotateAnim = Tween<double>(begin: 0, end: rot)
        .animate(CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeOut));

    _swipeCtrl.forward().then((_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _cards.length;
        _isSwiping = false;
        _dragOffset = Offset.zero;
      });
      _swipeCtrl.reset();
      _swipeAnim = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
          .animate(_swipeCtrl);
      _rotateAnim = Tween<double>(begin: 0, end: 0).animate(_swipeCtrl);
    });
  }

  void _onDragStart(DragStartDetails d) {
    if (_isSwiping) return;
    setState(() => _isDragging = true);
  }

  void _onDragUpdate(DragUpdateDetails d) {
    if (_isSwiping) return;
    setState(() => _dragOffset += d.delta);
  }

  void _onDragEnd(DragEndDetails d) {
    if (_isSwiping) return;
    setState(() => _isDragging = false);
    if (_dragOffset.dx.abs() > 100) {
      _swipe(_dragOffset.dx > 0 ? 'right' : 'left');
    } else {
      setState(() => _dragOffset = Offset.zero);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFCF9F8),
        body: Column(
          children: [
            // ── Top bar ─────────────────────────────────
            _TopBar(
              onNotifications: () => context.go('/notifications'),
            ),

            // ── Content ──────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'Find Your Crew',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Swipe to connect with fellow travelers heading your way.',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          color: Color(0xFF414755),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Swipe deck
                      _SwipeDeck(
                        cards: _cards,
                        currentIndex: _currentIndex,
                        dragOffset: _dragOffset,
                        isDragging: _isDragging,
                        swipeAnim: _swipeAnim,
                        rotateAnim: _rotateAnim,
                        isSwiping: _isSwiping,
                        onDragStart: _onDragStart,
                        onDragUpdate: _onDragUpdate,
                        onDragEnd: _onDragEnd,
                        onCardTap: () => context.push('/user/fake-uid'),
                      ),
                      const SizedBox(height: 20),

                      // Action buttons
                      _ActionButtons(
                        onPass: () => _swipe('left'),
                        onSuperLike: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('⭐ Super Like envoyé !'),
                              backgroundColor: Color(0xFF8C5000),
                              duration: Duration(seconds: 1),
                            ),
                          );
                        },
                        onConnect: () => _swipe('right'),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => TravelMatchOverlay(
                              myPhotoUrl: 'https://...ton_photo...',
                              matchName: 'Sarah',
                              matchPhotoUrl: 'https://...photo_sarah...',
                              destination: 'Sidi Bou Said',
                              onMessage: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                context.push('/chat/fake-chat-id');
                              },
                              onKeepSwiping: () => Navigator.pop(context),
                            ),
                          );
                        },
                        child: const Text('Test Match Overlay'),
                      ),
                      const SizedBox(height: 16),

                      // Filters
                      _FilterChips(
                        filters: _filters,
                        active: _activeFilter,
                        onSelect: (f) => setState(() => _activeFilter = f),
                      ),
                    ],
                  ),
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
  const _TopBar({required this.onNotifications}); // ← ajoute ça
  final VoidCallback onNotifications; // ← et ça
  static const _profileUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCMk32IqT8Yccm82VDLhvTlHnnstgcmRKl7AtwIg5ZZkXZaoh698ziijHj28YbJdhWwkwMpFb4IVexxHfHZK2nOFp0tZdAVHnp7ST-NFV5ChBflz-Mn7D_iJJJqEEYX8IiijpuFMTv8kw60SHdbPWBAcqKQ-ZOwXunjwSJM-KFTUhkcjhpJBXzUXi74WIG8QaaPxi4CraaXMSnF4uUjj3pygRVGami6Ncp6Of2aSCJFn2S2C_knPJO2eVHvdcmNwvo3NxDS6WJ5RmRr';

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.fromLTRB(20, top + 8, 20, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.network(
                  _profileUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFFADC6FF),
                      shape: BoxShape.circle,
                    ),
                    child:
                        const Icon(Icons.person, color: Colors.white, size: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.people_outline,
                    color: Color(0xFF414755), size: 28),
                onPressed: () => context.push('/connections/requests'),
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Color(0xFF414755), size: 28),
                onPressed: onNotifications,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Swipe Deck
// ─────────────────────────────────────────────────────────────
class _SwipeDeck extends StatelessWidget {
  const _SwipeDeck({
    required this.cards,
    required this.currentIndex,
    required this.dragOffset,
    required this.isDragging,
    required this.swipeAnim,
    required this.rotateAnim,
    required this.isSwiping,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
    required this.onCardTap,
  });

  final List<_TravelerCard> cards;
  final int currentIndex;
  final Offset dragOffset;
  final bool isDragging;
  final Animation<Offset> swipeAnim;
  final Animation<double> rotateAnim;
  final bool isSwiping;
  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragUpdate;
  final GestureDragEndCallback onDragEnd;
  final VoidCallback onCardTap;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width - 40;
    final cardH = screenW * (4 / 3);

    return SizedBox(
      width: screenW,
      height: cardH,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background stack card
          Positioned.fill(
            child: Transform.rotate(
              angle: 0.017,
              child: Transform.scale(
                scale: 0.98,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFEBE7E7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),

          // Main swipeable card
          AnimatedBuilder(
            animation: Listenable.merge([swipeAnim, rotateAnim]),
            builder: (context, child) {
              final offset = isSwiping ? swipeAnim.value * screenW : dragOffset;
              final rotate = isSwiping
                  ? rotateAnim.value
                  : (dragOffset.dx / screenW) * 0.3;

              return Transform.translate(
                offset: offset,
                child: Transform.rotate(
                  angle: rotate,
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: onCardTap,
              onHorizontalDragStart: onDragStart,
              onHorizontalDragUpdate: onDragUpdate,
              onHorizontalDragEnd: onDragEnd,
              child: _TravelerSwipeCard(
                card: cards[currentIndex],
                dragOffset: dragOffset,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Traveler Swipe Card
// ─────────────────────────────────────────────────────────────
class _TravelerSwipeCard extends StatelessWidget {
  const _TravelerSwipeCard({
    required this.card,
    required this.dragOffset,
  });
  final _TravelerCard card;
  final Offset dragOffset;

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width - 40;
    final cardH = screenW * (4 / 3);
    final swipeRatio = (dragOffset.dx / screenW).clamp(-1.0, 1.0);

    return Container(
      width: screenW,
      height: cardH,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Photo
            Image.network(
              card.photoUrl,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                color: const Color(0xFFEBE7E7),
                child: const Icon(Icons.person,
                    size: 80, color: Color(0xFF717786)),
              ),
            ),

            // Gradient overlay
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x33000000),
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.0, 0.4, 1.0],
                ),
              ),
            ),

            // Swipe indicator overlays
            if (swipeRatio > 0.1)
              Positioned(
                top: 40,
                left: 20,
                child: AnimatedOpacity(
                  opacity: swipeRatio.clamp(0.0, 1.0),
                  duration: Duration.zero,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0058BC).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: const Color(0xFF0058BC), width: 2),
                    ),
                    child: const Text(
                      'CONNECT',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

            if (swipeRatio < -0.1)
              Positioned(
                top: 40,
                right: 20,
                child: AnimatedOpacity(
                  opacity: swipeRatio.abs().clamp(0.0, 1.0),
                  duration: Duration.zero,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFBA1A1A).withOpacity(0.9),
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: const Color(0xFFBA1A1A), width: 2),
                    ),
                    child: const Text(
                      'PASS',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

            // Top trust badges
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  if (card.isVerified)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0058BC),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 13, color: Colors.white),
                          SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (card.university != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text(
                        card.university!,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1C1B1B),
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Bottom profile info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Name + age
                    Text(
                      '${card.name}, ${card.age}',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.56,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          card.location,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Bento specs
                    Row(
                      children: [
                        _SpecChip(
                          icon: Icons.hiking,
                          label: card.travelStyle,
                        ),
                        const SizedBox(width: 8),
                        _SpecChip(
                          icon: Icons.payments_outlined,
                          label: card.budget,
                        ),
                        const SizedBox(width: 8),
                        _SpecChip(
                          icon: Icons.calendar_month_outlined,
                          label: card.date,
                        ),
                      ],
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

class _SpecChip extends StatelessWidget {
  const _SpecChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 16, color: const Color(0xFFFE9400)),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Action Buttons
// ─────────────────────────────────────────────────────────────
class _ActionButtons extends StatelessWidget {
  const _ActionButtons({
    required this.onPass,
    required this.onSuperLike,
    required this.onConnect,
  });
  final VoidCallback onPass;
  final VoidCallback onSuperLike;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Pass
        _CircleButton(
          size: 64,
          backgroundColor: Colors.white,
          border: Border.all(color: const Color(0xFFC1C6D7)),
          shadowColor: Colors.black.withOpacity(0.1),
          onTap: onPass,
          child: const Icon(Icons.close, size: 32, color: Color(0xFFBA1A1A)),
        ),
        const SizedBox(width: 24),

        // Super like
        _CircleButton(
          size: 48,
          backgroundColor: const Color(0xFFFFDCBF),
          shadowColor: const Color(0xFFFFDCBF).withOpacity(0.4),
          onTap: onSuperLike,
          child: const Icon(Icons.star_rounded,
              size: 24, color: Color(0xFF8C5000)),
        ),
        const SizedBox(width: 24),

        // Connect
        _CircleButton(
          size: 64,
          backgroundColor: const Color(0xFF0058BC),
          shadowColor: const Color(0xFF0058BC).withOpacity(0.35),
          ringColor: const Color(0xFFD8E2FF),
          onTap: onConnect,
          child:
              const Icon(Icons.travel_explore, size: 32, color: Colors.white),
        ),
      ],
    );
  }
}

class _CircleButton extends StatefulWidget {
  const _CircleButton({
    required this.size,
    required this.backgroundColor,
    required this.onTap,
    required this.child,
    this.border,
    this.shadowColor,
    this.ringColor,
  });
  final double size;
  final Color backgroundColor;
  final VoidCallback onTap;
  final Widget child;
  final Border? border;
  final Color? shadowColor;
  final Color? ringColor;

  @override
  State<_CircleButton> createState() => _CircleButtonState();
}

class _CircleButtonState extends State<_CircleButton> {
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
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.backgroundColor,
            border: widget.border,
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor ?? Colors.transparent,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (widget.ringColor != null)
                Container(
                  width: widget.size + 8,
                  height: widget.size + 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.ringColor!,
                      width: 4,
                    ),
                  ),
                ),
              widget.child,
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Filter Chips
// ─────────────────────────────────────────────────────────────
class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.filters,
    required this.active,
    required this.onSelect,
  });
  final List<String> filters;
  final String active;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final f = filters[i];
          final isActive = f == active;
          return GestureDetector(
            onTap: () => onSelect(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isActive
                    ? const Color(0xFFFE9400)
                    : const Color(0xFFEBE7E7),
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (i == 0) ...[
                    Icon(
                      Icons.tune,
                      size: 14,
                      color: isActive
                          ? const Color(0xFF633700)
                          : const Color(0xFF414755),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    f,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: isActive
                          ? const Color(0xFF633700)
                          : const Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
