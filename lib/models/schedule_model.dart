class ScheduleModel {
  final int id;

  final String name;

  final String startTime;
  final String endTime;

  final int requiredHours;

  final int toleranceMinutes;

  ScheduleModel({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.requiredHours,
    required this.toleranceMinutes,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "start_time": startTime,
      "end_time": endTime,
      "required_hours": requiredHours,
      "tolerance_minutes": toleranceMinutes,
    };
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json["id"],
      name: json["name"] ?? "",
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      requiredHours: json["required_hours"] ?? 8,
      toleranceMinutes: json["tolerance_minutes"] ?? 0,
    );
  }
}
