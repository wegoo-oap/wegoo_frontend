import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key});

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime _focusedMonth = DateTime.now();
  DateTime? _startDate;
  DateTime? _endDate;
  bool _flexibleDates = true;

  void _onDayTap(DateTime day) {
    if (day.isBefore(DateTime.now().subtract(const Duration(days: 1)))) return;
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = day;
        _endDate = null;
      } else {
        if (day.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = day;
        } else {
          _endDate = day;
        }
      }
    });
  }

  String get _durationText {
    if (_startDate == null) return '— days';
    if (_endDate == null) return '1 day';
    final days = _endDate!.difference(_startDate!).inDays + 1;
    return _flexibleDates ? '$days days ±2' : '$days days';
  }

  String get _rangeText {
    if (_startDate == null) return 'Select start';
    if (_endDate == null) return _fmt(_startDate!);
    return '${_fmt(_startDate!)} - ${_fmt(_endDate!)}';
  }

  String _fmt(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[d.month - 1]} ${d.day}';
  }

  String get _monthLabel {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[_focusedMonth.month - 1]} ${_focusedMonth.year}';
  }

  bool _isStart(DateTime d) =>
      _startDate != null &&
      d.year == _startDate!.year &&
      d.month == _startDate!.month &&
      d.day == _startDate!.day;

  bool _isEnd(DateTime d) =>
      _endDate != null &&
      d.year == _endDate!.year &&
      d.month == _endDate!.month &&
      d.day == _endDate!.day;

  bool _isInRange(DateTime d) {
    if (_startDate == null || _endDate == null) return false;
    return d.isAfter(_startDate!) && d.isBefore(_endDate!);
  }

  bool _isPast(DateTime d) =>
      d.isBefore(DateTime.now().subtract(const Duration(days: 1)));

  List<DateTime?> _buildCalendarDays() {
    final firstDay = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final lastDay = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
    // Monday = 0
    int startOffset = firstDay.weekday - 1;
    final days = <DateTime?>[];
    for (int i = 0; i < startOffset; i++) {
      days.add(null);
    }
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_focusedMonth.year, _focusedMonth.month, i));
    }
    // Fill remaining
    while (days.length % 7 != 0) {
      days.add(null);
    }
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final days = _buildCalendarDays();

    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      body: Stack(
        children: [
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      const Text(
                        'When are you leaving?',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.56,
                          color: Color(0xFF1C1B1B),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Select your travel window to find the best Mediterranean experiences.',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          color: Color(0xFF414755),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Duration glass card
                      _buildDurationCard(),
                      const SizedBox(height: 32),

                      // Calendar
                      _buildCalendarHeader(),
                      const SizedBox(height: 16),
                      _buildDayHeaders(),
                      const SizedBox(height: 8),
                      _buildCalendarGrid(days),
                      const SizedBox(height: 32),

                      // Flexible toggle
                      _buildFlexibleToggle(),
                      const SizedBox(height: 32),

                      // Inspiration card
                      _buildInspirationCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom buttons
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Container(
        height: 56,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => context.go('/trip/new/destination'),
              child: const Icon(Icons.arrow_back,
                  color: Color(0xFF0058BC), size: 22),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'STEP 2 OF 4',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Color(0xFF717786),
                  ),
                ),
                Text(
                  'Wegoo',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: Color(0xFF0058BC),
                    height: 1.1,
                  ),
                ),
              ],
            ),
            const Icon(Icons.more_vert, color: Color(0xFF414755), size: 22),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC1C6D7)),
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
          // Duration
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'DURATION',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Color(0xFF0058BC),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _durationText,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C1B1B),
                ),
              ),
            ],
          ),
          const Spacer(),
          // Divider
          Container(
            width: 1,
            height: 40,
            color: const Color(0xFFC1C6D7),
          ),
          const Spacer(),
          // Dates
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'DATES',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: Color(0xFF414755),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _rangeText,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1B1B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _monthLabel,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1C1B1B),
          ),
        ),
        Row(
          children: [
            _CalNavBtn(
              icon: Icons.chevron_left,
              onTap: () => setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month - 1);
              }),
            ),
            const SizedBox(width: 4),
            _CalNavBtn(
              icon: Icons.chevron_right,
              onTap: () => setState(() {
                _focusedMonth =
                    DateTime(_focusedMonth.year, _focusedMonth.month + 1);
              }),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDayHeaders() {
    const days = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    return Row(
      children: days
          .map((d) => Expanded(
                child: Center(
                  child: Text(
                    d,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Color(0xFF717786),
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildCalendarGrid(List<DateTime?> days) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: days.length,
      itemBuilder: (context, i) {
        final day = days[i];
        if (day == null) return const SizedBox();
        return _CalendarDay(
          day: day,
          isStart: _isStart(day),
          isEnd: _isEnd(day),
          isInRange: _isInRange(day),
          isPast: _isPast(day),
          onTap: () => _onDayTap(day),
        );
      },
    );
  }

  Widget _buildFlexibleToggle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EDEC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDCBF),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.shuffle, color: Color(0xFF8C5000), size: 20),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flexible dates',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1B1B),
                  ),
                ),
                Text(
                  'Search ±2 days for better rates',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    color: Color(0xFF414755),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _flexibleDates,
            onChanged: (v) => setState(() => _flexibleDates = v),
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF8C5000),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFC1C6D7),
          ),
        ],
      ),
    );
  }

  Widget _buildInspirationCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 140,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0058BC).withOpacity(0.6),
                    const Color(0xFFFE9400).withOpacity(0.7),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xCC000000), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'PRO TIP',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Color(0xFFFFB874),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'June is perfect for coastal hiking in the Amalfi region.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 15,
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
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF9F8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Row(
        children: [
          // Cancel
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/home'),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBE7E7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF414755),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Next
          Expanded(
            flex: 2,
            child: _NextButton(
              enabled: _startDate != null && _endDate != null,
              onTap: () => context.go('/trip/new/details'),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Calendar Day ─────────────────────────────────────────────

class _CalendarDay extends StatefulWidget {
  final DateTime day;
  final bool isStart;
  final bool isEnd;
  final bool isInRange;
  final bool isPast;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.day,
    required this.isStart,
    required this.isEnd,
    required this.isInRange,
    required this.isPast,
    required this.onTap,
  });

  @override
  State<_CalendarDay> createState() => _CalendarDayState();
}

class _CalendarDayState extends State<_CalendarDay> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isStart || widget.isEnd;

    return GestureDetector(
      onTap: widget.isPast ? null : widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: Container(
          margin: const EdgeInsets.all(1),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF0058BC)
                : widget.isInRange
                    ? const Color(0xFFD8E2FF)
                    : _hovered && !widget.isPast
                        ? const Color(0xFFF6F3F2)
                        : Colors.transparent,
            shape: isSelected ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isSelected
                ? null
                : widget.isInRange
                    ? BorderRadius.zero
                    : BorderRadius.circular(99),
          ),
          child: Center(
            child: Text(
              '${widget.day.day}',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected
                    ? Colors.white
                    : widget.isPast
                        ? const Color(0xFFC1C6D7)
                        : widget.isInRange
                            ? const Color(0xFF0058BC)
                            : const Color(0xFF1C1B1B),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Calendar Nav Button ──────────────────────────────────────

class _CalNavBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CalNavBtn({required this.icon, required this.onTap});

  @override
  State<_CalNavBtn> createState() => _CalNavBtnState();
}

class _CalNavBtnState extends State<_CalNavBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered ? const Color(0xFFEBE7E7) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(widget.icon, color: const Color(0xFF1C1B1B), size: 22),
        ),
      ),
    );
  }
}

// ── Next Button ──────────────────────────────────────────────

class _NextButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _NextButton({required this.enabled, required this.onTap});

  @override
  State<_NextButton> createState() => _NextButtonState();
}

class _NextButtonState extends State<_NextButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onTap();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: AnimatedOpacity(
          opacity: widget.enabled ? 1.0 : 0.45,
          duration: const Duration(milliseconds: 200),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0058BC),
              borderRadius: BorderRadius.circular(12),
              boxShadow: widget.enabled
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0058BC).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
