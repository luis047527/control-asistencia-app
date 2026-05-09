import '../../models/attendance_model.dart';

class AttendanceService {

  static AttendanceModel currentAttendance =
      AttendanceModel(
        status: AttendanceStatus.notStarted,
      );

  static AttendanceModel getCurrentAttendance() {
    return currentAttendance;
  }

  static void checkIn({
    required double lat,
    required double lng,
  }) {

    currentAttendance = AttendanceModel(
      checkIn: DateTime.now(),

      gpsInLat: lat,
      gpsInLng: lng,

      status: AttendanceStatus.inProgress,
    );
  }

  static void checkOut({
    required double lat,
    required double lng,
  }) {

    currentAttendance = AttendanceModel(
      checkIn: currentAttendance.checkIn,

      gpsInLat: currentAttendance.gpsInLat,
      gpsInLng: currentAttendance.gpsInLng,

      checkOut: DateTime.now(),

      gpsOutLat: lat,
      gpsOutLng: lng,

      status: AttendanceStatus.completed,

      workedMinutes:
          _calculateWorkedMinutes(),
    );
  }

  static int _calculateWorkedMinutes() {

    if (
      currentAttendance.checkIn == null
    ) {
      return 0;
    }

    final difference =
        DateTime.now().difference(
          currentAttendance.checkIn!,
        );

    return difference.inMinutes;
  }
}
