import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;

    int currentIndex = 0;
    if (location.startsWith('/trips')) currentIndex = 1;
    if (location.startsWith('/messages')) currentIndex = 2;
    if (location.startsWith('/profile')) currentIndex = 3;

    return Scaffold(
      body: child,
      bottomNavigationBar: _WegooBottomNav(
        currentIndex: currentIndex,
        onTap: (i) {
          if (i == 0) context.go('/home');
          if (i == 1) context.go('/trips');
          if (i == 2) context.go('/messages');
          if (i == 3) context.go('/profile');
          if (i == 4) context.go('/map');
        },
      ),
    );
  }
}

class _WegooBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _WegooBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0xFFFCF9F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
              icon: Icons.explore,
              label: 'Discovery',
              index: 0,
              currentIndex: currentIndex,
              onTap: onTap),
          _NavItem(
              icon: Icons.travel_explore,
              label: 'Trips',
              index: 1,
              currentIndex: currentIndex,
              onTap: onTap),
          _NavItem(
              icon: Icons.chat_bubble_outline,
              label: 'Messages',
              index: 2,
              currentIndex: currentIndex,
              onTap: onTap),
          _NavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              index: 3,
              currentIndex: currentIndex,
              onTap: onTap),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFE9400) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color:
                  isActive ? const Color(0xFF633700) : const Color(0xFF414755),
            ),
            const SizedBox(height: 2),
            Text(
              label,
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
  }
}
