class AdminLoginResponse {
  final bool status;
  final String message;
  final Admin admin;

  AdminLoginResponse({
    required this.status,
    required this.message,
    required this.admin,
  });

  factory AdminLoginResponse.fromJson(Map<String, dynamic> json) {
    return AdminLoginResponse(
      status: json["status"] ?? false,
      message: json["message"] ?? "",
      admin: Admin.fromJson(json["admin"]),
    );
  }
}

class Admin {
  final int adminId;
  final String adminName;
  final String adminEmail;
  final String adminPhone;
  final String? adminCity;
  final String? adminDob;
  final String? adminPicture;
  final String status;

  Admin({
    required this.adminId,
    required this.adminName,
    required this.adminEmail,
    required this.adminPhone,
    required this.status,
    this.adminCity,
    this.adminDob,
    this.adminPicture,
  });

  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json["admin_id"],
      adminName: json["admin_name"],
      adminEmail: json["admin_email"],
      adminPhone: json["admin_phone"],
      adminCity: json["admin_city"],
      adminDob: json["admin_dob"],
      adminPicture: json["admin_picture"],
      status: json["status"],
    );
  }
}
