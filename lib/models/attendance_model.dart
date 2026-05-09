enum AttendanceStatus {
  notStarted,
  inProgress,
  completed,
  incomplete,
}

class AttendanceModel {
  final int? id;

  final DateTime? checkIn;
  final DateTime? checkOut;

  final double? gpsInLat;
  final double? gpsInLng;

  final double? gpsOutLat;
  final double? gpsOutLng;

  final AttendanceStatus status;

  final int workedMinutes;

  AttendanceModel({
    this.id,
    this.checkIn,
    this.checkOut,
    this.gpsInLat,
    this.gpsInLng,
    this.gpsOutLat,
    this.gpsOutLng,
    required this.status,
    this.workedMinutes = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "check_in": checkIn?.toIso8601String(),
      "check_out": checkOut?.toIso8601String(),
      "gps_in_lat": gpsInLat,
      "gps_in_lng": gpsInLng,
      "gps_out_lat": gpsOutLat,
      "gps_out_lng": gpsOutLng,
      "status": status.name,
      "worked_minutes": workedMinutes,
    };
  }

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json["id"],
      checkIn: json["check_in"] != null
          ? DateTime.parse(json["check_in"])
          : null,
      checkOut: json["check_out"] != null
          ? DateTime.parse(json["check_out"])
          : null,
      gpsInLat: json["gps_in_lat"]?.toDouble(),
      gpsInLng: json["gps_in_lng"]?.toDouble(),
      gpsOutLat: json["gps_out_lat"]?.toDouble(),
      gpsOutLng: json["gps_out_lng"]?.toDouble(),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == json["status"],
        orElse: () => AttendanceStatus.notStarted,
      ),
      workedMinutes: json["worked_minutes"] ?? 0,
    );
  }
}
