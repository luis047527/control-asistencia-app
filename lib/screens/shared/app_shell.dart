import 'package:flutter/material.dart';

class AppColors {
  static const brown = Color(0xFF5D4037);
  static const darkBrown = Color(0xFF3E2723);
  static const muted = Color(0xFF8D6E63);
  static const green = Color(0xFF2E7D32);
  static const red = Color(0xFFC62828);
  static const amber = Color(0xFFF9A825);
  static const soft = Color(0xFFF3E6DD);
  static const bg = Color(0xFFF4E7DE);
}

class AppSpacing {
  static const page = 16.0;
  static const card = 14.0;
  static const gap = 12.0;
  static const radius = 16.0;
  static const bottomPadding = 104.0;
}

class AppScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final int currentIndex;
  final List<Widget>? actions;

  const AppScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.child,
    required this.currentIndex,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.bg, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.menu),
                      color: AppColors.darkBrown,
                      onPressed: () =>
                          Navigator.pushNamed(context, '/admin'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkBrown,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ),
                    ...?actions,
                  ],
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brown,
        onPressed: () => Navigator.pushNamed(context, '/attendance'),
        child: const Icon(Icons.access_time, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        height: 82,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Inicio',
              active: currentIndex == 0,
              route: '/home',
            ),
            _NavItem(
              icon: Icons.history,
              label: 'Historial',
              active: currentIndex == 1,
              route: '/history',
            ),
            const SizedBox(width: 46),
            _NavItem(
              icon: Icons.bar_chart,
              label: 'Resumen',
              active: currentIndex == 2,
              route: '/summary',
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: 'Perfil',
              active: currentIndex == 3,
              route: '/profile',
            ),
          ],
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const StatCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? AppColors.brown),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color ?? AppColors.darkBrown,
            ),
          ),
        ],
      ),
    );
  }
}

class SectionCard extends StatelessWidget {
  final Widget child;

  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final String route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        final current = ModalRoute.of(context)?.settings.name;
        if (current != route) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 25,
              color: active ? AppColors.brown : Colors.black45,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: active ? AppColors.brown : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
