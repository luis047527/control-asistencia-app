import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/attendance/attendance_screen.dart';
import '../screens/history/history_screen.dart';
import '../screens/summary/summary_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/admin/users_screen.dart';
import '../screens/admin/reports_screen.dart';
import '../screens/admin/corrections_screen.dart';
import '../screens/admin/schedules_screen.dart';

class AppRoutes {
  static const splash = "/";
  static const login = "/login";
  static const home = "/home";
  static const attendance = "/attendance";
  static const history = "/history";
  static const summary = "/summary";
  static const profile = "/profile";
  static const admin = "/admin";
  static const users = "/users";
  static const reports = "/reports";
  static const corrections = "/corrections";
  static const schedules = "/schedules";

  static Map<String, WidgetBuilder> routes = {
    splash: (_) => const SplashScreen(),
    login: (_) => const LoginScreen(),
    home: (_) => const HomeScreen(),
    attendance: (_) => const AttendanceScreen(),
    history: (_) => const HistoryScreen(),
    summary: (_) => const SummaryScreen(),
    profile: (_) => const ProfileScreen(),
    admin: (_) => const AdminScreen(),
    users: (_) => const UsersScreen(),
    reports: (_) => const ReportsScreen(),
    corrections: (_) => const CorrectionsScreen(),
    schedules: (_) => const SchedulesScreen(),
  };
}
