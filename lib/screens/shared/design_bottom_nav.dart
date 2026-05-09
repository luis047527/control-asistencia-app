import 'package:flutter/material.dart';
import 'app_shell.dart';

class DesignBottomNav extends StatelessWidget {
  final int activeIndex;

  const DesignBottomNav({super.key, required this.activeIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 82,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _FooterItem(
            icon: Icons.home_outlined,
            label: 'Inicio',
            active: activeIndex == 0,
            onTap: () => Navigator.pushReplacementNamed(context, '/home'),
          ),
          _FooterItem(
            icon: Icons.receipt_long_outlined,
            label: 'Historial',
            active: activeIndex == 1,
            onTap: () => Navigator.pushReplacementNamed(context, '/history'),
          ),
          _RegisterNavItem(
            onTap: () => Navigator.pushReplacementNamed(context, '/attendance'),
          ),
          _FooterItem(
            icon: Icons.bar_chart,
            label: 'Resumen',
            active: activeIndex == 2,
            onTap: () => Navigator.pushReplacementNamed(context, '/summary'),
          ),
          _FooterItem(
            icon: Icons.person_outline,
            label: 'Perfil',
            active: activeIndex == 3,
            onTap: () => Navigator.pushReplacementNamed(context, '/profile'),
          ),
        ],
      ),
    );
  }
}

class _FooterItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _FooterItem({
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
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RegisterNavItem extends StatelessWidget {
  final VoidCallback onTap;

  const _RegisterNavItem({required this.onTap});

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
              colors: [Color(0xFF6B3425), Color(0xFF3E2723)],
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
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.schedule, color: Colors.white, size: 27),
              SizedBox(height: 3),
              Text(
                'Registrar',
                style: TextStyle(
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
