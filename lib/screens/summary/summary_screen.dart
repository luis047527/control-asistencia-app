import 'package:flutter/material.dart';
import '../shared/app_shell.dart';
import '../shared/design_bottom_nav.dart';

class SummaryScreen extends StatelessWidget {
  const SummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, 18, AppSpacing.page, AppSpacing.bottomPadding),
          children: const [
            _Header(),
            SizedBox(height: 26),
            _PeriodTabs(),
            SizedBox(height: 18),
            _BalanceCard(),
            SizedBox(height: 14),
            _ChartCard(),
            SizedBox(height: 14),
            _TotalsCard(),
            SizedBox(height: 14),
            _WeekResumeCard(),
            SizedBox(height: 14),
            _InsightCard(),
            SizedBox(height: 14),
            _HistoryLinkCard(),
          ],
        ),
      ),
      bottomNavigationBar: const DesignBottomNav(activeIndex: 2),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resumen',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkBrown,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Tu vision general de horas trabajadas',
                style: TextStyle(color: AppColors.muted, fontSize: 17),
              ),
            ],
          ),
        ),
        Container(
          width: 52,
          height: 52,
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
            Icons.calendar_month_outlined,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Row(
        children: const [
          Expanded(
            child: _SummaryTab(
              icon: Icons.calendar_month_outlined,
              label: 'Semana',
              selected: true,
            ),
          ),
          Expanded(
            child: _SummaryTab(
              icon: Icons.calendar_month_outlined,
              label: 'Mes',
            ),
          ),
          Expanded(
            child: _SummaryTab(
              icon: Icons.tune,
              label: 'Personalizado',
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _SummaryTab({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                colors: [Color(0xFF6F3A28), Color(0xFF9B5B3D)],
              )
            : null,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: selected ? Colors.white : AppColors.brown),
          const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFEFA),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            bottom: -18,
            child: Icon(
              Icons.local_florist_outlined,
              size: 132,
              color: AppColors.green.withOpacity(0.10),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Balance total de la semana',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Text(
                    '+10h 15m',
                    style: TextStyle(
                    fontSize: 40,
                      height: 0.95,
                      color: AppColors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.trending_up,
                    color: AppColors.green,
                    size: 34,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'A tu favor',
                  style: TextStyle(
                    color: AppColors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Estas cumpliendo con tus horas requeridas.',
                style: TextStyle(color: AppColors.muted, fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard();

  @override
  Widget build(BuildContext context) {
    final bars = [
      _BarData('Lun', '20', '8h 08m', 0.80, true),
      _BarData('Mar', '21', '8h 10m', 0.82, true),
      _BarData('Mie', '22', '7h 50m', 0.72, false),
      _BarData('Jue', '23', '8h 10m', 0.82, true),
      _BarData('Vie', '24', '7h 10m', 0.64, false),
      _BarData('Sab', '25', '0h', 0.03, false),
      _BarData('Dom', '26', '0h', 0.03, false),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Horas trabajadas por dia',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '- - -  Horas requeridas 8h',
                style: TextStyle(color: AppColors.muted),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 240,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _AxisLabel('10h'),
                      _AxisLabel('8h'),
                      _AxisLabel('6h'),
                      _AxisLabel('4h'),
                      _AxisLabel('2h'),
                      _AxisLabel('0h'),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: Container(
                          height: 1,
                          color: const Color(0xFFEABFAE),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 40,
                        child: Container(
                          height: 1,
                          color: const Color(0xFFEABFAE),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 80,
                        child: Container(
                          height: 1,
                          color: const Color(0xFFEABFAE),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 120,
                        child: Container(
                          height: 1,
                          color: const Color(0xFFEABFAE),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 160,
                        child: Container(
                          height: 1,
                          color: const Color(0xFFEABFAE),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 200,
                        child: Container(
                          height: 1,
                          color: const Color(0xFFEABFAE),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: bars
                              .map((bar) => Expanded(child: _ChartBar(data: bar)))
                              .toList(),
                        ),
                      ),
                    ],
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

class _ChartBar extends StatelessWidget {
  final _BarData data;

  const _ChartBar({required this.data});

  @override
  Widget build(BuildContext context) {
    final showBar = data.heightFactor > 0.05;
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            data.value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 6),
          Container(
            width: 34,
            height: showBar ? 150 * data.heightFactor : 2,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: data.strong
                    ? const [Color(0xFFC7744F), Color(0xFF6B3425)]
                    : const [Color(0xFFF7C8AD), Color(0xFFECA77D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${data.day} ${data.date}',
            textAlign: TextAlign.center,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

class _AxisLabel extends StatelessWidget {
  final String text;

  const _AxisLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: AppColors.muted));
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: const Column(
        children: [
          Row(
            children: [
              Expanded(child: _TotalItem(icon: Icons.schedule, iconBg: Color(0xFFE8F5E9), iconColor: AppColors.green, label: 'Trabajadas', value: '39h 18m', valueColor: AppColors.green, foot: 'Semana')),
              SizedBox(width: 10),
              Expanded(child: _TotalItem(icon: Icons.schedule, iconBg: Color(0xFFFFE8DB), iconColor: AppColors.darkBrown, label: 'Requeridas', value: '48h', foot: 'Meta')),
            ],
          ),
          SizedBox(height: 10),
          _TotalItem(icon: Icons.balance, iconBg: Color(0xFFE8F5E9), iconColor: AppColors.green, label: 'Diferencia', value: '+10h 15m', valueColor: AppColors.green, foot: 'A tu favor'),
        ],
      ),
    );
  }
}

class _TotalItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
  final String foot;

  const _TotalItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.foot,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: iconBg,
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 16),
          Text(label, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 10),
          Text(foot, style: const TextStyle(color: AppColors.muted)),
        ],
      ),
    );
  }
}

class _WeekResumeCard extends StatelessWidget {
  const _WeekResumeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Resumen de la semana',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(height: 22),
          Wrap(
            runSpacing: 14,
            children: [
              SizedBox(
                width: 145,
                child: _SmallResume(
                  icon: Icons.check_circle_outline,
                  iconBg: Color(0xFFE8F5E9),
                  iconColor: AppColors.green,
                  count: '4',
                  label: 'Dias completos\n(>= 8h)',
                ),
              ),
              SizedBox(
                width: 145,
                child: _SmallResume(
                  icon: Icons.schedule,
                  iconBg: Color(0xFFFFE8DB),
                  iconColor: AppColors.darkBrown,
                  count: '2',
                  label: 'Dias incompletos\n(< 8h)',
                ),
              ),
              SizedBox(
                width: 145,
                child: _SmallResume(
                  icon: Icons.error_outline,
                  iconBg: Color(0xFFFFE2E3),
                  iconColor: AppColors.red,
                  count: '1',
                  label: 'Tardanzas\n(> 15 min)',
                ),
              ),
              SizedBox(
                width: 145,
                child: _SmallResume(
                  icon: Icons.remove_circle_outline,
                  iconBg: Color(0xFFF0ECEB),
                  iconColor: Colors.black54,
                  count: '2',
                  label: 'Dias sin registro\n(0h)',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallResume extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String count;
  final String label;

  const _SmallResume({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: iconBg,
          child: Icon(icon, color: iconColor),
        ),
        const SizedBox(height: 10),
        Text(
          count,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Color(0xFFFFD9C5),
            child: Icon(Icons.lightbulb_outline, color: AppColors.brown),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sigue asi, vas por buen camino!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                ),
                SizedBox(height: 5),
                Text('Te faltan 2h para completar tus horas requeridas esta semana.'),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.darkBrown),
        ],
      ),
    );
  }
}

class _HistoryLinkCard extends StatelessWidget {
  const _HistoryLinkCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_outlined, color: AppColors.darkBrown),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Ver historial completo',
              style: TextStyle(fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => Navigator.pushReplacementNamed(context, '/history'),
          ),
        ],
      ),
    );
  }
}

class _CardLine extends StatelessWidget {
  const _CardLine();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 104, color: const Color(0xFFEEDFD8));
  }
}

class _BarData {
  final String day;
  final String date;
  final String value;
  final double heightFactor;
  final bool strong;

  const _BarData(
    this.day,
    this.date,
    this.value,
    this.heightFactor,
    this.strong,
  );
}
