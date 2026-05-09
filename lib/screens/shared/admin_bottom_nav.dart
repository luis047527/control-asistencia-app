import 'package:flutter/material.dart';
import 'app_shell.dart';

class AdminBottomNav extends StatelessWidget {
  final int activeIndex;
  final bool usersMode;

  const AdminBottomNav({
    super.key,
    required this.activeIndex,
    this.usersMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 82,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Item(
            icon: Icons.home_outlined,
            label: 'Panel',
            active: activeIndex == 0,
            onTap: () => Navigator.pushReplacementNamed(context, '/admin'),
          ),
          _Item(
            icon: usersMode ? Icons.group_outlined : Icons.schedule,
            label: usersMode ? 'Usuarios' : 'Asistencia',
            active: activeIndex == 1,
            onTap: () => Navigator.pushReplacementNamed(
              context,
              usersMode ? '/users' : '/corrections',
            ),
          ),
          _ActionButton(
            label: usersMode ? 'Registrar' : 'Acciones',
            onTap: () => Navigator.pushReplacementNamed(context, '/corrections'),
          ),
          _Item(
            icon: Icons.bar_chart,
            label: 'Reportes',
            active: activeIndex == 3,
            onTap: () => Navigator.pushReplacementNamed(context, '/reports'),
          ),
          _Item(
            icon: Icons.settings_outlined,
            label: usersMode ? 'Usuarios' : 'Ajustes',
            active: activeIndex == 4,
            onTap: () => Navigator.pushReplacementNamed(
              context,
              usersMode ? '/users' : '/schedules',
            ),
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _Item({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.brown : Colors.black54;
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 58,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 25),
            const SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -22),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF8C4B2E), Color(0xFF4A2118)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.brown.withOpacity(0.28),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 31),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
