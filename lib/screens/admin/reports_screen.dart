import 'package:flutter/material.dart';
import '../shared/admin_bottom_nav.dart';
import '../shared/app_shell.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = [
      _Employee('Ana Rodriguez', 'Fotografa', '09:18 AM', '8h 44m', 'Completo', AppColors.green),
      _Employee('Pedro Estrada', 'Editor', '09:07 AM', '8h 53m', 'Completo', AppColors.green),
      _Employee('Maria Lopez', 'Asistente', '08:58 AM', '9h 17m', 'Completo', AppColors.green),
      _Employee('Jorge Martinez', 'Videografo', '08:45 AM', '8h 55m', 'Tarde', AppColors.amber),
      _Employee('Carlos Sanchez', 'Asistente', '-', '0h 00m', 'Ausente', AppColors.red),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, 18, AppSpacing.page, AppSpacing.bottomPadding),
          children: [
            const _Header(),
            const SizedBox(height: 16),
            const _PeriodCard(),
            const SizedBox(height: 12),
            const _MetricsGrid(),
            const SizedBox(height: 12),
            const _ChartCard(),
            const SizedBox(height: 12),
            const Text('Detalle por empleado', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...employees.map((employee) => _EmployeeCard(employee: employee)),
            const SizedBox(height: 12),
            const Row(
              children: [
                Expanded(child: _ExportCard(Icons.table_chart, 'Excel', '.xlsx', AppColors.green)),
                SizedBox(width: 10),
                Expanded(child: _ExportCard(Icons.picture_as_pdf, 'PDF', '.pdf', AppColors.red)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(activeIndex: 3),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(icon: const Icon(Icons.menu, size: 30), onPressed: () => Navigator.pushReplacementNamed(context, '/admin')),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reportes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              Text('Asistencia del equipo', style: TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
        OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.upload, size: 18), label: const Text('Exportar')),
      ],
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Column(
        children: const [
          _FilterLine(Icons.calendar_month_outlined, 'Periodo', 'Este mes'),
          Divider(height: 20),
          Row(
            children: [
              Expanded(child: _MiniFilter(Icons.person_outline, 'Usuario')),
              SizedBox(width: 8),
              Expanded(child: _MiniFilter(Icons.filter_alt_outlined, 'Estado')),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterLine extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _FilterLine(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brown),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: AppColors.muted)),
        const Spacer(),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Icon(Icons.expand_more, color: AppColors.brown),
      ],
    );
  }
}

class _MiniFilter extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MiniFilter(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: _soft(),
      child: Row(
        children: [
          Icon(icon, color: AppColors.brown, size: 18),
          const SizedBox(width: 6),
          Expanded(child: Text(label, overflow: TextOverflow.ellipsis)),
          const Icon(Icons.expand_more, size: 18),
        ],
      ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: _Metric(Icons.schedule, 'Trabajadas', '1,248h', AppColors.green)),
            SizedBox(width: 10),
            Expanded(child: _Metric(Icons.track_changes, 'Requeridas', '1,200h', Color(0xFF1976D2))),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _Metric(Icons.bar_chart, 'Diferencia', '+48h', AppColors.amber)),
            SizedBox(width: 10),
            Expanded(child: _Metric(Icons.warning_amber, 'Tardanzas', '23', AppColors.red)),
          ],
        ),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _Metric(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.12), child: Icon(icon, color: color)),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    final values = [88, 110, 124, 116, 132, 105, 138];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _card(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Horas trabajadas por dia', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Total: 1,248h 35m', style: TextStyle(color: AppColors.brown, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values
                  .map(
                    (value) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('${value}h', style: const TextStyle(fontSize: 10)),
                            const SizedBox(height: 5),
                            Container(
                              height: value.toDouble(),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFFC7744F), Color(0xFF6B3425)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text('May', style: TextStyle(fontSize: 10, color: AppColors.muted)),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final _Employee employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          const CircleAvatar(radius: 26, backgroundColor: Color(0xFFE8D0C0), child: Icon(Icons.person, color: AppColors.brown)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(employee.role, style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 8),
                Text('${employee.entry}  |  ${employee.hours}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          _Badge(employee.status, employee.color),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(18)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }
}

class _ExportCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;
  final Color color;

  const _ExportCard(this.icon, this.title, this.sub, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.35))),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 10),
          Expanded(child: Text('$title\n$sub', style: TextStyle(color: color, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

class _Employee {
  final String name;
  final String role;
  final String entry;
  final String hours;
  final String status;
  final Color color;

  const _Employee(this.name, this.role, this.entry, this.hours, this.status, this.color);
}

BoxDecoration _card() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      border: Border.all(color: const Color(0xFFEEDFD8)),
    );

BoxDecoration _soft() => BoxDecoration(color: const Color(0xFFFBF5F1), borderRadius: BorderRadius.circular(12));
