class UserModel {
  final int id;

  final String name;
  final String email;

  final String role;

  final bool active;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.active = true,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "active": active,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "employee",
      active: json["active"] ?? true,
    );
  }
}
