import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const _isLoggedInKey = "isLoggedIn";
  static const _hasCheckedInKey = "hasCheckedIn";
  static const _hasCheckedOutKey = "hasCheckedOut";
  static const _userKey = "currentUser";
  static const _rememberKey = "rememberSession";

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  static Future<void> setCheckIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCheckedInKey, value);
  }

  static Future<void> setCheckOut(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_hasCheckedOutKey, value);
  }

  static Future<bool> hasCheckedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCheckedInKey) ?? false;
  }

  static Future<bool> hasCheckedOut() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_hasCheckedOutKey) ?? false;
  }

  static Future<void> saveSession({
    required Map<String, dynamic> user,
    required bool remember,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setBool(_rememberKey, remember);
    await prefs.setString(_userKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final rawUser = prefs.getString(_userKey);
    if (rawUser == null || rawUser.isEmpty) return null;

    try {
      final decoded = jsonDecode(rawUser);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<String> getRole() async {
    final user = await getUser();
    return (user?["role"] ?? "employee").toString();
  }

  static Future<bool> isAdmin() async {
    return await getRole() == "admin";
  }

  static Future<bool> shouldRememberSession() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberKey) ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLoggedInKey);
    await prefs.remove(_rememberKey);
    await prefs.remove(_userKey);
    await prefs.remove(_hasCheckedInKey);
    await prefs.remove(_hasCheckedOutKey);
  }
}
