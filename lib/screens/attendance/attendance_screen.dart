import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../services/attendance_service.dart';
import '../shared/app_shell.dart';

const int _requiredMinutesPerDay = 8 * 60;

bool _hasValue(dynamic value) {
  if (value == null) return false;
  if (value is String) return value.trim().isNotEmpty;
  return true;
}

DateTime? _parseBackendDateTime(dynamic value) {
  if (!_hasValue(value)) return null;
  final normalized = value.toString().trim().replaceFirst(' ', 'T');
  return DateTime.tryParse(normalized);
}

int _intFromBackend(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

String _formatBackendTime(BuildContext context, dynamic value) {
  final dateTime = _parseBackendDateTime(value);
  if (dateTime == null) return '--:--';
  return MaterialLocalizations.of(context).formatTimeOfDay(
    TimeOfDay.fromDateTime(dateTime),
    alwaysUse24HourFormat: false,
  );
}

String _formatDurationFromMinutes(int minutes, {bool showSign = false}) {
  final sign = minutes < 0 ? '-' : (showSign && minutes > 0 ? '+' : '');
  final absoluteMinutes = minutes.abs();
  final hours = absoluteMinutes ~/ 60;
  final remainingMinutes = absoluteMinutes % 60;
  return '$sign${hours.toString().padLeft(2, '0')}h '
      '${remainingMinutes.toString().padLeft(2, '0')}m';
}

class _StatusStyle {
  final String label;
  final Color badgeColor;
  final Color textColor;

  const _StatusStyle({
    required this.label,
    required this.badgeColor,
    required this.textColor,
  });
}

_StatusStyle _statusStyle(Map<String, dynamic>? attendanceData) {
  final status = attendanceData?["status"]?.toString().toLowerCase();
  final hasCheckIn = _hasValue(attendanceData?["check_in"]);
  final hasCheckOut = _hasValue(attendanceData?["check_out"]);

  if (status == "completed" || hasCheckOut) {
    return const _StatusStyle(
      label: 'Completado',
      badgeColor: Color(0xFFE6F4E8),
      textColor: AppColors.green,
    );
  }

  if (status == "pending") {
    return const _StatusStyle(
      label: 'Pendiente',
      badgeColor: Color(0xFFF1F1F1),
      textColor: Colors.grey,
    );
  }

  if (status == "in_progress" || status == "in progress" || hasCheckIn) {
    return const _StatusStyle(
      label: 'En progreso',
      badgeColor: Color(0xFFFFF4D6),
      textColor: AppColors.amber,
    );
  }

  return const _StatusStyle(
    label: 'Pendiente',
    badgeColor: Color(0xFFF1F1F1),
    textColor: Colors.grey,
  );
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Timer timer;
  DateTime now = DateTime.now();
  Map<String, dynamic>? attendanceData;

  bool get checkedIn => _hasValue(attendanceData?["check_in"]);

  bool get checkedOut =>
      _hasValue(attendanceData?["check_out"]) ||
      attendanceData?["status"]?.toString().toLowerCase() == "completed";

  @override
  void initState() {
    super.initState();
    _loadState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => now = DateTime.now());
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    _loadState();
  }

  Future<void> _loadState() async {
    try {
      final user = await SessionService.getUser();

      if (user == null) {
        if (!mounted) return;
        setState(() => attendanceData = null);
        return;
      }

      final int userId = int.parse(user["id"].toString());

      final response = await AttendanceService.getTodayAttendance(userId);
      final attendance = response["attendance"];

      if (!mounted) return;
      setState(() {
        attendanceData = attendance is Map
            ? Map<String, dynamic>.from(attendance)
            : null;
      });
    } catch (_) {
      if (!mounted) return;
      _showMessage('No se pudo cargar la asistencia de hoy');
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String get _period => now.hour >= 12 ? 'PM' : 'AM';

  String get _weekday {
    const weekdays = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return weekdays[now.weekday - 1];
  }

  String get _monthName {
    const months = [
      'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
      'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
    ];
    return months[now.month - 1];
  }

  String get _currentDate => '$_weekday, ${now.day} de $_monthName de ${now.year}';

  String get _time {
    int hour = now.hour > 12 ? now.hour - 12 : now.hour;
    hour = hour == 0 ? 12 : hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  String get _buttonTitle {
    if (!checkedIn) return 'MARCAR ENTRADA';
    if (!checkedOut) return 'MARCAR SALIDA';
    return 'JORNADA FINALIZADA';
  }

  String get _buttonSubtitle {
    if (!checkedIn) return 'Iniciar jornada laboral';
    if (!checkedOut) return 'Finalizar jornada laboral';
    return 'Registro completado';
  }

  IconData get _buttonIcon {
    if (!checkedIn) return Icons.login;
    if (!checkedOut) return Icons.logout;
    return Icons.check_circle_outline;
  }

  Future<void> _registerAttendance() async {
    try {
      final user = await SessionService.getUser();

      if (user == null) {
        _showMessage('Sesion no encontrada');
        return;
      }

      final int userId = int.parse(user["id"].toString());

      final response = await AttendanceService.registerAttendance(userId);

      final successValue = response["success"];
      final bool success =
          successValue == true || successValue?.toString() == "true";

      if (!success) {
        _showMessage(
          (response["message"] ?? 'No se pudo registrar la asistencia')
              .toString(),
        );
        return;
      }

      final String type = response["type"]?.toString() ?? "";

      if (type == "check_in") {
        await _loadState();
        _showMessage('Entrada registrada');
        return;
      }

      if (type == "check_out") {
        await _loadState();
        _showMessage('Salida registrada');
        return;
      }

      await _loadState();
      _showMessage('Asistencia actualizada');
    } catch (e) {
      _showMessage('Error de conexion');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(18, 16, 18, 0),
              child: _Header(),
            ),
            const SizedBox(height: 22),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 110),
                children: [
                  _MainAttendanceCard(
                    time: _time,
                    period: _period,
                    date: _currentDate,
                    buttonTitle: _buttonTitle,
                    buttonSubtitle: _buttonSubtitle,
                    buttonIcon: _buttonIcon,
                    checkedOut: checkedOut,
                    attendanceData: attendanceData,
                    onTap: _registerAttendance,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AttendanceBottomNav(),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text(
                'Registro de Asistencia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MainAttendanceCard extends StatelessWidget {
  final String time;
  final String period;
  final String date;
  final String buttonTitle;
  final String buttonSubtitle;
  final IconData buttonIcon;
  final bool checkedOut;
  final Map<String, dynamic>? attendanceData;
  final VoidCallback onTap;

  const _MainAttendanceCard({
    required this.time,
    required this.period,
    required this.date,
    required this.buttonTitle,
    required this.buttonSubtitle,
    required this.buttonIcon,
    required this.checkedOut,
    required this.onTap,
    required this.attendanceData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 26, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF0DDD4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, color: AppColors.darkBrown, size: 22),
              SizedBox(width: 8),
              Text(
                'Hora actual',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            time,
            style: const TextStyle(
              fontSize: 56,
              height: 0.95,
              fontWeight: FontWeight.w300,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            period,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Color(0xFFC7673D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            date,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 28),
          _RegisterButton(
            title: buttonTitle,
            subtitle: buttonSubtitle,
            icon: buttonIcon,
            disabled: checkedOut,
            onTap: onTap,
          ),
          const SizedBox(height: 28),
          const _LocationCard(),
          const SizedBox(height: 18),
          _DaySummary(
            checkedOut: checkedOut,
            attendanceData: attendanceData,
          ),
          const SizedBox(height: 18),
          _ReminderCard(checkedOut: checkedOut),
        ],
      ),
    );
  }
}

class _RegisterButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool disabled;
  final VoidCallback onTap;

  const _RegisterButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: disabled ? null : onTap,
          child: Container(
            width: 250,
            height: 250,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFFFE4D6),
              border: Border.all(color: Colors.white, width: 6),
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: disabled
                      ? [Colors.grey.shade600, Colors.grey.shade800]
                      : const [Color(0xFF9E563C), Color(0xFF4A2318)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brown.withOpacity(0.26),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.white, size: 64),
                  const SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: disabled ? Colors.grey.shade700 : AppColors.darkBrown,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _LocationCard extends StatelessWidget {
  const _LocationCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE2D1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: AppColors.darkBrown,
              size: 30,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubicacion detectada',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 3),
                Text('Av. Los Conquistadores 1234,\nSan Isidro, Lima'),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFE5F4E8),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: AppColors.green, size: 17),
                SizedBox(width: 5),
                Text(
                  'Valida',
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DaySummary extends StatelessWidget {
  final bool checkedOut;
  final Map<String, dynamic>? attendanceData;

  const _DaySummary({
    required this.checkedOut,
    required this.attendanceData,
  });

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(attendanceData);
    final workedMinutes = _intFromBackend(attendanceData?["worked_minutes"]);
    final balanceMinutes = workedMinutes - _requiredMinutesPerDay;
    final checkInTime = _formatBackendTime(context, attendanceData?["check_in"]);
    final checkOutTime =
        _formatBackendTime(context, attendanceData?["check_out"]);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bar_chart, color: AppColors.brown),
              SizedBox(width: 10),
              Text(
                'Resumen del dia',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.darkBrown,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF6F1),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFEEDFD8)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE2D1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.schedule,
                          color: AppColors.brown,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Jornada requerida',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: AppColors.darkBrown,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '8h 00m',
                              style: TextStyle(
                                fontSize: 20,
                                color: AppColors.brown,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _PremiumStatusRow(
                  icon: Icons.login,
                  title: 'Entrada registrada',
                  value: checkInTime,
                  badge: checkedOut ? 'Completado' : statusStyle.label,
                  badgeColor: checkedOut
                      ? const Color(0xFFE6F4E8)
                      : statusStyle.badgeColor,
                  textColor:
                      checkedOut ? AppColors.green : statusStyle.textColor,
                ),
                const Divider(
                  height: 1,
                  color: Color(0xFFEAD9D1),
                ),
                _PremiumStatusRow(
                  icon: Icons.logout,
                  title: 'Salida registrada',
                  value: checkOutTime,
                  badge: statusStyle.label,
                  badgeColor: statusStyle.badgeColor,
                  textColor: statusStyle.textColor,
                ),
                const Divider(
                  height: 1,
                  color: Color(0xFFEAD9D1),
                ),
                _DayStateRow(statusStyle: statusStyle),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: _SummaryMetric(
                  icon: Icons.work_outline,
                  label: 'Horas requeridas',
                  value: '8h 00m',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.timer_outlined,
                  label: 'Horas trabajadas',
                  value: _formatDurationFromMinutes(workedMinutes),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SummaryMetric(
                  icon: Icons.balance,
                  label: 'Balance del dia',
                  value: _formatDurationFromMinutes(
                    balanceMinutes,
                    showSign: true,
                  ),
                  color: balanceMinutes < 0 ? AppColors.red : AppColors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PremiumStatusRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String badge;
  final Color badgeColor;
  final Color textColor;

  const _PremiumStatusRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.badge,
    required this.badgeColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE2D1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.darkBrown,
              size: 28,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.darkBrown,
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    badge,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayStateRow extends StatelessWidget {
  final _StatusStyle statusStyle;

  const _DayStateRow({required this.statusStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFFFE2D1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.darkBrown,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Estado del dia',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: statusStyle.badgeColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.circle,
                  size: 10,
                  color: statusStyle.textColor,
                ),
                const SizedBox(width: 6),
                Text(
                  statusStyle.label,
                  style: TextStyle(
                    color: statusStyle.textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _SummaryMetric({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: Color(0xFFFFE2D1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.darkBrown),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color ?? Colors.black,
          ),
        ),
      ],
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final bool checkedOut;

  const _ReminderCard({required this.checkedOut});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD9C5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lightbulb_outline, color: AppColors.brown),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  checkedOut
                      ? 'Tu jornada fue registrada correctamente.'
                      : 'Recuerda marcar tu salida al finalizar tu jornada.',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tu registro es importante para el control de asistencia.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AttendanceBottomNav extends StatelessWidget {
  const _AttendanceBottomNav();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 82,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FooterItem(
            icon: Icons.home,
            label: 'Inicio',
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          _FooterItem(
            icon: Icons.receipt_long_outlined,
            label: 'Historial',
            onTap: () => Navigator.pushReplacementNamed(context, '/history'),
          ),
          const _RegisterNavItem(),
          _FooterItem(
            icon: Icons.bar_chart,
            label: 'Resumen',
            onTap: () => Navigator.pushReplacementNamed(context, '/summary'),
          ),
          _FooterItem(
            icon: Icons.person_outline,
            label: 'Perfil',
            onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FooterItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black54, size: 24),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _RegisterNavItem extends StatelessWidget {
  const _RegisterNavItem();

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -22),
      child: Container(
        width: 68,
        height: 68,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF6B3425), Color(0xFF3E2723)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, color: Colors.white, size: 27),
            SizedBox(height: 3),
            Text(
              'Registrar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

