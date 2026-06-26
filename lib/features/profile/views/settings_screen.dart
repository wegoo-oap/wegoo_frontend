import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLang = 'EN';

  final List<Map<String, String>> _languages = [
    {'code': 'EN', 'label': 'English'},
    {'code': 'FR', 'label': 'Français'},
    {'code': 'AR', 'label': 'العربية'},
  ];

  final List<_SettingItem> _settingItems = [
    _SettingItem(
      icon: Icons.notifications_outlined,
      title: 'Notifications',
      subtitle: 'Manage push alerts and email updates',
      isDestructive: false,
    ),
    _SettingItem(
      icon: Icons.lock_outline,
      title: 'Privacy',
      subtitle: 'Profile visibility and data sharing',
      isDestructive: false,
    ),
    _SettingItem(
      icon: Icons.block,
      title: 'Block List',
      subtitle: 'Manage blocked users and muted accounts',
      isDestructive: false,
    ),
    _SettingItem(
      icon: Icons.delete_forever_outlined,
      title: 'Delete Account',
      subtitle: 'Permanently remove your data and profile',
      isDestructive: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero
                  _buildHero(),
                  const SizedBox(height: 32),

                  // Language
                  _buildLanguageSwitcher(),
                  const SizedBox(height: 32),

                  // Settings list
                  _buildSettingsList(context),
                  const SizedBox(height: 32),

                  // Bento cards
                  _buildBentoCards(),
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
            IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color(0xFF0058BC), size: 22),
              onPressed: () => Navigator.of(context).maybePop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            // Avatar
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
              onTap: () => context.go('/profile'),
              child: Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.settings_outlined,
                    color: Color(0xFF0058BC), size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 180,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF0058BC).withOpacity(0.85),
                    const Color(0xFF8C5000).withOpacity(0.85),
                  ],
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'App Settings',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.56,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Customize your Wegoo experience',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSwitcher() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC1C6D7).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.language, color: Color(0xFF0058BC), size: 20),
              SizedBox(width: 8),
              Text(
                'LANGUAGE PREFERENCE',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Color(0xFF414755),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: _languages.map((lang) {
              final isActive = _selectedLang == lang['code'];
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: lang['code'] != 'AR' ? 10 : 0,
                  ),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedLang = lang['code']!),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFF0058BC).withOpacity(0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isActive
                              ? const Color(0xFF0058BC)
                              : const Color(0xFFC1C6D7),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            lang['code']!,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isActive
                                  ? const Color(0xFF0058BC)
                                  : const Color(0xFF1C1B1B),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            lang['label']!,
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12,
                              color: isActive
                                  ? const Color(0xFF0058BC)
                                  : const Color(0xFF414755),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: _settingItems.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _SettingRow(
            item: item,
            onTap: () {
              if (item.title == 'Delete Account') {
                _showDeleteDialog(context);
              }
            },
          ),
        );
      }).toList(),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Account',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
            color: Color(0xFFBA1A1A),
          ),
        ),
        content: const Text(
          'This will permanently remove all your data. This action cannot be undone.',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            color: Color(0xFF414755),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Color(0xFF414755),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              const storage = FlutterSecureStorage();
              await storage.delete(key: 'jwt_token');
              if (context.mounted) context.go('/splash');
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w700,
                color: Color(0xFFBA1A1A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCards() {
    return Row(
      children: [
        // Need help card
        Expanded(
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFE9400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Need help?',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF633700),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Our 24/7 concierge is here for your journey.',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        color: Color(0xFF633700),
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF633700),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Icon(
                    Icons.support_agent,
                    size: 80,
                    color: const Color(0xFF633700).withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Go Premium card
        Expanded(
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Go Premium',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Unlock exclusive Mediterranean routes.',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE9400),
                        borderRadius: BorderRadius.circular(99),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Upgrade Now',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF633700),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: Icon(
                    Icons.workspace_premium,
                    size: 80,
                    color: Colors.white.withOpacity(0.08),
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

// â”€â”€ Setting Item Model â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDestructive;

  const _SettingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDestructive,
  });
}

// â”€â”€ Setting Row â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SettingRow extends StatefulWidget {
  final _SettingItem item;
  final VoidCallback onTap;

  const _SettingRow({required this.item, required this.onTap});

  @override
  State<_SettingRow> createState() => _SettingRowState();
}

class _SettingRowState extends State<_SettingRow> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final iconBg = item.isDestructive
        ? const Color(0xFFFFDAD6).withOpacity(0.4)
        : const Color(0xFF0070EB).withOpacity(0.08);
    final iconColor =
        item.isDestructive ? const Color(0xFFBA1A1A) : const Color(0xFF0058BC);
    final titleColor =
        item.isDestructive ? const Color(0xFFBA1A1A) : const Color(0xFF1C1B1B);
    final borderColor = item.isDestructive
        ? const Color(0xFFBA1A1A).withOpacity(0.1)
        : const Color(0xFFC1C6D7).withOpacity(0.3);
    final hoverBg = item.isDestructive
        ? const Color(0xFFFFDAD6).withOpacity(0.2)
        : const Color(0xFFF6F3F2);

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
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _hovered ? hoverBg : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: borderColor),
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
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item.icon, color: iconColor, size: 22),
                ),
                const SizedBox(width: 16),

                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          color: Color(0xFF414755),
                        ),
                      ),
                    ],
                  ),
                ),

                // Trailing
                AnimatedSlide(
                  offset: _hovered ? const Offset(0.1, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    item.isDestructive
                        ? Icons.warning_amber
                        : Icons.chevron_right,
                    color: item.isDestructive
                        ? const Color(0xFFBA1A1A)
                        : const Color(0xFF717786),
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
