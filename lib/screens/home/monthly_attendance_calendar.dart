import 'package:flutter/material.dart';

enum AttendanceStatus {
  complete,
  late,
  holiday,
  absence,
  vacation,
  permission,
  none,
}

class MonthlyAttendanceCalendar extends StatefulWidget {
  const MonthlyAttendanceCalendar({super.key});

  @override
  State<MonthlyAttendanceCalendar> createState() =>
      _MonthlyAttendanceCalendarState();
}

class _MonthlyAttendanceCalendarState
    extends State<MonthlyAttendanceCalendar> {

  DateTime currentMonth = DateTime.now();

  static const green = Color(0xFF2E7D32);
  static const orange = Color(0xFFE59A2E);
  static const holiday = Color(0xFFE27D7D);
  static const absence = Color(0xFF4E4E4E);
  static const vacation = Color(0xFF3D7DFF);
  static const permission = Color(0xFF8E5DCC);

  final List<String> week = [
    'L',
    'M',
    'M',
    'J',
    'V',
    'S',
    'D',
  ];

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

      default:
        return const Color(0xFFE9DED8);
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

  AttendanceStatus getStatus(int day) {

    if (day == 5 || day == 6 || day == 7 || day == 30) {
      return AttendanceStatus.holiday;
    }

    if (day == 3 || day == 12 || day == 24) {
      return AttendanceStatus.late;
    }

    if (day == 10 || day == 25) {
      return AttendanceStatus.absence;
    }

    if (day == 18 || day == 19) {
      return AttendanceStatus.vacation;
    }

    if (day == 20 || day == 27) {
      return AttendanceStatus.permission;
    }

    if (day <= 28) {
      return AttendanceStatus.complete;
    }

    return AttendanceStatus.none;
  }

  void previousMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month - 1,
      );
    });
  }

  void nextMonth() {
    setState(() {
      currentMonth = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
      );
    });
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

          const SizedBox(height: 18),

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
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {

              if (index < offset) {
                return const SizedBox();
              }

              final day = index - offset + 1;

              final status = getStatus(day);

              final color = statusColor(status);

              return Container(
                decoration: BoxDecoration(
                  color: status == AttendanceStatus.none
                      ? const Color(0xFFF6F2EF)
                      : color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: color.withOpacity(0.25),
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
                          color: status == AttendanceStatus.none
                              ? const Color(0xFFB7AAA4)
                              : color,
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
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [

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
                children: const [

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
