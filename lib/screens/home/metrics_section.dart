import 'package:flutter/material.dart';

class MetricsSection extends StatelessWidget {
  const MetricsSection({super.key});

  static const _brown = Color(0xFF5D4037);
  static const _green = Color(0xFF2E7D32);
  static const _red = Color(0xFFC62828);
  static const _soft = Color(0xFFF3E6DD);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // =========================
        // RESUMEN DEL DIA
        // =========================
        const Text("Resumen del día",
            style: TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 10),

        _card([
          _metric(
            icon: Icons.access_time,
            label: "Horas requeridas",
            value: "8h 00m",
          ),
          _divider(),
          _metric(
            icon: Icons.work_outline,
            label: "Horas trabajadas",
            value: "04h 44m",
            color: _green,
          ),
        ]),

        const SizedBox(height: 10),

        _card([
          _metric(
            icon: Icons.trending_up,
            label: "Balance del día",
            value: "+04h 19m",
            color: _green,
            sub: "A tu favor",
          ),
        ]),

        const SizedBox(height: 20),

        // =========================
        // BALANCE GENERAL
        // =========================
        const Text("Balance general",
            style: TextStyle(fontWeight: FontWeight.bold)),

        const SizedBox(height: 10),

        _card([
          _metric(
            icon: Icons.trending_up,
            label: "Horas a favor",
            value: "+12h 30m",
            color: _green,
          ),
          _divider(),
          _metric(
            icon: Icons.history,
            label: "Horas en contra",
            value: "-02h 15m",
            color: _red,
          ),
        ]),

        const SizedBox(height: 10),

        _card([
          _metric(
            icon: Icons.balance,
            label: "Balance total",
            value: "+10h 15m",
          ),
        ]),
      ],
    );
  }

  // =========================
  // CARD CONTENEDOR
  // =========================
  Widget _card(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(children: children),
    );
  }

  // =========================
  // ITEM METRICA COMPLETO
  // =========================
  Widget _metric({
    required IconData icon,
    required String label,
    required String value,
    Color? color,
    String? sub,
  }) {
    return Expanded(
      child: Column(
        children: [

          // ICONO
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: _soft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: _brown),
          ),

          const SizedBox(height: 8),

          // LABEL COMPLETO
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),

          const SizedBox(height: 4),

          // VALOR
          Text(
            value,
            textAlign: TextAlign.center,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: color ?? Colors.black,
            ),
          ),

          // SUBTEXTO
          if (sub != null)
            Text(
              sub,
              style: const TextStyle(fontSize: 11),
            ),
        ],
      ),
    );
  }

  // =========================
  // DIVISOR VERTICAL
  // =========================
  Widget _divider() {
    return Container(
      width: 1,
      height: 60,
      color: Colors.grey.withOpacity(0.2),
    );
  }
}
