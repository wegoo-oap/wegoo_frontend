import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  String? _activeCluster;
  final Set<String> _activeFilters = {'Solo'};
  final TextEditingController _searchController = TextEditingController();

  late AnimationController _float1;
  late AnimationController _float2;
  late AnimationController _float3;

  final List<_MapCluster> _clusters = [
    _MapCluster(
      id: 'positano',
      label: 'POSITANO',
      count: 12,
      subtitle: '12 travelers exploring currently',
      left: 0.25,
      top: 0.28,
      color: const Color(0xFF0058BC),
      size: 52,
      animDelay: 0,
    ),
    _MapCluster(
      id: 'amalfi',
      label: 'AMALFI',
      count: 8,
      subtitle: '8 active adventure groups',
      left: 0.60,
      top: 0.52,
      color: const Color(0xFF8C5000),
      size: 44,
      animDelay: 500,
    ),
  ];

  final List<_MapPin> _pins = [
    _MapPin(left: 0.75, top: 0.38, animDelay: 1000),
    _MapPin(left: 0.42, top: 0.62, animDelay: 1500),
    _MapPin(left: 0.18, top: 0.55, animDelay: 800),
  ];

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Solo', 'icon': Icons.person},
    {'label': 'Groups', 'icon': Icons.group},
    {'label': 'Adventure', 'icon': Icons.explore},
  ];

  @override
  void initState() {
    super.initState();
    _float1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _float2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _float2.repeat(reverse: true);
    });

    _float3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _float3.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _float1.dispose();
    _float2.dispose();
    _float3.dispose();
    _searchController.dispose();
    super.dispose();
  }

  AnimationController _controllerForIndex(int i) {
    if (i == 0) return _float1;
    if (i == 1) return _float2;
    return _float3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [
                // Map background
                _buildMapBackground(),

                // Cluster markers
                ...List.generate(_clusters.length, (i) {
                  final c = _clusters[i];
                  return _buildCluster(c, _controllerForIndex(i));
                }),

                // Individual pins
                ...List.generate(_pins.length, (i) {
                  final p = _pins[i];
                  return _buildPin(p, _controllerForIndex(i));
                }),

                // Floating search + filter UI
                _buildFloatingSearch(),

                // Close cluster on map tap
                Positioned.fill(
                  child: GestureDetector(
                    onTap: () {
                      if (_activeCluster != null) {
                        setState(() => _activeCluster = null);
                      }
                    },
                    child: const ColoredBox(color: Colors.transparent),
                  ),
                ),

                // FAB
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: _MapFab(onTap: () {}),
                ),
              ],
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
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFFE9400),
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.person, color: Color(0xFF633700), size: 22),
            ),
            const SizedBox(width: 12),
            const Text(
              'Wegoo',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0058BC),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => context.go('/settings'),
              child: const Icon(Icons.settings_outlined,
                  color: Color(0xFF0058BC), size: 22),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB8D4E8),
        ),
        child: CustomPaint(
          painter: _MapPainter(),
        ),
      ),
    );
  }

  Widget _buildCluster(_MapCluster cluster, AnimationController ctrl) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final left = cluster.left * constraints.maxWidth - cluster.size / 2;
        final top = cluster.top * constraints.maxHeight - cluster.size / 2;

        return Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _activeCluster =
                    _activeCluster == cluster.id ? null : cluster.id;
              });
            },
            child: AnimatedBuilder(
              animation: ctrl,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -5 * ctrl.value),
                  child: child,
                );
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Pulse ring
                  Container(
                    width: cluster.size + 16,
                    height: cluster.size + 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: cluster.color.withOpacity(0.15),
                    ),
                  ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Container(
                      width: cluster.size,
                      height: cluster.size,
                      decoration: BoxDecoration(
                        color: cluster.color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: cluster.color.withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${cluster.count}',
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Popup
                  if (_activeCluster == cluster.id)
                    Positioned(
                      top: cluster.size + 12,
                      left: -(80 - cluster.size / 2),
                      child: _ClusterPopup(
                        label: cluster.label,
                        subtitle: cluster.subtitle,
                        color: cluster.color,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPin(_MapPin pin, AnimationController ctrl) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final left = pin.left * constraints.maxWidth - 16;
        final top = pin.top * constraints.maxHeight - 16;

        return Positioned(
          left: left,
          top: top,
          child: AnimatedBuilder(
            animation: ctrl,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -4 * ctrl.value),
                child: child,
              );
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0058BC), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.person_pin_circle,
                  color: Color(0xFF0058BC), size: 18),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingSearch() {
    return Positioned(
      top: 16,
      left: 20,
      right: 20,
      child: Column(
        children: [
          // Search bar
          Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(99),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const SizedBox(width: 16),
                const Icon(Icons.search, color: Color(0xFF717786), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 15,
                      color: Color(0xFF1C1B1B),
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search Amalfi, Positano...',
                      hintStyle: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15,
                        color: Color(0xFFC1C6D7),
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.tune,
                        color: Color(0xFF0058BC), size: 20),
                  ),
                ),
                const SizedBox(width: 4),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filters.map((f) {
                final isActive = _activeFilters.contains(f['label']);
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isActive) {
                          _activeFilters.remove(f['label']);
                        } else {
                          _activeFilters.add(f['label'] as String);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color:
                            isActive ? const Color(0xFF0058BC) : Colors.white,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF0058BC)
                              : const Color(0xFFC1C6D7),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            f['icon'] as IconData,
                            size: 14,
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF414755),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            f['label'] as String,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF414755),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Cluster Popup ─────────────────────────────────────────────

class _ClusterPopup extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;

  const _ClusterPopup({
    required this.label,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              color: Color(0xFF1C1B1B),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Map FAB ───────────────────────────────────────────────────

class _MapFab extends StatefulWidget {
  final VoidCallback onTap;
  const _MapFab({required this.onTap});

  @override
  State<_MapFab> createState() => _MapFabState();
}

class _MapFabState extends State<_MapFab> {
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
            color: const Color(0xFFFE9400),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFE9400).withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Color(0xFF633700), size: 28),
        ),
      ),
    );
  }
}

// ── Map Painter ───────────────────────────────────────────────

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Ocean base
    final ocean = Paint()..color = const Color(0xFF7EC8E3);
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), ocean);

    // Land masses
    final land = Paint()..color = const Color(0xFFE8E0D0);
    final path1 = Path()
      ..moveTo(0, h * 0.3)
      ..lineTo(w * 0.15, h * 0.2)
      ..lineTo(w * 0.35, h * 0.25)
      ..lineTo(w * 0.55, h * 0.15)
      ..lineTo(w * 0.75, h * 0.22)
      ..lineTo(w, h * 0.18)
      ..lineTo(w, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(path1, land);

    // Coastal detail
    final coastal = Paint()..color = const Color(0xFFD4C8B0);
    final path2 = Path()
      ..moveTo(0, h * 0.32)
      ..quadraticBezierTo(w * 0.2, h * 0.28, w * 0.35, h * 0.3)
      ..quadraticBezierTo(w * 0.5, h * 0.32, w * 0.65, h * 0.25)
      ..quadraticBezierTo(w * 0.8, h * 0.2, w, h * 0.22)
      ..lineTo(w, h * 0.18)
      ..lineTo(w * 0.75, h * 0.22)
      ..lineTo(w * 0.55, h * 0.15)
      ..lineTo(w * 0.35, h * 0.25)
      ..lineTo(w * 0.15, h * 0.2)
      ..lineTo(0, h * 0.3)
      ..close();
    canvas.drawPath(path2, coastal);

    // Roads
    final road = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(Offset(w * 0.1, h * 0.35), Offset(w * 0.9, h * 0.28), road);
    canvas.drawLine(Offset(w * 0.3, h * 0.2), Offset(w * 0.4, h * 0.5), road);
    canvas.drawLine(Offset(w * 0.6, h * 0.22), Offset(w * 0.65, h * 0.6), road);

    // Grid lines (subtle)
    final grid = Paint()
      ..color = const Color(0xFF7EC8E3).withOpacity(0.3)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 1; i < 6; i++) {
      canvas.drawLine(Offset(w * i / 6, h * 0.35), Offset(w * i / 6, h), grid);
    }
    for (int i = 1; i < 4; i++) {
      canvas.drawLine(Offset(0, h * (0.35 + i * 0.2)),
          Offset(w, h * (0.35 + i * 0.2)), grid);
    }

    // Town dots
    final town = Paint()..color = const Color(0xFFC8B89A);
    final townPositions = [
      Offset(w * 0.22, h * 0.28),
      Offset(w * 0.42, h * 0.24),
      Offset(w * 0.62, h * 0.22),
      Offset(w * 0.78, h * 0.26),
    ];
    for (final pos in townPositions) {
      canvas.drawCircle(pos, 4, town);
    }
  }

  @override
  bool shouldRepaint(_MapPainter old) => false;
}

// ── Data Models ───────────────────────────────────────────────

class _MapCluster {
  final String id;
  final String label;
  final int count;
  final String subtitle;
  final double left;
  final double top;
  final Color color;
  final double size;
  final int animDelay;

  const _MapCluster({
    required this.id,
    required this.label,
    required this.count,
    required this.subtitle,
    required this.left,
    required this.top,
    required this.color,
    required this.size,
    required this.animDelay,
  });
}

class _MapPin {
  final double left;
  final double top;
  final int animDelay;

  const _MapPin({
    required this.left,
    required this.top,
    required this.animDelay,
  });
}
