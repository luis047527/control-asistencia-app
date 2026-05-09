import 'package:flutter/material.dart';
import '../../services/session_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool remember = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg_login.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 210),
                  const Text(
                    'Control de Asistencia',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Ingresa para continuar',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 40, height: 1, color: Colors.brown.shade200),
                      const SizedBox(width: 6),
                      const CircleAvatar(radius: 3, backgroundColor: Colors.brown),
                      const SizedBox(width: 6),
                      Container(width: 40, height: 1, color: Colors.brown.shade200),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _label(Icons.email_outlined, 'Correo electronico'),
                  const SizedBox(height: 8),
                  _input('Ingresa tu correo electronico'),
                  const SizedBox(height: 20),
                  _label(Icons.lock_outline, 'Contrasena'),
                  const SizedBox(height: 8),
                  _inputPassword(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: remember,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => remember = value);
                          }
                        },
                      ),
                      const Text('Recordarme'),
                      const Spacer(),
                      Text(
                        'Olvidaste tu contrasena?',
                        style: TextStyle(color: Colors.orange.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6D4C41), Color(0xFF3E2723)],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () async {
                          await SessionService.setLoggedIn(true);
                          if (context.mounted) {
                            Navigator.pushReplacementNamed(context, '/attendance');
                          }
                        },
                        child: const Text(
                          'Iniciar sesion',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('o continua con'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.82),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.g_mobiledata, size: 28),
                        SizedBox(width: 10),
                        Text('Continuar con Google'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  RichText(
                    text: TextSpan(
                      text: 'No tienes cuenta? ',
                      style: const TextStyle(color: Colors.black54),
                      children: [
                        TextSpan(
                          text: 'Registrate',
                          style: TextStyle(color: Colors.orange.shade700),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E6DD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18),
        ),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  Widget _input(String hint) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _inputPassword() {
    return TextField(
      obscureText: obscurePassword,
      decoration: InputDecoration(
        hintText: 'Ingresa tu contrasena',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: IconButton(
          icon: Icon(obscurePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => obscurePassword = !obscurePassword),
        ),
      ),
    );
  }
}
