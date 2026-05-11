import 'package:flutter/material.dart';

import '../../services/attendance_service.dart';

enum AttendanceStatus {
  complete,
  late,
  holiday,
  absence,
  vacation,
  permission,
  future,
  none,
}

class MonthlyAttendanceCalendar extends StatefulWidget {
  final int? userId;

  const MonthlyAttendanceCalendar({
    super.key,
    required this.userId,
  });

  @override
  State<MonthlyAttendanceCalendar> createState() =>
      _MonthlyAttendanceCalendarState();
}

class _MonthlyAttendanceCalendarState
    extends State<MonthlyAttendanceCalendar> {
  DateTime currentMonth = DateTime.now();
  Map<String, Map<String, dynamic>> _attendancesByDate = {};
  bool _loading = false;

  static const green = Color(0xFF2E7D32);
  static const orange = Color(0xFFE59A2E);
  static const holiday = Color(0xFFE27D7D);
  static const absence = Color(0xFF4E4E4E);
  static const vacation = Color(0xFF3D7DFF);
  static const permission = Color(0xFF8E5DCC);
  static const future = Color(0xFFE9DED8);

  final List<String> week = [
    'L',
    'M',
    'M',
    'J',
    'V',
    'S',
    'D',
  ];

  @override
  void initState() {
    super.initState();
    _loadMonth();
  }

  @override
  void didUpdateWidget(covariant MonthlyAttendanceCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      _loadMonth();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    _loadMonth();
  }

  Future<void> _loadMonth() async {
    final userId = widget.userId;
    final requestedYear = currentMonth.year;
    final requestedMonth = currentMonth.month;

    if (userId == null) {
      if (!mounted) return;
      setState(() {
        _attendancesByDate = {};
        _loading = false;
      });
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await AttendanceService.getMonthlyAttendance(
        userId: userId,
        year: requestedYear,
        month: requestedMonth,
      );

      final rawAttendances = response["attendances"];
      final nextAttendances = <String, Map<String, dynamic>>{};

      if (rawAttendances is List) {
        for (final item in rawAttendances) {
          if (item is! Map) continue;

          final attendance = Map<String, dynamic>.from(item);
          final date = attendance["attendance_date"]?.toString();

          if (date != null && date.isNotEmpty) {
            nextAttendances[date] = attendance;
          }
        }
      }

      if (!mounted ||
          widget.userId != userId ||
          currentMonth.year != requestedYear ||
          currentMonth.month != requestedMonth) {
        return;
      }

      setState(() {
        _attendancesByDate = nextAttendances;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Color statusColor(AttendanceStatus status) {
    switch (status) {
      case AttendanceStatus.complete:
        return green;
      case AttendanceStatus.late:
        return orange;
      case AttendanceStatus.holiday:
        return holiday;
      case AttendanceStatus.absence:
        return absence;
      case AttendanceStatus.vacation:
        return vacation;
      case AttendanceStatus.permission:
        return permission;
      case AttendanceStatus.future:
      case AttendanceStatus.none:
        return future;
    }
  }

  String monthName(int month) {
    const months = [
      '',
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];

    return months[month];
  }

  AttendanceStatus getStatus(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);

    if (normalizedDate.weekday == DateTime.sunday) {
      return AttendanceStatus.holiday;
    }

    if (widget.userId == null) {
      return normalizedDate.isAfter(normalizedToday)
          ? AttendanceStatus.future
          : AttendanceStatus.none;
    }

    final attendance = _attendancesByDate[_dateKey(normalizedDate)];

    if (attendance != null) {
      return _statusFromBackend(attendance);
    }

    if (normalizedDate.isAfter(normalizedToday)) {
      return AttendanceStatus.future;
    }

    if (normalizedDate.isBefore(normalizedToday)) {
      return AttendanceStatus.absence;
    }

    return AttendanceStatus.none;
  }

  AttendanceStatus _statusFromBackend(Map<String, dynamic> attendance) {
    final status = attendance["status"]?.toString().toLowerCase().trim();

    switch (status) {
      case 'completed':
      case 'complete':
      case 'working':
      case 'in_progress':
      case 'in progress':
        return AttendanceStatus.complete;
      case 'tardanza':
      case 'late':
        return AttendanceStatus.late;
      case 'feriado':
      case 'holiday':
        return AttendanceStatus.holiday;
      case 'falta':
      case 'absence':
        return AttendanceStatus.absence;
      case 'vacaciones':
      case 'vacation':
        return AttendanceStatus.vacation;
      case 'permiso':
      case 'permission':
        return AttendanceStatus.permission;
      default:
        return _hasCheckIn(attendance)
            ? AttendanceStatus.complete
            : AttendanceStatus.none;
    }
  }

  bool _hasCheckIn(Map<String, dynamic> attendance) {
    final value = attendance["check_in"];
    if (value == null) return false;
    return value.toString().trim().isNotEmpty;
  }

  String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  void previousMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month - 1,
      );
    });
    _loadMonth();
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
      );
    });
    _loadMonth();
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );

    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );

    final offset = firstDay.weekday - 1;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: previousMonth,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${monthName(currentMonth.month)} ${currentMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D1B16),
                  ),
                ),
              ),
              IconButton(
                onPressed: nextMonth,
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          if (_loading)
            const LinearProgressIndicator(
              minHeight: 2,
              color: green,
              backgroundColor: Color(0xFFF3E6DD),
            )
          else
            const SizedBox(height: 2),
          const SizedBox(height: 16),
          Row(
            children: week.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8D6E63),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: offset + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              if (index < offset) {
                return const SizedBox();
              }

              final day = index - offset + 1;
              final date = DateTime(
                currentMonth.year,
                currentMonth.month,
                day,
              );
              final status = getStatus(date);
              final color = statusColor(status);
              final isNeutral = status == AttendanceStatus.none ||
                  status == AttendanceStatus.future;
              final isToday = _isToday(date);

              return Container(
                decoration: BoxDecoration(
                  color: isNeutral
                      ? const Color(0xFFF6F2EF)
                      : color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isToday
                        ? const Color(0xFF3E2723)
                        : color.withOpacity(0.25),
                    width: isToday ? 2 : 1,
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isNeutral ? const Color(0xFFB7AAA4) : color,
                        ),
                      ),
                    ),
                    if (status == AttendanceStatus.vacation)
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(
                          Icons.beach_access,
                          size: 12,
                          color: vacation,
                        ),
                      ),
                    if (status == AttendanceStatus.permission)
                      const Positioned(
                        top: 6,
                        right: 6,
                        child: Icon(
                          Icons.event_available,
                          size: 12,
                          color: permission,
                        ),
                      ),
                    if (isToday)
                      const Positioned(
                        left: 0,
                        right: 0,
                        bottom: 5,
                        child: Icon(
                          Icons.circle,
                          size: 5,
                          color: Color(0xFF3E2723),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          const Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LegendItem(
                    color: green,
                    label: 'Completo',
                  ),
                  LegendItem(
                    color: orange,
                    label: 'Tardanza',
                  ),
                  LegendItem(
                    color: holiday,
                    label: 'Feriado',
                  ),
                ],
              ),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LegendItem(
                    color: absence,
                    label: 'Falta',
                  ),
                  LegendItem(
                    color: vacation,
                    label: 'Vacaciones',
                  ),
                  LegendItem(
                    color: permission,
                    label: 'Permiso',
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    super.key,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8D6E63),
          ),
        ),
      ],
    );
  }
}
