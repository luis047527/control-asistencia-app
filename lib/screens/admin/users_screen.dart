import 'package:flutter/material.dart';
import '../shared/admin_bottom_nav.dart';
import '../shared/app_shell.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      _User('Ana Rodriguez', 'ana.rodriguez@lumibelli.com', 'Fotografa', true, Icons.camera_alt_outlined),
      _User('Pedro Estrada', 'pedro.estrada@lumibelli.com', 'Editor', true, Icons.movie_creation_outlined),
      _User('Maria Lopez', 'maria.lopez@lumibelli.com', 'Asistente', true, Icons.person_outline),
      _User('Jorge Martinez', 'jorge.martinez@lumibelli.com', 'Videografo', true, Icons.videocam_outlined),
      _User('Lucia Gomez', 'lucia.gomez@lumibelli.com', 'Disenadora', true, Icons.brush_outlined),
      _User('Carlos Sanchez', 'carlos.sanchez@lumibelli.com', 'Asistente', false, Icons.person_outline),
      _User('Valeria Torres', 'valeria.torres@lumibelli.com', 'Maquillista', false, Icons.colorize_outlined),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(AppSpacing.page, 18, AppSpacing.page, AppSpacing.bottomPadding),
          children: [
            const _Header(),
            const SizedBox(height: 18),
            const _SearchAndFilters(),
            const SizedBox(height: 14),
            const _Tabs(),
            const SizedBox(height: 14),
            ...users.map((user) => _UserCard(user: user)),
            const SizedBox(height: 12),
            const _TeamControlCard(),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(activeIndex: 4, usersMode: true),
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
          onPressed: () => Navigator.pushReplacementNamed(context, '/admin'),
        ),
        const SizedBox(width: 8),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Usuarios', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 3),
              Text('Gestiona tu equipo', style: TextStyle(color: AppColors.muted)),
            ],
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brown,
            foregroundColor: Colors.white,
            minimumSize: const Size(44, 44),
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _SearchAndFilters extends StatelessWidget {
  const _SearchAndFilters();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: _softBox(),
            child: const Row(
              children: [
                Icon(Icons.search),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Buscar usuario...',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 52,
          height: 52,
          decoration: _softBox(),
          child: const Icon(Icons.filter_alt_outlined),
        ),
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
          _Tab('Todos (17)', true),
          _Tab('Activos (15)', false),
          _Tab('Inactivos (2)', false),
          _Tab('Roles', false),
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
      width: 112,
      margin: const EdgeInsets.only(right: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: active ? AppColors.brown : const Color(0xFFFBF5F1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final _User user;

  const _UserCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final color = user.active ? AppColors.green : AppColors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(AppSpacing.card),
      decoration: _cardBox(),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Color(0xFFE8D0C0),
            child: Icon(Icons.person, color: AppColors.brown, size: 34),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(user.email, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.muted)),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: const Color(0xFFFFF1E8),
                      child: Icon(user.icon, color: AppColors.darkBrown, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(user.role, overflow: TextOverflow.ellipsis)),
                    _StatusBadge(active: user.active, color: color),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.more_vert, color: AppColors.darkBrown),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;
  final Color color;

  const _StatusBadge({required this.active, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 9),
          const SizedBox(width: 6),
          Text(active ? 'Activo' : 'Inactivo', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}

class _TeamControlCard extends StatelessWidget {
  const _TeamControlCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: const Color(0xFFFFEFE5), borderRadius: BorderRadius.circular(AppSpacing.radius)),
      child: const Row(
        children: [
          CircleAvatar(radius: 28, backgroundColor: Color(0xFFE3BFA8), child: Icon(Icons.shield_outlined, color: Colors.white)),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Control total de tu equipo', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('Agrega, edita o desactiva usuarios y asigna roles.', style: TextStyle(color: AppColors.muted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _User {
  final String name;
  final String email;
  final String role;
  final bool active;
  final IconData icon;

  const _User(this.name, this.email, this.role, this.active, this.icon);
}

BoxDecoration _cardBox() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      border: Border.all(color: const Color(0xFFEEDFD8)),
    );

BoxDecoration _softBox() => BoxDecoration(
      color: const Color(0xFFFBF5F1),
      borderRadius: BorderRadius.circular(14),
    );
