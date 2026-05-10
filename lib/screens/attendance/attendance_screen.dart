import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../shared/app_shell.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool checkedIn = false;
  bool checkedOut = false;
  late Timer timer;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => now = DateTime.now());
    });
  }

  Future<void> _loadState() async {
    final savedIn = await SessionService.hasCheckedIn();
    final savedOut = await SessionService.hasCheckedOut();
    if (mounted) {
      setState(() {
        checkedIn = savedIn;
        checkedOut = savedOut;
      });
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
    if (!checkedIn) {
      setState(() => checkedIn = true);
      await SessionService.setCheckIn(true);
      await SessionService.setCheckOut(false);
      _showMessage('Entrada registrada');
      return;
    }

    if (!checkedOut) {
      setState(() => checkedOut = true);
      await SessionService.setCheckOut(true);
      _showMessage('Salida registrada');
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
          _DaySummary(checkedOut: checkedOut),
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

  const _DaySummary({required this.checkedOut});

  @override
  Widget build(BuildContext context) {
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
                              'Horario asignado',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: AppColors.darkBrown,
                              ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              '09:00 AM - 06:00 PM',
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
                  value: '08:54 AM',
                  badge: 'Temprano',
                  badgeColor: Color(0xFFE6F4E8),
                  textColor: AppColors.green,
                ),

                const Divider(
                  height: 1,
                  color: Color(0xFFEAD9D1),
                ),

                _PremiumStatusRow(
                  icon: Icons.logout,
                  title: 'Salida registrada',
                  value: checkedOut ? '06:00 PM' : '--:--',
                  badge: checkedOut ? 'Completado' : 'Pendiente',
                  badgeColor: checkedOut
                      ? const Color(0xFFE6F4E8)
                      : const Color(0xFFF1F1F1),
                  textColor: checkedOut
                      ? AppColors.green
                      : Colors.grey,
                ),

                const Divider(
                  height: 1,
                  color: Color(0xFFEAD9D1),
                ),

                
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
                  value: checkedOut ? '08h 00m' : '00h 00m',
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _SummaryMetric(
                  icon: Icons.balance,
                  label: 'Balance del dia',
                  value: checkedOut ? '+00h 00m' : '00h 00m',
                  color: const Color(0xFFC7673D),
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

class _PremiumDayState extends StatelessWidget {
  const _PremiumDayState();

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
              color: const Color(0xFFE6F4E8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Icon(
                  Icons.circle,
                  size: 10,
                  color: AppColors.green,
                ),

                SizedBox(width: 6),

                Text(
                  'A tiempo',
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

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 104,
      color: const Color(0xFFEEDFD8),
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

