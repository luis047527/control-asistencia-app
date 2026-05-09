import 'package:flutter/material.dart';
import 'dart:async';

import '../../services/session_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final logged = await SessionService.isLoggedIn();
    final remember = await SessionService.shouldRememberSession();
    final user = await SessionService.getUser();

    if (!mounted) return;

    if (!logged || !remember || user == null) {
      if (logged) {
        await SessionService.logout();
      }

      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        "/login",
      );

      return;
    }

    final role = await SessionService.getRole();

    if (!mounted) return;

    if (role == "admin") {
      Navigator.pushReplacementNamed(
        context,
        "/admin",
      );
      return;
    }

    final checked = await SessionService.hasCheckedIn();

    if (!mounted) return;

    if (!checked) {
      Navigator.pushReplacementNamed(
        context,
        "/attendance",
      );
    } else {
      Navigator.pushReplacementNamed(
        context,
        "/home",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/bg_splash.png",
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
