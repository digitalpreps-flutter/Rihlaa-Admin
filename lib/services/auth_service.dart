import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/admin_model.dart';

class AuthService {
  static const String baseUrl = "https://rihlaaapp.fr/api/";

  static Future<AdminLoginResponse?> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("${baseUrl}admin/login");
      final response = await http.post(url, body: {
        "login": email,
        "password": password,
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AdminLoginResponse.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print("Login error: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> signup(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse("${baseUrl}admin/signup");
      final response = await http.post(url, body: data);

      print("📡 Signup API Status: ${response.statusCode}");
      print("📡 Signup Response: ${response.body}");

      final Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return body;
      } else {
        return {
          "status": false,
          "message": body["message"] ?? "Something went wrong",
        };
      }
    } catch (e) {
      print("❌ Signup error: $e");
      return {"status": false, "message": "API error"};
    }
  }
}
