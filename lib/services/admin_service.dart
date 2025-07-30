import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/session_helper.dart';

class AdminService {
  static Future<bool> updateProfile({
    required int id,
    required String name,
    required String base64Image,
  }) async {
    final url = Uri.parse('https://rihlaaapp.fr/api/admin/edit_profile');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "admin_id": id,
          "admin_name": name,
          "admin_picture": base64Image,
        }),
      );

      print("📡 Edit Profile Status: ${response.statusCode}");
      print("📡 Edit Profile Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        // ✅ Get the existing email from session and save updated values
        final email = await SessionHelper.getAdminEmail();  // Await the email fetch

        // ✅ Update session data with new values (only name and picture)
        await SessionHelper.saveAdminSession(
          id: id,
          name: data['data']['admin_name'] ?? '',
          email: email ?? '',  // Keep existing email
          phone: data['data']['admin_phone'] ?? '',
          picture: data['data']['admin_picture'] ?? '',
          status: data['data']['status'] ?? '',
        );

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("❌ Error updating profile: $e");
      return false;
    }
  }
}


