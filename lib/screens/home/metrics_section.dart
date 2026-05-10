import 'package:flutter/material.dart';

class MetricsSection extends StatelessWidget {
  const MetricsSection({super.key});

  static const _green = Color(0xFF2E7D32);
  static const _orange = Color(0xFFE59A2E);
  static const _red = Color(0xFFC62828);
  static const _soft = Color(0xFFF3E6DD);
  static const _muted = Color(0xFF8D6E63);
  static const _brown = Color(0xFF5D4037);

  static const List<Map<String, dynamic>> _days = [
    {'status': 'success'},
    {'status': 'success'},
    {'status': 'late'},
    {'status': 'success'},
    {'status': 'danger'},
    {'status': 'none'},
    {'status': 'none'},
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'success':
        return _green;

      case 'late':
        return _orange;

      case 'danger':
        return _red;

      default:
        return const Color(0xFFE9DED8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const Expanded(
                child: Text(
                  'Asistencia mensual',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _brown,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: _soft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'Mayo',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _brown,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 31,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {

              final day = index + 1;

              String status = 'none';

              if (day <= 18) {
                status = _days[index % _days.length]['status'];
              }

              return Container(
                decoration: BoxDecoration(
                  color: _statusColor(status).withOpacity(
                    status == 'none' ? 0.35 : 0.15,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _statusColor(status).withOpacity(0.25),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: status == 'none'
                          ? _muted
                          : _statusColor(status),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 26),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              _LegendItem(
                color: _green,
                label: 'Completo',
              ),

              _LegendItem(
                color: _orange,
                label: 'Tardanza',
              ),

              _LegendItem(
                color: _red,
                label: 'Falta',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 8),

        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8D6E63),
          ),
        ),
      ],
    );
  }
}