import 'package:shared_preferences/shared_preferences.dart';

class SessionHelper {
  static Future<void> saveAdminSession({
    required int id,
    required String name,
    required String email,
    required String phone,
    required String picture,
    required String status,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('admin_id', id);
    await prefs.setString('admin_name', name);
    await prefs.setString('admin_email', email);
    await prefs.setString('admin_phone', phone);
    await prefs.setString('admin_picture', picture);
    await prefs.setString('admin_status', status);
    await prefs.setBool('is_logged_in', true);
  }

  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ✅ New Getter Methods for Session Values
  static Future<int?> getAdminId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('admin_id');
}

  static Future<String?> getAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_name');
  }

  static Future<String?> getAdminEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_email');
  }

  static Future<String?> getAdminPicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('admin_picture');
  }
}
