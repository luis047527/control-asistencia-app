import 'package:flutter/material.dart';
import '../shared/app_shell.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Hola, Ana',
      subtitle: 'Viernes, 24 de mayo de 2024',
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
        children: const [
          SizedBox(height: 6),
          _WorkingSessionCard(),
          SizedBox(height: 18),
          _DaySummarySection(),
          SizedBox(height: 18),
          _BalanceGeneralSection(),
          SizedBox(height: 18),
          _MotivationBanner(),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _WorkingSessionCard extends StatelessWidget {
  const _WorkingSessionCard();

  @override
  Widget build(BuildContext context) {
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
                  color: AppColors.green.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: AppColors.green,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.green.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'En jornada',
                        style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Estás trabajando',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Entrada: 09:00 AM',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.green.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time,
                  color: AppColors.green,
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
                  children: const [
                    Text('Tiempo trabajado', style: TextStyle(color: AppColors.muted)),
                    SizedBox(height: 8),
                    Text(
                      '03:41:32',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('horas', style: TextStyle(color: AppColors.muted)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text('Salida estimada', style: TextStyle(color: AppColors.muted)),
                    SizedBox(height: 8),
                    Text(
                      '06:00 PM',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text('Faltan 02:18:28', style: TextStyle(color: AppColors.muted)),
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

class _DaySummarySection extends StatelessWidget {
  const _DaySummarySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Resumen del día',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: _LargeStatCard(
                icon: Icons.schedule,
                label: 'Horas requeridas',
                value: '8h 00m',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _LargeStatCard(
                icon: Icons.work_outline,
                label: 'Horas trabajadas',
                value: '03h 41m',
                valueColor: AppColors.green,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _LargeStatCard(
                icon: Icons.trending_up,
                label: 'Balance del día',
                value: '+04h 19m',
                valueColor: AppColors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _BalanceGeneralSection extends StatelessWidget {
  const _BalanceGeneralSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Balance general',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        const SizedBox(height: 14),
        Row(
          children: const [
            Expanded(
              child: _MiniStatCard(
                icon: Icons.arrow_upward,
                label: 'Horas a favor',
                value: '+12h 30m',
                iconColor: AppColors.green,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _MiniStatCard(
                icon: Icons.arrow_downward,
                label: 'Horas en contra',
                value: '-02h 15m',
                iconColor: AppColors.red,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _MiniStatCard(
                icon: Icons.balance,
                label: 'Balance total',
                value: '+10h 15m',
                iconColor: AppColors.brown,
              ),
            ),
          ],
        ),
      ],
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
            child: const Icon(Icons.lightbulb_outline, color: AppColors.brown, size: 28),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              '¡Buen trabajo! Lleva una excelente semana. Mantén tu constancia.',
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
              icon: const Icon(Icons.chevron_right, color: AppColors.darkBrown, size: 20),
              onPressed: () => Navigator.pushNamed(context, '/summary'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LargeStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const _LargeStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor = AppColors.darkBrown,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 170),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.soft.withOpacity(0.7),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.brown, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.muted,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  const _MiniStatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 170),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.muted, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            maxLines: 1,
            softWrap: false,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}
