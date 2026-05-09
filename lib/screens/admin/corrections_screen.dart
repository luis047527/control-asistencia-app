import 'package:flutter/material.dart';
import '../shared/admin_bottom_nav.dart';
import '../shared/app_shell.dart';

class CorrectionsScreen extends StatelessWidget {
  const CorrectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _Correction('Ana Rodriguez', 'Fotografa', '24 may 2024', 'Entrada', 'Pendiente', AppColors.amber),
      _Correction('Pedro Estrada', 'Editor', '23 may 2024', 'Salida', 'Pendiente', AppColors.amber),
      _Correction('Maria Lopez', 'Asistente', '22 may 2024', 'Entrada', 'Aprobada', AppColors.green),
      _Correction('Jorge Martinez', 'Videografo', '21 may 2024', 'Salida', 'Rechazada', AppColors.red),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, 18, AppSpacing.page, AppSpacing.bottomPadding),
          children: [
            const _Header(),
            const SizedBox(height: 16),
            const _SearchBar(),
            const SizedBox(height: 12),
            const _Tabs(),
            const SizedBox(height: 12),
            ...items.map((item) => _CorrectionCard(item: item)),
            const SizedBox(height: 14),
            const _DetailCard(),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(activeIndex: 2),
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
              Text('Correcciones', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              Text('Ajusta registros del equipo', style: TextStyle(color: AppColors.muted)),
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

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: _soft(),
            child: const Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Expanded(child: Text('Buscar usuario o fecha...', overflow: TextOverflow.ellipsis, style: TextStyle(color: AppColors.muted))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(width: 52, height: 52, decoration: _soft(), child: const Icon(Icons.calendar_month_outlined, color: AppColors.brown)),
      ],
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          _Tab('Pendientes (4)', true),
          _Tab('Aprobadas (12)', false),
          _Tab('Rechazadas (3)', false),
          _Tab('Filtros', false),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String text;
  final bool active;

  const _Tab(this.text, this.active);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 132,
      margin: const EdgeInsets.only(right: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(color: active ? AppColors.brown : const Color(0xFFFBF5F1), borderRadius: BorderRadius.circular(14)),
      child: Text(text, style: TextStyle(color: active ? Colors.white : Colors.black, fontWeight: FontWeight.bold)),
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  final _Correction item;

  const _CorrectionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(border: item.status == 'Pendiente' ? const Color(0xFFECA77D) : const Color(0xFFEEDFD8)),
      child: Row(
        children: [
          const CircleAvatar(radius: 28, backgroundColor: Color(0xFFE8D0C0), child: Icon(Icons.person, color: AppColors.brown)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(item.role, style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 8),
                Text(item.date, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _Badge(item.type, const Color(0xFFE87900)),
              const SizedBox(height: 6),
              _Badge(item.status, item.color),
            ],
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(radius: 34, backgroundColor: Color(0xFFE8D0C0), child: Icon(Icons.person, color: AppColors.brown, size: 38)),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ana Rodriguez', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                    Text('Fotografa', style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
              _Badge('Pendiente', AppColors.amber),
            ],
          ),
          const Divider(height: 28),
          const _CompareBox(title: 'Registro original', lines: ['Entrada  09:18 AM', 'Salida  06:02 PM', 'Horas  8h 44m']),
          const SizedBox(height: 12),
          const _CompareBox(title: 'Correccion solicitada', lines: ['Nueva entrada  08:45 AM', 'Nueva salida  06:02 PM', 'Horas  9h 17m']),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: _soft(),
            child: const Text('Motivo de la correccion\n\nTuve una reunion con un cliente y no pude registrar mi entrada a tiempo.'),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Rechazar'))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Aprobar'))),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompareBox extends StatelessWidget {
  final String title;
  final List<String> lines;

  const _CompareBox({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _soft(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ...lines.map((line) {
            final isHoursLine = line.startsWith('Horas');
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: isHoursLine ? 15 : 13,
                  fontWeight: isHoursLine ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(18)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

class _Correction {
  final String name;
  final String role;
  final String date;
  final String type;
  final String status;
  final Color color;

  const _Correction(this.name, this.role, this.date, this.type, this.status, this.color);
}

BoxDecoration _card({Color border = const Color(0xFFEEDFD8)}) => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      border: Border.all(color: border),
    );

BoxDecoration _soft() => BoxDecoration(color: const Color(0xFFFBF5F1), borderRadius: BorderRadius.circular(14));
