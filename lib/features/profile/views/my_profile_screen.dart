import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileHero(context),
                  const SizedBox(height: 24),
                  _buildStatsBento(),
                  const SizedBox(height: 32),
                  _buildPreferencesSection(context),
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
        color: const Color(0xFFFCF9F8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
              ],
            ),
            const Icon(Icons.notifications_outlined,
                color: Color(0xFF0058BC), size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHero(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Avatar
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              color: const Color(0xFFD8E2FF),
            ),
            child: const ClipOval(
              child: Icon(Icons.person, size: 64, color: Color(0xFF0058BC)),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          const Text(
            'Mateo Rossi',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C1B1B),
            ),
          ),
          const SizedBox(height: 8),

          // Bio
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Architect by day, wanderlust enthusiast by night. Dreaming of Greek sunsets and Italian espressos. ðŸŒâ˜•',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                color: Color(0xFF414755),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Edit Profile button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0070EB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFEFCFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBento() {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '12',
            label: 'TRIPS',
            valueColor: const Color(0xFF0058BC),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '45',
            label: 'LINKS',
            valueColor: const Color(0xFF8C5000),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            value: '4.9',
            label: 'RATING',
            valueColor: const Color(0xFF1C1B1B),
            showStar: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'ACCOUNT PREFERENCES',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Color(0xFF717786),
            ),
          ),
        ),

        _PreferenceItem(
          icon: Icons.settings_outlined,
          iconBgColor: const Color(0xFF0058BC).withOpacity(0.1),
          iconColor: const Color(0xFF0058BC),
          label: 'Settings',
          onTap: () => context.go('/settings'), // â† remplace () {}
        ),
        const SizedBox(height: 12),

        _PreferenceItem(
          icon: Icons.help_outline,
          iconBgColor: const Color(0xFF8C5000).withOpacity(0.1),
          iconColor: const Color(0xFF8C5000),
          label: 'Help & Support',
          onTap: () {},
        ),
        const SizedBox(height: 12),

        _PreferenceItem(
          icon: Icons.shield_outlined,
          iconBgColor: const Color(0xFF5C5C5C).withOpacity(0.1),
          iconColor: const Color(0xFF5C5C5C),
          label: 'Privacy Policy',
          onTap: () {},
        ),
        const SizedBox(height: 24),

        // Log out
        GestureDetector(
          onTap: () async {
            const storage = FlutterSecureStorage();
            await storage.delete(key: 'jwt_token');
            if (context.mounted) {
              context.go('/splash');
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: Color(0xFFBA1A1A), size: 20),
                SizedBox(width: 12),
                Text(
                  'Log Out',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFBA1A1A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// â”€â”€ Stat Card â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;
  final bool showStar;

  const _StatCard({
    required this.value,
    required this.label,
    required this.valueColor,
    this.showStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF0EDEC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
              if (showStar) ...[
                const SizedBox(width: 2),
                const Icon(Icons.star, size: 16, color: Color(0xFF8C5000)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: Color(0xFF414755),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€ Preference Item â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _PreferenceItem extends StatefulWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _PreferenceItem({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  State<_PreferenceItem> createState() => _PreferenceItemState();
}

class _PreferenceItemState extends State<_PreferenceItem> {
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
        scale: _pressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: widget.iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1B1B),
                  ),
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: Color(0xFF717786), size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
