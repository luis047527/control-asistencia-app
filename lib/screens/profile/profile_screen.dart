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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 112),
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
            const _InfoCard(
              children: [
                _InfoRow(Icons.calendar_month_outlined, 'Rol', 'Fotografa'),
                _InfoRow(Icons.schedule, 'Horario asignado', '09:00 AM - 06:00 PM'),
                _InfoRow(Icons.sync, 'Tipo de horario', 'Fijo'),
                _InfoRow(Icons.calendar_today_outlined, 'Dias laborales', 'Lunes a Viernes'),
              ],
            ),
            const SizedBox(height: 26),
            const _SectionTitle('CONFIGURACION'),
            const SizedBox(height: 10),
            const _InfoCard(
              children: [
                _InfoRow(Icons.notifications_none, 'Notificaciones', 'Activo', isSwitch: true),
                _InfoRow(Icons.dark_mode_outlined, 'Tema', 'Claro'),
                _InfoRow(Icons.language, 'Idioma', 'Espanol'),
              ],
            ),
            const SizedBox(height: 26),
            const _SectionTitle('SOPORTE'),
            const SizedBox(height: 10),
            const _InfoCard(
              children: [
                _InfoRow(Icons.support_outlined, 'Reportar problema', 'Encontraste algun inconveniente?'),
                _InfoRow(Icons.headset_mic_outlined, 'Contactar administrador', 'Comunicate con el equipo de soporte'),
              ],
            ),
            const SizedBox(height: 20),
            _LogoutButton(),
          ],
        ),
      ),
      bottomNavigationBar: const DesignBottomNav(activeIndex: 3),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ana Rodriguez',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Fotografa',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.mail_outline, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text('ana.rodriguez@lumibelli.com')),
                  ],
                ),
                SizedBox(height: 12),
                Chip(
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

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFF1E8),
        foregroundColor: const Color(0xFFC73322),
        elevation: 0,
        minimumSize: const Size(double.infinity, 62),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      onPressed: () async {
        await SessionService.logout();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
        }
      },
      icon: const Icon(Icons.logout, size: 28),
      label: const Text(
        'Cerrar sesion',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}
