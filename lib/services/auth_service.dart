import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? user;

  const AuthResult({
    required this.success,
    required this.message,
    this.user,
  });
}

class AuthService {
  static String get _baseUrl {
    if (kIsWeb) return 'http://localhost/attendance_api';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2/attendance_api';
    }
    return 'http://localhost/attendance_api';
  }

  static Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login.php'),
        body: {
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        return const AuthResult(
          success: false,
          message: 'Respuesta invalida del servidor.',
        );
      }

      final success = data['success'] == true ||
          data['status'] == 'success' ||
          data['estado'] == 'success';
      final message = (data['message'] ?? data['mensaje'] ?? '').toString();

      return AuthResult(
        success: response.statusCode == 200 && success,
        message: message,
        user: data['user'] is Map<String, dynamic>
            ? data['user'] as Map<String, dynamic>
            : null,
      );
    } on FormatException {
      return const AuthResult(
        success: false,
        message: 'El servidor no devolvio JSON valido.',
      );
    } catch (_) {
      return const AuthResult(
        success: false,
        message: 'Revisa que XAMPP y Apache esten encendidos.',
      );
    }
  }

  static Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register.php'),
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);
      if (data is! Map<String, dynamic>) {
        return const AuthResult(
          success: false,
          message: 'Respuesta invalida del servidor.',
        );
      }

      final success = data['success'] == true ||
          data['status'] == 'success' ||
          data['estado'] == 'success';
      final message = (data['message'] ?? data['mensaje'] ?? '').toString();

      return AuthResult(
        success: response.statusCode == 200 && success,
        message: message,
        user: data['user'] is Map<String, dynamic>
            ? data['user'] as Map<String, dynamic>
            : null,
      );
    } on FormatException {
      return const AuthResult(
        success: false,
        message: 'El servidor no devolvio JSON valido.',
      );
    } catch (_) {
      return const AuthResult(
        success: false,
        message: 'Revisa que XAMPP y Apache esten encendidos.',
      );
    }
  }
}
