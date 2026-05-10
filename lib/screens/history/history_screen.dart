import 'package:flutter/material.dart';
import '../shared/app_shell.dart';
import '../shared/design_bottom_nav.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = [
      _HistoryRecord(
        day: 'Lunes',
        date: '20 May',
        entry: '09:02 AM',
        exit: '06:10 PM',
        total: '08h 08m',
        status: 'Completo',
        statusColor: AppColors.green,
        statusBg: const Color(0xFFE8F5E9),
        statusIcon: Icons.check_circle_outline,
      ),
      _HistoryRecord(
        day: 'Martes',
        date: '21 May',
        entry: '08:55 AM',
        exit: '06:05 PM',
        total: '08h 10m',
        status: 'Completo',
        statusColor: AppColors.green,
        statusBg: const Color(0xFFE8F5E9),
        statusIcon: Icons.check_circle_outline,
        highlightTotal: true,
      ),
      _HistoryRecord(
        day: 'Miercoles',
        date: '22 May',
        entry: '09:10 AM',
        exit: '06:00 PM',
        total: '07h 50m',
        status: 'Incompleto',
        statusColor: const Color(0xFFE27A22),
        statusBg: const Color(0xFFFFF1DF),
        statusIcon: Icons.schedule,
      ),
      _HistoryRecord(
        day: 'Jueves',
        date: '23 May',
        entry: '09:05 AM',
        exit: '06:15 PM',
        total: '08h 10m',
        status: 'Completo',
        statusColor: AppColors.green,
        statusBg: const Color(0xFFE8F5E9),
        statusIcon: Icons.check_circle_outline,
      ),
      _HistoryRecord(
        day: 'Viernes',
        date: '24 May',
        entry: '09:20 AM',
        exit: '06:30 PM',
        total: '07h 10m',
        status: 'Tardanza',
        statusColor: AppColors.red,
        statusBg: const Color(0xFFFFE2E3),
        statusIcon: Icons.error,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: Column(
          children: [

            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.page,
                14,
                AppSpacing.page,
                0,
              ),
              child: _Header(),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.page,
                  0,
                  AppSpacing.page,
                  AppSpacing.bottomPadding,
                ),
                children: [
            _ShellCard(
              child: Column(
                children: [
                  const _Tabs(),
                  const SizedBox(height: 16),
                  const _PeriodSelector(),
                  const SizedBox(height: 14),
                  ...records.map((record) => _RecordCard(record: record)),
                  const _NoRecordCard(day: 'Sabado', date: '25 May'),
                  const _NoRecordCard(day: 'Domingo', date: '26 May'),
                  const SizedBox(height: 8),
                  const _PeriodSummary(),
                  const SizedBox(height: 16),
                  const _CorrectionCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),
      bottomNavigationBar: const DesignBottomNav(activeIndex: 1),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        const Expanded(
          child: Text(
            'Historial',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.darkBrown,
            ),
          ),
        ),

        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppColors.brown.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.filter_alt_outlined,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }
}
class _ShellCard extends StatelessWidget {
  final Widget child;

  const _ShellCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(child: _TabItem(label: 'Hoy')),
        SizedBox(width: 8),
        Expanded(child: _TabItem(label: 'Semana', selected: true)),
        SizedBox(width: 8),
        Expanded(child: _TabItem(label: 'Mes')),
        SizedBox(width: 8),
        Expanded(
          child: _TabItem(
            label: 'Personalizado',
            trailing: Icons.calendar_month_outlined,
          ),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool selected;
  final IconData? trailing;

  const _TabItem({
    required this.label,
    this.selected = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFF6F3A28), Color(0xFF9B5B3D)],
              )
            : null,
        color: selected ? null : const Color(0xFFFBF5F1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: selected ? Colors.white : AppColors.darkBrown,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 5),
            Icon(
              trailing,
              size: 18,
              color: selected ? Colors.white : AppColors.brown,
            ),
          ],
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF5F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.calendar_month_outlined, color: AppColors.brown),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              '13 de mayo - 19 de mayo, 2024',
              style: TextStyle(fontSize: 16, color: AppColors.darkBrown),
            ),
          ),
          Icon(Icons.chevron_left, color: AppColors.darkBrown),
          SizedBox(width: 16),
          Icon(Icons.chevron_right, color: AppColors.darkBrown),
        ],
      ),
    );
  }
}

class _RecordCard extends StatelessWidget {
  final _HistoryRecord record;

  const _RecordCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${record.day} • ${record.date}',
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              _StatusBadge(record: record),
              const Icon(Icons.chevron_right, color: Colors.black54, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _TimeColumn(icon: Icons.schedule, iconColor: AppColors.green, label: 'Entrada', value: record.entry)),
              Expanded(child: _TimeColumn(icon: Icons.schedule, iconColor: AppColors.red, label: 'Salida', value: record.exit)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 12, color: AppColors.muted)),
                    const SizedBox(height: 8),
                    Text(
                      record.total,
                      style: TextStyle(
                        color: record.highlightTotal ? AppColors.brown : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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

class _TimeColumn extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _TimeColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _NoRecordCard extends StatelessWidget {
  final String day;
  final String date;

  const _NoRecordCard({required this.day, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('$day • $date', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
          const Text('No hay registros', style: TextStyle(color: AppColors.muted)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0ECEB),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.remove_circle_outline,
                    color: Colors.black54, size: 18),
                SizedBox(width: 6),
                Text('Sin registro', style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final _HistoryRecord record;

  const _StatusBadge({required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: record.statusBg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(record.statusIcon, color: record.statusColor, size: 17),
          const SizedBox(width: 5),
          Text(
            record.status,
            style: TextStyle(
              color: record.statusColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSummary extends StatelessWidget {
  const _PeriodSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Resumen del periodo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          SizedBox(height: 4),
          Text('(13 - 19 de mayo)', style: TextStyle(color: AppColors.muted)),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _SummaryBox(icon: Icons.schedule, iconColor: AppColors.green, label: 'Trabajadas', value: '39h 18m')),
              Expanded(child: _SummaryBox(icon: Icons.history, iconColor: Color(0xFFE27A22), label: 'Requeridas', value: '48h 00m')),
              Expanded(child: _SummaryBox(icon: Icons.trending_up, iconColor: AppColors.green, label: 'Balance', value: '+08h', valueColor: AppColors.green)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _SummaryBox({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: iconColor, size: 28),
        const SizedBox(height: 10),
        Text(label, textAlign: TextAlign.center),
        const SizedBox(height: 7),
        Text(
          value,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  const _CorrectionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8F3),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Color(0xFFFFE2D1),
            child: Icon(Icons.lightbulb_outline, color: AppColors.brown),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ves un error en tus registros?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text('Comunicate con tu administrador para solicitar una correccion.'),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.darkBrown),
        ],
      ),
    );
  }
}

class _VerticalLine extends StatelessWidget {
  final double height;

  const _VerticalLine({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: height, color: const Color(0xFFEEDFD8));
  }
}

class _HistoryRecord {
  final String day;
  final String date;
  final String entry;
  final String exit;
  final String total;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final IconData statusIcon;
  final bool highlightTotal;

  const _HistoryRecord({
    required this.day,
    required this.date,
    required this.entry,
    required this.exit,
    required this.total,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.statusIcon,
    this.highlightTotal = false,
  });
}

