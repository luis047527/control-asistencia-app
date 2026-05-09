import 'package:flutter/material.dart';
import '../shared/admin_bottom_nav.dart';
import '../shared/app_shell.dart';

class SchedulesScreen extends StatelessWidget {
  const SchedulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schedules = [
      _Schedule('Lunes a Viernes - Fijo', '09:00 - 18:00', '8h de jornada', 'Lun - Vie', '24 empleados', AppColors.green, Icons.schedule),
      _Schedule('Lunes a Viernes - Manana', '07:00 - 15:00', '8h de jornada', 'Lun - Vie', '12 empleados', AppColors.amber, Icons.schedule),
      _Schedule('Lunes a Viernes - Tarde', '13:00 - 21:00', '8h de jornada', 'Lun - Vie', '8 empleados', const Color(0xFF1976D2), Icons.schedule),
      _Schedule('Flexible - 8 horas', 'Flexible', 'Entrada 07:00 - 10:00', 'Lun - Vie', '3 empleados', const Color(0xFFD84A32), Icons.sync),
      _Schedule('Sabados - Medio dia', '08:00 - 13:00', '5h de jornada', 'Sabados', '0 empleados', Colors.grey, Icons.schedule),
      _Schedule('Lunes a Viernes - Corto', '10:00 - 16:00', '6h de jornada', 'Lun - Vie', '1 empleado', AppColors.brown, Icons.schedule),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, 18, AppSpacing.page, AppSpacing.bottomPadding),
          children: [
            const _Header(),
            const SizedBox(height: 16),
            const _Tabs(),
            const SizedBox(height: 16),
            const _MetricGrid(),
            const SizedBox(height: 14),
            const _SearchRow(),
            const SizedBox(height: 12),
            ...schedules.map((schedule) => _ScheduleCard(schedule: schedule)),
            const SizedBox(height: 12),
            const _RulesCard(),
            const SizedBox(height: 12),
            const _QuickAssignCard(),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(activeIndex: 4),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.arrow_back, size: 28), onPressed: () => Navigator.pushReplacementNamed(context, '/admin')),
        const SizedBox(width: 6),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Horarios', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              Text('Turnos y reglas', style: TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.brown, foregroundColor: Colors.white, minimumSize: const Size(44, 44), padding: EdgeInsets.zero),
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(5),
      decoration: _card(),
      child: Row(
        children: const [
          Expanded(child: _Tab(Icons.calendar_month_outlined, 'Horarios', true)),
          Expanded(child: _Tab(Icons.shield_outlined, 'Reglas', false)),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _Tab(this.icon, this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(color: active ? const Color(0xFFFFF1E8) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: active ? AppColors.brown : Colors.black54),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: active ? AppColors.brown : Colors.black54, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: _Metric(Icons.groups_outlined, '6', 'Activos', AppColors.green)),
            SizedBox(width: 10),
            Expanded(child: _Metric(Icons.schedule, '2', 'Flexibles', Color(0xFF1976D2))),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _Metric(Icons.calendar_month_outlined, '48', 'Asignados', AppColors.amber)),
            SizedBox(width: 10),
            Expanded(child: _Metric(Icons.bedtime_outlined, '0', 'Inactivos', Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _Metric(this.icon, this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(value, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(color: AppColors.muted)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: _soft(),
            child: const Row(children: [
              Icon(Icons.search),
              SizedBox(width: 10),
              Expanded(child: Text('Buscar horario...', style: TextStyle(color: AppColors.muted))),
            ]),
          ),
        ),
        const SizedBox(width: 10),
        Container(width: 52, height: 52, decoration: _soft(), child: const Icon(Icons.filter_alt_outlined)),
      ],
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final _Schedule schedule;

  const _ScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final active = !schedule.people.startsWith('0');
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundColor: schedule.color.withOpacity(0.12), child: Icon(schedule.icon, color: schedule.color)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(schedule.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _Pill(active ? 'Activo' : 'Inactivo', active ? AppColors.green : Colors.grey),
                  _Pill(schedule.time, AppColors.brown),
                  _Pill(schedule.days, AppColors.darkBrown),
                ],
              ),
              const SizedBox(height: 8),
              Text('${schedule.hours} • ${schedule.people}', style: const TextStyle(color: AppColors.muted)),
            ]),
          ),
          const Icon(Icons.more_vert, color: AppColors.darkBrown),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color color;

  const _Pill(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(color: color.withOpacity(0.10), borderRadius: BorderRadius.circular(14)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

class _RulesCard extends StatelessWidget {
  const _RulesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFF8F3), borderRadius: BorderRadius.circular(AppSpacing.radius)),
      child: Row(
        children: [
          const CircleAvatar(backgroundColor: Color(0xFFFFE2D1), child: Icon(Icons.lightbulb_outline, color: AppColors.brown)),
          const SizedBox(width: 12),
          const Expanded(child: Text('Los horarios son la base de tus registros')),
          OutlinedButton(onPressed: () {}, child: const Text('Reglas')),
        ],
      ),
    );
  }
}

class _QuickAssignCard extends StatelessWidget {
  const _QuickAssignCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEFF8EC), borderRadius: BorderRadius.circular(AppSpacing.radius)),
      child: const Row(
        children: [
          CircleAvatar(backgroundColor: Color(0xFFDCEFD8), child: Icon(Icons.groups_outlined, color: AppColors.green)),
          SizedBox(width: 12),
          Expanded(child: Text('Asignacion rapida\nAsigna empleados a horarios existentes')),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _Schedule {
  final String title;
  final String time;
  final String hours;
  final String days;
  final String people;
  final Color color;
  final IconData icon;

  const _Schedule(this.title, this.time, this.hours, this.days, this.people, this.color, this.icon);
}

BoxDecoration _card() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      border: Border.all(color: const Color(0xFFEEDFD8)),
    );

BoxDecoration _soft() => BoxDecoration(color: const Color(0xFFFBF5F1), borderRadius: BorderRadius.circular(14));
