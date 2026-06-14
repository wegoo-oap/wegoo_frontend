import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────
//  Data model
// ─────────────────────────────────────────────────────────────
class _TribeMember {
  const _TribeMember({
    required this.name,
    required this.photoUrl,
    this.isInvited = false,
  });
  final String name;
  final String photoUrl;
  final bool isInvited;
}

enum _PrivacyType { public, private }

// ─────────────────────────────────────────────────────────────
//  Screen
// ─────────────────────────────────────────────────────────────
class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final _groupNameCtrl = TextEditingController();
  final _destinationCtrl = TextEditingController();
  final _startDateCtrl = TextEditingController();
  final _endDateCtrl = TextEditingController();

  _PrivacyType _privacy = _PrivacyType.private;
  bool _isLoading = false;

  // Fake connections list — replaced by Firestore read in logic phase
  final List<_TribeMember> _connections = [
    _TribeMember(
      name: 'Marco',
      photoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuASXOXpWS-7GHNGJjMSR9M5sK2eFNGZjYb6f5mC5qeoAqaXOcvsUKRj-SznutTObyGYWh6Mej-O3bruqbhH6c2wUhkQZIJOsIbV_KsobdB3TQpKxwuw4Ccit2q59ZQl5zMCwEz-fxr6nJJulqzeS25tl1vh6wRuLEIVu1jfS6km1UUu93tH4H2osyCFeHf72DFkYCi4rFC6KMGQ-uoFitQDMUCJGKn5hI6M54ihKsymBrMt6kAd3JjACcoXM7XC9J7DBWsWY-4XJJlD',
      isInvited: true,
    ),
    _TribeMember(
      name: 'Elena',
      photoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD2XOmtRzdHp-OLKNrQS-TC-x0HE7BCxVnhysonF4NbxVUzYjQHrRWX49-wim7dCT8AlsCNDe3QPBuZmQFGajnB6cMh61zDOEFJmQ8-a29X80fr1rQoLLMmu9HqoaduRS3eAfScnUJQ_0v4cdlGofJ5d8CZ3Lcm0Whs0KN11MTc2TAvTkfKPh64gFqSWwatoJ08lNiK0lzY54g6LcOOPXE51cQvb0bNZljekxQ-DiWx_BUunCwtzxZ5hVZI5mF9lq4vcUSLN_XzOolK',
    ),
    _TribeMember(
      name: 'Luca',
      photoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAQO2SmhjgxRgTTM3KiFFMWH4D1-XYenqFYCEL8Ge-SeCI9mqMLN1yAoUE8oe7XgiF7LqX3gsjdXywu3tGES0wQdSMKgSlFhsx1qK8Xuwmk0Mjtr2FsLeSCpGs21ZpTUlwR9S2p49ZPJqxh7P7Q5Nquc1eCfZuexpHcmEHrcJEe7FwQjtxrQaCWhQI23_zne8JBWul8_dEV0nyiUlm4rv4QplngGmKiiestSnq2Fd8eO9f63881xCMCtUTZs9KZzEGdFeJVeWU92rEi',
    ),
    _TribeMember(
      name: 'Sofia',
      photoUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAfGzkIUGsx0XW4pMeHtYkmZwJVcotM2l6nfL0rFZYQsENwnNO1L-8CSQbOf7u5YdCKMDjJtEOegC9oXOr8W5R9GhJLkS5ki6k5Q1RsrNkJYFu4pHfJlkoGnbPO7gubTy3PozJVo8-o9AjPEGpxo2X7Nl-677EiaDIAhn1OJJjvvoR0VueBfbaV0krMnirh5pHpi2GC-uUx5LpW4bSI6I9pX9xU2MZ5HZXxxmgjk8E4E04s1t1HdEYnK2g_r64n4vgooFv',
    ),
  ];

  // Track which members are invited
  final Set<String> _invited = {'Marco'}; // Marco pre-selected like in HTML

  @override
  void dispose() {
    _groupNameCtrl.dispose();
    _destinationCtrl.dispose();
    _startDateCtrl.dispose();
    _endDateCtrl.dispose();
    super.dispose();
  }

  void _toggleInvite(String name) {
    setState(() {
      if (_invited.contains(name)) {
        _invited.remove(name);
      } else {
        _invited.add(name);
      }
    });
  }

  Future<void> _onCreateTribe() async {
    if (_groupNameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a group name.'),
          backgroundColor: Color(0xFFBA1A1A),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // TODO: write group document to Firestore
    // TODO: create associated chat document
    // TODO: send invites to _invited members
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isLoading = false);
      context.go('/home');
    }
  }

  Future<void> _pickDate(TextEditingController ctrl) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF0058BC),
            onPrimary: Colors.white,
            surface: Color(0xFFFCF9F8),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ctrl.text = '${picked.day}/${picked.month}/${picked.year}';
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
        body: Stack(
          children: [
            Column(
              children: [
                // ── Top bar ─────────────────────────────
                _TopBar(),

                // ── Scrollable content ──────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        const Text(
                          'Assemble Your Tribe',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.56,
                            color: Color(0xFF1C1B1B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Create a new journey and invite your best travel companions.',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            color: Color(0xFF414755),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Group name
                        _FormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('GROUP NAME'),
                              const SizedBox(height: 8),
                              _WegooField(
                                controller: _groupNameCtrl,
                                hint: 'e.g. Summer Soul-Seekers',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Destination
                        _FormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('DESTINATION'),
                              const SizedBox(height: 8),
                              _WegooField(
                                controller: _destinationCtrl,
                                hint: 'Amalfi Coast, Italy',
                                prefixIcon: Icons.location_on_outlined,
                              ),
                              const SizedBox(height: 12),
                              // Destination preview image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  height: 128,
                                  width: double.infinity,
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        'https://lh3.googleusercontent.com/aida-public/AB6AXuDPKUZimqGi8_O6eglun68JtUn04ABs_FWLOQaPP6jltLdBKn471ioxuX1lLZiZuOhpzzo0x83iNCW4FcSGH7u-kE3Y2vexlBtT1BywmBruJDTIbBgziZx2Xs5uOSw-rIk_l8ga20IfrUzx4aujTYJggXS7RDNPxVzN_Hqp4uyA3s3ccgebSDlBiK49cLhDCvcU1fBdW0Hbu_J8CLAwqQiHEXTp8DahGgpOJ0aYR8d5GG6O4TutYKr_N12VcAdKv7gyz9IvxyaIHelL',
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          color: const Color(0xFFEBE7E7),
                                          child: const Icon(
                                            Icons.landscape_outlined,
                                            size: 40,
                                            color: Color(0xFF717786),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Color(0x66000000),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Positioned(
                                        bottom: 12,
                                        left: 12,
                                        child: Text(
                                          'Destination Preview',
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
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
                        const SizedBox(height: 16),

                        // Travel dates
                        _FormCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('TRAVEL DATES'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _pickDate(_startDateCtrl),
                                      child: AbsorbPointer(
                                        child: _WegooField(
                                          controller: _startDateCtrl,
                                          hint: 'Start Date',
                                          prefixIcon:
                                              Icons.calendar_today_outlined,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => _pickDate(_endDateCtrl),
                                      child: AbsorbPointer(
                                        child: _WegooField(
                                          controller: _endDateCtrl,
                                          hint: 'End Date',
                                          prefixIcon: Icons.event_outlined,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Invite tribe members
                        _InviteSection(
                          connections: _connections,
                          invited: _invited,
                          onToggle: _toggleInvite,
                        ),
                        const SizedBox(height: 16),

                        // Privacy settings
                        _PrivacySection(
                          selected: _privacy,
                          onChanged: (p) => setState(() => _privacy = p),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Fixed bottom button ──────────────────────
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _CreateButton(
                isLoading: _isLoading,
                onTap: _onCreateTribe,
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
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: const Color(0xFFFCF9F8),
      padding: EdgeInsets.fromLTRB(8, top, 16, 0),
      height: top + 56,
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
          IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF0058BC), size: 24),
            onPressed: () => Navigator.of(context).maybePop(),
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
          // Avatar placeholder
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF0070EB),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Form Card wrapper
// ─────────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  const _FormCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Field Label
// ─────────────────────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.6,
        color: Color(0xFF414755),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Wegoo Text Field
// ─────────────────────────────────────────────────────────────
class _WegooField extends StatelessWidget {
  const _WegooField({
    required this.controller,
    required this.hint,
    this.prefixIcon,
  });
  final TextEditingController controller;
  final String hint;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontSize: 16,
        color: Color(0xFF1C1B1B),
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 16,
          color: Color(0xFF717786),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color(0xFF0058BC), size: 20)
            : null,
        filled: true,
        fillColor: const Color(0xFFFCF9F8),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC1C6D7), width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFC1C6D7), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF0058BC), width: 2),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Invite Section
// ─────────────────────────────────────────────────────────────
class _InviteSection extends StatelessWidget {
  const _InviteSection({
    required this.connections,
    required this.invited,
    required this.onToggle,
  });
  final List<_TribeMember> connections;
  final Set<String> invited;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _FieldLabel('INVITE TRIBE MEMBERS'),
            GestureDetector(
              onTap: () {},
              child: const Row(
                children: [
                  Icon(Icons.add, size: 18, color: Color(0xFF0058BC)),
                  SizedBox(width: 2),
                  Text(
                    'Add more',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0058BC),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Horizontal scrollable avatars
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              ...connections.map((m) => Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _MemberAvatar(
                      member: m,
                      isInvited: invited.contains(m.name),
                      onTap: () => onToggle(m.name),
                    ),
                  )),

              // Contacts button
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFC1C6D7),
                          width: 2,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_add_outlined,
                        size: 28,
                        color: Color(0xFF717786),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'CONTACTS',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Color(0xFF414755),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Member Avatar — dashed border when invited
// ─────────────────────────────────────────────────────────────
class _MemberAvatar extends StatelessWidget {
  const _MemberAvatar({
    required this.member,
    required this.isInvited,
    required this.onTap,
  });
  final _TribeMember member;
  final bool isInvited;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Dashed border container
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isInvited
                        ? const Color(0xFF0058BC)
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    member.photoUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 56,
                      height: 56,
                      color: const Color(0xFFEBE7E7),
                      child: const Icon(Icons.person,
                          size: 28, color: Color(0xFF717786)),
                    ),
                  ),
                ),
              ),

              // Check badge when invited
              if (isInvited)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFE9400),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check,
                        size: 14, color: Color(0xFF633700)),
                  ),
                ),

              // Add badge when not invited
              if (!isInvited)
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0058BC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 14, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            member.name.toUpperCase(),
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: Color(0xFF1C1B1B),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Privacy Section
// ─────────────────────────────────────────────────────────────
class _PrivacySection extends StatelessWidget {
  const _PrivacySection({
    required this.selected,
    required this.onChanged,
  });
  final _PrivacyType selected;
  final ValueChanged<_PrivacyType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F3F2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _FieldLabel('PRIVACY SETTINGS'),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PrivacyOption(
                  icon: Icons.public,
                  label: 'Public Tribe',
                  subtitle: 'Anyone can join',
                  isSelected: selected == _PrivacyType.public,
                  onTap: () => onChanged(_PrivacyType.public),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PrivacyOption(
                  icon: Icons.lock,
                  label: 'Private Tribe',
                  subtitle: 'Invite only',
                  isSelected: selected == _PrivacyType.private,
                  onTap: () => onChanged(_PrivacyType.private),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrivacyOption extends StatelessWidget {
  const _PrivacyOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0058BC).withOpacity(0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF0058BC) : const Color(0xFFC1C6D7),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFF0058BC)
                  : const Color(0xFF414755),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF0058BC)
                    : const Color(0xFF1C1B1B),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10,
                color: isSelected
                    ? const Color(0xFF0058BC)
                    : const Color(0xFF414755),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
//  Create Button
// ─────────────────────────────────────────────────────────────
class _CreateButton extends StatefulWidget {
  const _CreateButton({required this.isLoading, required this.onTap});
  final bool isLoading;
  final VoidCallback onTap;

  @override
  State<_CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<_CreateButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, bottom + 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            const Color(0xFFFCF9F8),
            const Color(0xFFFCF9F8).withOpacity(0.95),
            const Color(0xFFFCF9F8).withOpacity(0.0),
          ],
        ),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          if (!widget.isLoading) widget.onTap();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0058BC).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Tribe',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 0.16,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.celebration, color: Colors.white, size: 20),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
