import 'package:shared_preferences/shared_preferences.dart';

class SessionService {

  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLoggedIn", value);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  static Future<void> setCheckIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasCheckedIn", value);
  }

  static Future<void> setCheckOut(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("hasCheckedOut", value);
  }

  static Future<bool> hasCheckedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("hasCheckedIn") ?? false;
  }

  static Future<bool> hasCheckedOut() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("hasCheckedOut") ?? false;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
