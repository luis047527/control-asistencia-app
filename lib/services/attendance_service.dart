import 'dart:convert';

import 'package:http/http.dart' as http;

class AttendanceService {
  static const String registerUrl =
      'http://localhost/attendance_api/register_attendance.php';

  static const String todayAttendanceUrl =
      'http://localhost/attendance_api/get_today_attendance.php';

  static const String monthlyAttendanceUrl =
      'http://localhost/attendance_api/get_monthly_attendance.php';

  static const String historyUrl =
      'http://localhost/attendance_api/get_attendance_history.php';

  // =========================================
  // REGISTRAR ENTRADA / SALIDA
  // =========================================

  static Future<Map<String, dynamic>> registerAttendance(
    int userId,
  ) async {
    final response = await http.post(
      Uri.parse(registerUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================================
  // OBTENER ASISTENCIA DE HOY
  // =========================================

  static Future<Map<String, dynamic>> getTodayAttendance(
    int userId,
  ) async {
    final response = await http.post(
      Uri.parse(todayAttendanceUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================================
  // OBTENER ASISTENCIA MENSUAL
  // =========================================

  static Future<Map<String, dynamic>> getMonthlyAttendance({
    required int userId,
    required int year,
    required int month,
  }) async {
    final response = await http.post(
      Uri.parse(monthlyAttendanceUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'year': year,
        'month': month,
      }),
    );

    return jsonDecode(response.body);
  }

  // =========================================
  // OBTENER HISTORIAL POR RANGO
  // =========================================

  static Future<Map<String, dynamic>> getAttendanceHistory({
    required int userId,
    required String startDate,
    required String endDate,
  }) async {
    final response = await http.post(
      Uri.parse(historyUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'start_date': startDate,
        'end_date': endDate,
      }),
    );

    return jsonDecode(response.body);
  }
}
