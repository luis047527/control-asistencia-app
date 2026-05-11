import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/attendance_service.dart';
import '../../services/session_service.dart';
import 'monthly_attendance_calendar.dart';
import '../shared/app_shell.dart';

const int _requiredMinutesPerDay = 8 * 60;

bool _hasValue(dynamic value) {
  if (value == null) return false;
  if (value is String) return value.trim().isNotEmpty;
  return true;
}

DateTime? _parseBackendDateTime(dynamic value) {
  if (!_hasValue(value)) return null;
  return DateTime.tryParse(value.toString().trim().replaceFirst(' ', 'T'));
}

int _intFromBackend(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _formatTime(BuildContext context, DateTime? value) {
  if (value == null) return '--:--';
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(value),
    alwaysUse24HourFormat: false,
  );
}

String _formatClockDuration(Duration duration) {
  final seconds = duration.inSeconds < 0 ? 0 : duration.inSeconds;
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = seconds % 60;
  return '${hours.toString().padLeft(2, '0')}:'
      '${minutes.toString().padLeft(2, '0')}:'
      '${remainingSeconds.toString().padLeft(2, '0')}';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  DateTime _now = DateTime.now();
  Map<String, dynamic>? _user;
  Map<String, dynamic>? _attendanceData;

  int? get _userId {
    final id = _user?["id"];
    if (id == null) return null;
    return int.tryParse(id.toString());
  }

  String get _userName {
    final name = _user?["name"]?.toString().trim();
    if (name == null || name.isEmpty) return 'Usuario';
    return name.split(' ').first;
  }

  @override
  void initState() {
    super.initState();
    _loadHomeData();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final nextNow = DateTime.now();
      final dayChanged = nextNow.year != _now.year ||
          nextNow.month != _now.month ||
          nextNow.day != _now.day;

      if (!mounted) return;
      setState(() => _now = nextNow);

      if (dayChanged) {
        _loadHomeData();
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      final user = await SessionService.getUser();
      final userId = int.tryParse(user?["id"]?.toString() ?? '');

      if (user == null || userId == null) {
        if (!mounted) return;
        setState(() {
          _user = null;
          _attendanceData = null;
        });
        return;
      }

      final response = await AttendanceService.getTodayAttendance(userId);
      final attendance = response["attendance"];

      if (!mounted) return;
      setState(() {
        _user = user;
        _attendanceData = attendance is Map
            ? Map<String, dynamic>.from(attendance)
            : null;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cargar la asistencia de hoy'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hola, $_userName',
      subtitle: _currentDateLabel(_now),
      currentIndex: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          color: AppColors.darkBrown,
          onPressed: () {},
        ),
      ],
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
        children: [
          const SizedBox(height: 6),
          _WorkingSessionCard(
            attendanceData: _attendanceData,
            now: _now,
          ),
          const SizedBox(height: 18),
          MonthlyAttendanceCalendar(userId: _userId),
          const SizedBox(height: 18),
          const _MotivationBanner(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

String _currentDateLabel(DateTime date) {
  const weekdays = [
    'Lunes',
    'Martes',
    'Miercoles',
    'Jueves',
    'Viernes',
    'Sabado',
    'Domingo',
  ];
  const months = [
    'enero',
    'febrero',
    'marzo',
    'abril',
    'mayo',
    'junio',
    'julio',
    'agosto',
    'septiembre',
    'octubre',
    'noviembre',
    'diciembre',
  ];

  return '${weekdays[date.weekday - 1]}, ${date.day} de '
      '${months[date.month - 1]} de ${date.year}';
}

class _WorkingSessionCard extends StatelessWidget {
  final Map<String, dynamic>? attendanceData;
  final DateTime now;

  const _WorkingSessionCard({
    required this.attendanceData,
    required this.now,
  });

  bool get _hasCheckIn => _hasValue(attendanceData?["check_in"]);

  bool get _hasCheckOut =>
      _hasValue(attendanceData?["check_out"]) ||
      attendanceData?["status"]?.toString().toLowerCase() == "completed";

  DateTime? get _checkIn => _parseBackendDateTime(attendanceData?["check_in"]);

  DateTime? get _estimatedCheckOut {
    final checkIn = _checkIn;
    if (checkIn == null) return null;
    return checkIn.add(const Duration(minutes: _requiredMinutesPerDay));
  }

  Duration get _workedDuration {
    final completedMinutes = _intFromBackend(attendanceData?["worked_minutes"]);
    if (_hasCheckOut) {
      final checkIn = _checkIn;
      final checkOut = _parseBackendDateTime(attendanceData?["check_out"]);
      if (completedMinutes == 0 && checkIn != null && checkOut != null) {
        return checkOut.difference(checkIn);
      }

      return Duration(minutes: completedMinutes);
    }

    final checkIn = _checkIn;
    if (checkIn == null) return Duration.zero;
    return now.difference(checkIn);
  }

  Duration get _remainingDuration {
    final estimatedCheckOut = _estimatedCheckOut;
    if (!_hasCheckIn || _hasCheckOut || estimatedCheckOut == null) {
      return Duration.zero;
    }
    return estimatedCheckOut.difference(now);
  }

  String get _statusLabel {
    if (_hasCheckOut) return 'Completado';
    if (_hasCheckIn) return 'En jornada';
    return 'Pendiente';
  }

  String get _headline {
    if (_hasCheckOut) return 'Jornada completada';
    if (_hasCheckIn) return 'Estas trabajando';
    return 'Sin entrada registrada';
  }

  Color get _statusColor {
    if (_hasCheckOut || _hasCheckIn) return AppColors.green;
    return AppColors.amber;
  }

  @override
  Widget build(BuildContext context) {
    final entryTime = _formatTime(context, _checkIn);
    final estimatedExit = _formatTime(context, _estimatedCheckOut);
    final remainingText = _hasCheckOut
        ? 'Jornada finalizada'
        : _hasCheckIn
            ? 'Faltan ${_formatClockDuration(_remainingDuration)}'
            : 'Pendiente';

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.work_outline,
                  color: _statusColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _statusLabel,
                        style: TextStyle(
                          color: _statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _headline,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Entrada: $entryTime',
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.access_time,
                  color: _statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFEDE0D9)),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tiempo trabajado',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatClockDuration(_workedDuration),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'horas',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Salida estimada',
                      style: TextStyle(color: AppColors.muted),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      estimatedExit,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      remainingText,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MotivationBanner extends StatelessWidget {
  const _MotivationBanner();

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE7D8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.lightbulb_outline,
              color: AppColors.brown,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Buen trabajo. Tu asistencia se mantiene sincronizada.',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
            ),
          ),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.soft,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.chevron_right,
                color: AppColors.darkBrown,
                size: 20,
              ),
              onPressed: () => Navigator.pushNamed(context, '/summary'),
            ),
          ),
        ],
      ),
    );
  }
}
