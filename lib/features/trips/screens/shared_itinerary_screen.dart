import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SharedItineraryScreen extends StatefulWidget {
  final String tripTitle;
  final String heroImageUrl;

  const SharedItineraryScreen({
    super.key,
    this.tripTitle = 'Amalfi Coast Wonders',
    this.heroImageUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCcVep6SlpehBX75gmUEH_GIPYTIG-bPazhHCfOOIoLcswA9FSf2jreEn0DV-QqIva9ZxMmIEQT8CtHqEI0S2nHUtLWu2-BFmEbmescVo_E29b_U78zm4dal6QNcsluVJhN1Dx_UXG2-rNiqWsutnJL_0iH2P2ZBfIiYApKLXvu1CdFmKyWiFf7HM8EhZxnxAOw5thkPSuvpYscTvOKkK-WBPMA4ckfja2E19BY8gaAWov9weyWbiZNzPh9K-DJDuCoQ7EudEq2Qc0Y',
  });

  @override
  State<SharedItineraryScreen> createState() => _SharedItineraryScreenState();
}

class _SharedItineraryScreenState extends State<SharedItineraryScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _headerGlass = false;

  late AnimationController _fabController;
  late Animation<double> _fabRotation;

  static const _primary = Color(0xFF0058BC);
  static const _secondary = Color(0xFF8C5000);
  static const _surface = Color(0xFFFCF9F8);
  static const _onSurface = Color(0xFF1C1B1B);
  static const _onSurfaceVariant = Color(0xFF414755);
  static const _outlineVariant = Color(0xFFC1C6D7);
  static const _secondaryContainer = Color(0xFFFE9400);
  static const _onSecondaryContainer = Color(0xFF633700);
  static const _primaryContainer = Color(0xFF0070EB);
  static const _surfaceContainer = Color(0xFFF0EDEC);
  static const _tertiaryFixed = Color(0xFFE4E2E2);

  static const _memberAvatars = [
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCSObGH15Kk_I9kWVAFzgfdhSEWjcKkSfclMCYc_LieIHVgd-bIwK1QDWq1UpyGS_xxMQv4_0dRKt6njUVKy4S_lqD8dqIQuN5vyaFFgGy6fz0gwZPZT2FAVJOyhYILcAg4aPeANxnvFELXFmHuTdQaObhB5cKQMady1PNyh4aqTBey6mBrfspXHQKZTstgmVSloywGZvnCi2kRqKb1XQNlds8qevCnJAeHk43hu3-a5j_dbbCQxYnynLJBFKl0YW4chgBgA0GvcEoV',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAhBABCA3YmOPiNIMCW4WBEXulmVzHEAt_04aCaTUq84cBPU2NER6h5htx3zKpTNtGDexAykBc4TPQq6TchkgjMFv9J7KQbBeTX0nsYUEq_eQwP7SZlRONDD7QlZeo8xBIhonhXVfZ4S44Mh6TMIeZA3WapumxUQnmCKJNftEvvftQmka-kKm30hgwI51tYJS5S356qSCA-7ZZQwKeToTh0TeSNGNLIrRBkICQTVojp1b2lzwnYLPDftGeKSlOTZfW050KgAN9wWWcF',
    'https://lh3.googleusercontent.com/aida-public/AB6AXuBgabufDD0NSRneBwEKnkjFBYnRXeGxMnEICmg1KzniRh3RNZd9vnnnwul5leP9E_1ICkRE1OtNmfgP_wxnbbKE7nFmyrOFPW9AKK0A6q83fOLIoDO8BqlB3H3NkYrOcl_Sr0rSv8X9rp-62JcZOfYd3zZSrce6j3gfP1DbVmuVRgpvqDykdeFfnPIg9SEIsQFyxWZmJh85KVCWbVE7znI-Ez7D5aNsLvC0UeTOYmTMyC074JJqN0oRkim-GWrF9IsECIACanPBHiiy',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _fabRotation = Tween<double>(begin: 0, end: 0.125).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
    );
  }

  void _onScroll() {
    final glass = _scrollController.offset > 20;
    if (glass != _headerGlass) setState(() => _headerGlass = glass);
  }

  Future<void> _onFabTap() async {
    await _fabController.forward();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add Place module would open here!')),
    );
    await _fabController.reverse();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: _surface,
        body: Stack(
          children: [
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 32, 20, 120),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 672),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroSection(),
                            const SizedBox(height: 32),
                            _buildTimeline(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 24,
              bottom: 32,
              child: _buildFab(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    const headerAvatarUrl =
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD7OpVzNUT1JMbi7WAAGdCST6hB8tmtz8Y2PWtwbrCeLorS5Ij6dXQTscwdNfB_M6kFh92BknAprT04VL38LhTIX-Co93XTJ5pIoj5CXV0cbx9Om3qkFLUfebuZdAed3Dveq6LAUudWA4QHzQ178XDn8qBmcJYTiSfI584HCJeWSC0Ip27ZyvWJuOt00BYHf2Vq_Y7nP7HTJg65GnRZFqhUagOD4r-0QxJY0R4I8PGO7oYWiRyXgnUXSfezuNCX5mOlbezY0grw0-ml';

    final headerBg = _headerGlass
        ? Colors.white.withValues(alpha: 0.85)
        : _surface;

    Widget content = SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            ClipOval(
              child: SizedBox(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: headerAvatarUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: _primaryContainer,
                    child: const Icon(Icons.person, color: Colors.white, size: 22),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: _primaryContainer,
                    child: const Icon(Icons.person, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Wegoo',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: _primary,
              ),
            ),
            const Spacer(),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go('/settings'),
                borderRadius: BorderRadius.circular(99),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Icon(Icons.settings_outlined,
                      color: _onSurfaceVariant, size: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (_headerGlass) {
      content = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: content,
        ),
      );
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: headerBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: content,
    );
  }

  Widget _buildHeroSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: SizedBox(
            height: 192,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: widget.heroImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: _surfaceContainer,
                    child: const Icon(Icons.landscape,
                        size: 56, color: Colors.white54),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF0058BC), Color(0xFFFE9400)],
                      ),
                    ),
                    child: const Icon(Icons.landscape,
                        size: 56, color: Colors.white54),
                  ),
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: _secondaryContainer,
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              'GROUP TRIP',
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                                color: _onSecondaryContainer,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildMemberAvatars(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tripTitle,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 28,
                          height: 36 / 28,
                          letterSpacing: -0.56,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const Expanded(
              child: Row(
                children: [
                  Icon(Icons.edit_outlined, size: 16, color: _onSurfaceVariant),
                  SizedBox(width: 4),
                  Text(
                    'Everyone can edit this itinerary',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      color: _onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.share_outlined, color: _primary, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, color: _primary, size: 22),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMemberAvatars() {
    return SizedBox(
      height: 24,
      width: 24.0 * _memberAvatars.length + 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          for (int i = 0; i < _memberAvatars.length; i++)
            Positioned(
              left: i * 16.0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _memberAvatars[i],
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: _primaryContainer,
                      child: const Icon(Icons.person, size: 12, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            left: _memberAvatars.length * 16.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _tertiaryFixed,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Center(
                child: Text(
                  '+2',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: _onSurface,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 19,
          top: 56,
          bottom: 16,
          width: 2,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomPaint(
                size: Size(2, constraints.maxHeight),
                painter: _DashedLinePainter(color: _outlineVariant),
              );
            },
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDayHeader(),
            const SizedBox(height: 48),
            _ItineraryActivityCard(
              dotColor: _primary,
              timeLabel: '10:00 AM',
              timeColor: _primary,
              title: 'Positano Hike',
              description:
                  'Guided trek through the Path of the Gods. Bring water and cameras!',
              imageUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuBqhIJjdxrz5-axpENdulPbl0kkg9dIwSnptXMpkKzbL8PwzK4YhXcQtkmk8HxzpHAkwBHWpEVq5AmAG7zky_zbmOPnRx69c52I2fjsMXd9usIBH3taw0VyIMbMSjINlS8S4t0L-idG9EfXdJzmHk7Z163PozM4YzxFj24bp6KY7XGgVaxs5L4_ZfoAwVfmZxDfIIF-kRhShLb06n4GMDbSQirlc4rCxPdLVtsM7ggYqcAQl7k1wFVHSm3IWWY7_WcGk93Qu-XUg6pG',
              addedByName: 'Marco',
              addedByAvatarUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDk2PFaUNIrS5m4n9WU8YRr30aP2ME0YL8yb0VjjcT_sJAEFuhnCYP3zUVnno6kiOXt0ukKBoL9JzuEreEveDp_ScwCS-eAbXe5tfF5rVF0kbMquMllz-uEvuxIda9M5lOqpT3p9gBp0xgjWBaGplizhBafWTwmrJO3rNkr6xWYN-WBp66aIyXVrguL6xcQk9oeTFqypRmb8EzcW91u1AEyX-Pzw5NwVyYKMyeukAT8PvCStWavAkuo39cgXQTNiVVsOlV4z18IEm2f',
            ),
            const SizedBox(height: 48),
            _ItineraryActivityCard(
              dotColor: _secondary,
              timeLabel: '1:00 PM',
              timeColor: _secondary,
              title: 'Lunch at Chez Black',
              description:
                  'The famous Heart-shaped pizza and fresh seafood right on the beach.',
              reservationBadge: true,
              addedByName: 'Sophie',
              addedByAvatarUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDIP3CZYYlhs7qEYwGy7YLjX93WFPedvdSrNlOVt3kv7Fwe0fVpWjGmV6m0lfbqh4YGpKY19oJbRgAobvft0SANBbNLHSu05c9B51INXeEFGOdsYI4DCkbFjNyoraf64r31FOsescCCfuCHxhakC6H7e6DoaLrESfeXA0OBOA55FvtH6eDA2W8iM_abD0Qd5N1XrCdvJDXSsyIQLWZmNHMk5NRdc9bUOmDgkjMPkMCmpFwrpboVBiqzG0Lkg_bNuB3alx58SGp_l86p',
            ),
            const SizedBox(height: 48),
            _ItineraryActivityCard(
              dotColor: _primary,
              timeLabel: '6:30 PM',
              timeColor: _primary,
              title: 'Sunset Boat Tour',
              description:
                  'Private charter for the group around the coast as the lights start to twinkle.',
              addedByName: 'Trip Admin',
              addedByAvatarUrl:
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCIjolviJBP4Qwm59ATwjM6Gx4OV2kD8ZHb4nX7zn9YVsZBl1b18fFXTORxtyd48ARRoxyBN3eDSWjdMws7sIBzdMi65aiZoUbJorjnvBsBrz4UZ-WqeRIYpTpP2uXR4JVg5aS4EBnCXX6WfFAjEJ0X43q9uYTdEmlqipE-I3US5lCh21Rn4EaZbkrVoqdBSrreKneIFPHMHIkCCnZwAIOEH28oJPHQiGIQdhvJR69lpzYZrZlX8DLQ4Xjky0ICIi_Owmi6oACzw4_n',
            ),
            const SizedBox(height: 48),
            _buildAddStopButton(),
          ],
        ),
      ],
    );
  }

  Widget _buildDayHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _primary.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(Icons.calendar_today_outlined,
              color: Colors.white, size: 20),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SEPTEMBER 12',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: _primary,
              ),
            ),
            Text(
              'The Positano Dream',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 24,
                height: 32 / 24,
                fontWeight: FontWeight.w600,
                color: _onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddStopButton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          alignment: Alignment.topCenter,
          child: Container(
            width: 16,
            height: 16,
            decoration: const BoxDecoration(
              color: _outlineVariant,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _DashedBorderPainter(
                  color: _outlineVariant,
                  radius: 12,
                  strokeWidth: 2,
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: _onSurfaceVariant, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Plan another stop',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFab() {
    return RotationTransition(
      turns: _fabRotation,
      child: Material(
        elevation: 8,
        shadowColor: _secondaryContainer.withValues(alpha: 0.4),
        shape: const CircleBorder(),
        color: _secondaryContainer,
        child: InkWell(
          onTap: _onFabTap,
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add_location_alt_outlined,
                color: _onSecondaryContainer, size: 28),
          ),
        ),
      ),
    );
  }
}

class _ItineraryActivityCard extends StatefulWidget {
  final Color dotColor;
  final String timeLabel;
  final Color timeColor;
  final String title;
  final String description;
  final String? imageUrl;
  final bool reservationBadge;
  final String addedByName;
  final String addedByAvatarUrl;

  const _ItineraryActivityCard({
    required this.dotColor,
    required this.timeLabel,
    required this.timeColor,
    required this.title,
    required this.description,
    this.imageUrl,
    this.reservationBadge = false,
    required this.addedByName,
    required this.addedByAvatarUrl,
  });

  @override
  State<_ItineraryActivityCard> createState() => _ItineraryActivityCardState();
}

class _ItineraryActivityCardState extends State<_ItineraryActivityCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 40,
            child: Center(
              child: AnimatedScale(
                scale: _hovered ? 1.25 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.dotColor, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFC1C6D7)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                        alpha: _hovered ? 0.1 : 0.04),
                    blurRadius: _hovered ? 12 : 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.timeLabel,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: widget.timeColor,
                        ),
                      ),
                      const Icon(Icons.drag_handle,
                          size: 20, color: Color(0xFF414755)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1C1B1B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.description,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      height: 20 / 14,
                      color: Color(0xFF414755),
                    ),
                  ),
                  if (widget.imageUrl != null) ...[
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        height: 128,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl!,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: const Color(0xFFF0EDEC),
                            child: const Icon(Icons.image_outlined,
                                color: Color(0xFF717786)),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (widget.reservationBadge) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0EDEC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC1C6D7)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.restaurant_outlined,
                              size: 18, color: Color(0xFF8C5000)),
                          SizedBox(width: 8),
                          Text(
                            'Reservation: Confirmed',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 14,
                              color: Color(0xFF1C1B1B),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      ClipOval(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CachedNetworkImage(
                            imageUrl: widget.addedByAvatarUrl,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              color: const Color(0xFFD8E2FF),
                              child: const Icon(Icons.person, size: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Added by ${widget.addedByName}',
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 10,
                          color: Color(0xFF414755),
                        ),
                      ),
                    ],
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

class _DashedLinePainter extends CustomPainter {
  final Color color;

  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const gapHeight = 4.0;
    double y = 0;

    while (y < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, y),
        Offset(size.width / 2, y + dashHeight),
        paint,
      );
      y += dashHeight + gapHeight;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    required this.radius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
          strokeWidth / 2,
          strokeWidth / 2,
          size.width - strokeWidth,
          size.height - strokeWidth,
        ),
        Radius.circular(radius),
      ));

    for (final metric in path.computeMetrics()) {
      const dash = 6.0;
      const gap = 4.0;
      var distance = 0.0;
      while (distance < metric.length) {
        final end = distance + dash;
        canvas.drawPath(metric.extractPath(distance, end.clamp(0, metric.length)),
            paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth;
}
