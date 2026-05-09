import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../shared/app_shell.dart';
import '../shared/design_bottom_nav.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF7),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Perfil',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkBrown,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined, size: 34),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 22),
            const _ProfileHeader(),
            const SizedBox(height: 26),
            const _SectionTitle('INFORMACION LABORAL'),
            const SizedBox(height: 10),
            const _LaborInfoCard(),
            const SizedBox(height: 26),
            const _SectionTitle('CONFIGURACION'),
            const SizedBox(height: 10),
            const _InfoCard(
              children: [
                _InfoRow(Icons.notifications_none, 'Notificaciones', 'Activo',
                    isSwitch: true),
                _InfoRow(Icons.dark_mode_outlined, 'Tema', 'Claro'),
                _InfoRow(Icons.language, 'Idioma', 'Espanol'),
              ],
            ),
            const SizedBox(height: 26),
            const _SectionTitle('SOPORTE'),
            const SizedBox(height: 10),
            const _InfoCard(
              children: [
                _InfoRow(Icons.support_outlined, 'Reportar problema',
                    'Encontraste algun inconveniente?'),
                _InfoRow(Icons.headset_mic_outlined, 'Contactar administrador',
                    'Comunicate con el equipo de soporte'),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoutFooter(),
          DesignBottomNav(activeIndex: 3),
        ],
      ),
    );
  }
}

class _LaborInfoCard extends StatelessWidget {
  const _LaborInfoCard();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: SessionService.getRole(),
      builder: (context, snapshot) {
        final role = snapshot.data == 'admin' ? 'Administrador' : 'Empleado';

        return _InfoCard(
          children: [
            _InfoRow(Icons.calendar_month_outlined, 'Rol', role),
            const _InfoRow(
                Icons.schedule, 'Horario asignado', '09:00 AM - 06:00 PM'),
            const _InfoRow(Icons.sync, 'Tipo de horario', 'Fijo'),
            const _InfoRow(Icons.calendar_today_outlined, 'Dias laborales',
                'Lunes a Viernes'),
          ],
        );
      },
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: SessionService.getUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final name = (user?['name'] ?? 'Usuario').toString();
        final email = (user?['email'] ?? 'correo no disponible').toString();
        final role = (user?['role'] ?? 'employee').toString();
        final roleLabel = role == 'admin' ? 'Administrador' : 'Empleado';

        return Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: const Color(0xFFEEDFD8)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 58,
                backgroundColor: Color(0xFFE8D0C0),
                child: Icon(Icons.person, color: AppColors.brown, size: 64),
              ),
              const SizedBox(width: 22),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      roleLabel,
                      style: const TextStyle(
                        color: AppColors.brown,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.mail_outline, size: 20),
                        const SizedBox(width: 8),
                        Expanded(child: Text(email)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Chip(
                      label: Text('Miembro del equipo'),
                      backgroundColor: Color(0xFFFFEDE5),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.black54, size: 34),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black45,
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final List<Widget> children;

  const _InfoCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEEDFD8)),
      ),
      child: Column(
        children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(color: Color(0xFFEEDFD8), height: 1),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSwitch;

  const _InfoRow(
    this.icon,
    this.title,
    this.subtitle, {
    this.isSwitch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFFFFF1E8),
            child: Icon(icon, color: AppColors.darkBrown),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 16),
                ),
              ],
            ),
          ),
          if (isSwitch)
            Switch(value: true, onChanged: (_) {}, activeColor: AppColors.brown)
          else
            const Icon(Icons.chevron_right, color: Colors.black54),
        ],
      ),
    );
  }
}

class _LogoutFooter extends StatelessWidget {
  const _LogoutFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 10),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFAF7),
        border: Border(
          top: BorderSide(color: Color(0xFFEEDFD8)),
        ),
      ),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.red,
          side: const BorderSide(color: Color(0xFFE8A69E)),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: () => _confirmLogout(context),
        icon: const Icon(Icons.logout, size: 24),
        label: const Text(
          'Cerrar sesion',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Cerrar sesion'),
          content: const Text('Estas seguro de que quieres cerrar sesion?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancelar'),
            ),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesion'),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !context.mounted) return;

    await SessionService.logout();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
    }
  }
}
