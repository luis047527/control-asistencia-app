import 'package:flutter/material.dart';

import 'monthly_attendance_calendar.dart';

class MetricsSection extends StatelessWidget {
  final int? userId;

  const MetricsSection({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return MonthlyAttendanceCalendar(userId: userId);
  }
}
