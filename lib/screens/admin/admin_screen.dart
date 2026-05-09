import 'package:flutter/material.dart';
import '../shared/admin_bottom_nav.dart';
import '../shared/app_shell.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final people = [
      _Person('Ana Rodriguez', 'Fotografa', 'Tarde', '09:18 AM', AppColors.amber, Icons.schedule),
      _Person('Pedro Estrada', 'Editor', 'Tarde', '09:07 AM', AppColors.amber, Icons.schedule),
      _Person('Maria Lopez', 'Asistente', 'Trabajando', '08:58 AM', AppColors.green, Icons.check_circle_outline),
      _Person('Jorge Martinez', 'Videografo', 'Trabajando', '08:45 AM', AppColors.green, Icons.check_circle_outline),
      _Person('Lucia Gomez', 'Disenadora', 'Trabajando', '08:50 AM', AppColors.green, Icons.check_circle_outline),
      _Person('Carlos Sanchez', 'Asistente', 'Ausente', '-', AppColors.red, Icons.person_off_outlined),
      _Person('Valeria Torres', 'Maquillista', 'Ausente', '-', AppColors.red, Icons.person_off_outlined),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, 18, AppSpacing.page, AppSpacing.bottomPadding),
          children: [
            const _Header(),
            const SizedBox(height: 16),
            const _MetricGrid(),
            const SizedBox(height: 12),
            const _AlertCard(),
            const SizedBox(height: 14),
            const _FilterChips(),
            const SizedBox(height: 18),
            const _SectionHeader(),
            const SizedBox(height: 10),
            ...people.map((person) => _PersonCard(person: person)),
            const SizedBox(height: 12),
            const _QuickActions(),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(activeIndex: 0),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.menu, size: 30),
          color: AppColors.darkBrown,
          onPressed: () => Navigator.pushNamed(context, '/users'),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Panel de control', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              Text('Viernes, 24 de mayo', style: TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
        Stack(
          children: const [
            Icon(Icons.notifications_none, size: 30, color: AppColors.darkBrown),
            Positioned(
              right: 0,
              child: CircleAvatar(
                radius: 9,
                backgroundColor: Color(0xFFE04A25),
                child: Text('3', style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ],
        ),
      ],
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
            Expanded(child: _Metric(Icons.groups_outlined, '12', 'Presentes', 'Ahora', AppColors.green)),
            SizedBox(width: 10),
            Expanded(child: _Metric(Icons.schedule, '3', 'Tardanzas', 'Hoy', Color(0xFFD88400))),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _Metric(Icons.person_off_outlined, '2', 'Ausentes', 'Hoy', AppColors.red)),
            SizedBox(width: 10),
            Expanded(child: _Metric(Icons.group_outlined, '17', 'Personal', 'Activos', AppColors.brown)),
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
  final String sub;
  final Color color;

  const _Metric(this.icon, this.value, this.label, this.sub, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          CircleAvatar(radius: 24, backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(sub, style: TextStyle(color: color, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: const Color(0xFFFFF0E8), borderRadius: BorderRadius.circular(AppSpacing.radius)),
      child: const Row(
        children: [
          CircleAvatar(backgroundColor: Color(0xFFFFD9C5), child: Icon(Icons.warning_amber, color: Color(0xFFD84A32))),
          SizedBox(width: 12),
          Expanded(child: Text('3 personas llegaron tarde\n2 personas aun no marcan entrada')),
          Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _Chip('Todos (17)', true),
          _Chip('Presentes (12)', false),
          _Chip('Tardanzas (3)', false),
          _Chip('Ausentes (2)', false),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  final bool active;

  const _Chip(this.text, this.active);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 124,
      margin: const EdgeInsets.only(right: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: active ? AppColors.brown : const Color(0xFFFBF5F1), borderRadius: BorderRadius.circular(14)),
      child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Text('Estado del equipo', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold))),
        Text('09:41 AM', style: TextStyle(color: AppColors.muted)),
        SizedBox(width: 6),
        Icon(Icons.refresh, color: AppColors.muted, size: 18),
      ],
    );
  }
}

class _PersonCard extends StatelessWidget {
  final _Person person;

  const _PersonCard({required this.person});

  @override
  Widget build(BuildContext context) {
    final isAbsent = person.status == 'Ausente';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          const CircleAvatar(radius: 28, backgroundColor: Color(0xFFE8D0C0), child: Icon(Icons.person, color: AppColors.brown)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(person.role, style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StatusChip(person.status, person.color, person.icon),
                    const Spacer(),
                    Text(isAbsent ? 'Sin entrada' : person.time, style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.darkBrown),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;

  const _StatusChip(this.text, this.color, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(18)),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 5),
          Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFFFF8F3), borderRadius: BorderRadius.circular(AppSpacing.radius)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Acciones rapidas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _Action(Icons.manage_search, 'Detalle')),
              Expanded(child: _Action(Icons.edit_outlined, 'Editar')),
              Expanded(child: _Action(Icons.chat_bubble_outline, 'Mensaje')),
            ],
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Action(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(backgroundColor: Color(0xFFFFE2D1), child: Icon(icon, color: AppColors.brown)),
        SizedBox(height: 8),
        Text(text),
      ],
    );
  }
}

class _Person {
  final String name;
  final String role;
  final String status;
  final String time;
  final Color color;
  final IconData icon;

  const _Person(this.name, this.role, this.status, this.time, this.color, this.icon);
}

BoxDecoration _card() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      border: Border.all(color: const Color(0xFFEEDFD8)),
    );
