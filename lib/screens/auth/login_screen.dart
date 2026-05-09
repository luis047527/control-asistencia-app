import 'package:flutter/material.dart';

import '../../services/auth_service.dart';
import '../../services/session_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscurePassword = true;
  bool remember = true;
  bool isLoading = false;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
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
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.brown.shade200,
                      ),
                      const SizedBox(width: 6),
                      const CircleAvatar(
                        radius: 3,
                        backgroundColor: Colors.brown,
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 40,
                        height: 1,
                        color: Colors.brown.shade200,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _label(
                    Icons.email_outlined,
                    'Correo electronico',
                  ),
                  const SizedBox(height: 8),
                  _input(
                    'Ingresa tu correo electronico',
                    emailController,
                  ),
                  const SizedBox(height: 20),
                  _label(
                    Icons.lock_outline,
                    'Contrasena',
                  ),
                  const SizedBox(height: 8),
                  _inputPassword(
                    passwordController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Checkbox(
                        value: remember,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              remember = value;
                            });
                          }
                        },
                      ),
                      const Text('Recordarme'),
                      const Spacer(),
                      Text(
                        'Olvidaste tu contrasena?',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                        ),
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
                        onPressed: isLoading ? null : _login,
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
                                'Iniciar sesion',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: const [
                      Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('o continua con'),
                      ),
                      Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => _showMessage(
                      'Google necesita configuracion de Firebase/OAuth antes de activarse.',
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.orange.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.g_mobiledata,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text('Continuar con Google'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No tienes cuenta? ',
                        style: TextStyle(color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/register'),
                        child: Text(
                          'Registrate',
                          style: TextStyle(
                            color: Colors.orange.shade700,
                          ),
                        ),
                      ),
                    ],
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

  Future<void> _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage('Ingresa tu correo y contrasena.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    final result = await AuthService.login(
      email: email,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (!result.success || result.user == null) {
      await SessionService.setLoggedIn(false);
      _showMessage(
        result.message.isEmpty
            ? 'Correo o contrasena incorrectos.'
            : result.message,
      );
      return;
    }

    await SessionService.saveSession(
      user: result.user!,
      remember: remember,
    );

    if (!mounted) return;

    final role = (result.user!['role'] ?? 'employee').toString();
    Navigator.pushReplacementNamed(
      context,
      role == 'admin' ? '/admin' : '/attendance',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _label(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E6DD),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(text),
      ],
    );
  }

  Widget _input(
    String hint,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
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

  Widget _inputPassword(
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      obscureText: obscurePassword,
      decoration: InputDecoration(
        hintText: 'Ingresa tu contrasena',
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
