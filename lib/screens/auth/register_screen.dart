import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/session_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscurePassword = true;
  bool isLoading = false;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
                  const SizedBox(height: 180),
                  const Text(
                    'Crea tu cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3E2723),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Registra tus datos para continuar',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 28),
                  _label(Icons.person_outline, 'Nombre completo'),
                  const SizedBox(height: 8),
                  _input('Ingresa tu nombre', nameController),
                  const SizedBox(height: 18),
                  _label(Icons.email_outlined, 'Correo electronico'),
                  const SizedBox(height: 8),
                  _input('Ingresa tu correo electronico', emailController),
                  const SizedBox(height: 18),
                  _label(Icons.lock_outline, 'Contrasena'),
                  const SizedBox(height: 8),
                  _inputPassword(passwordController),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF6D4C41),
                            Color(0xFF3E2723),
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isLoading ? null : _register,
                        child: isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Registrarme',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextButton(
                    onPressed: isLoading ? null : () => Navigator.pop(context),
                    child: Text(
                      'Ya tengo cuenta',
                      style: TextStyle(color: Colors.orange.shade700),
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

  Future<void> _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage('Completa nombre, correo y contrasena.');
      return;
    }

    if (password.length < 6) {
      _showMessage('La contrasena debe tener al menos 6 caracteres.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await AuthService.register(
      name: name,
      email: email,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (!result.success || result.user == null) {
      _showMessage(
        result.message.isEmpty
            ? 'No se pudo completar el registro.'
            : result.message,
      );
      return;
    }

    await SessionService.saveSession(
      user: result.user!,
      remember: true,
    );

    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, '/attendance', (_) => false);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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

  Widget _input(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: hint.contains('correo')
          ? TextInputType.emailAddress
          : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _inputPassword(TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        hintText: 'Crea una contrasena',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscurePassword ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              obscurePassword = !obscurePassword;
            });
          },
        ),
      ),
    );
  }
}
