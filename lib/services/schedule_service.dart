import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';

class ScheduleService {
  static const String baseUrl = "https://rihlaaapp.fr/api/admin";

  // ───────────── Get Class Types ─────────────
  static Future<List<dynamic>> getClassTypes() async {
    try {
      final adminId = await SessionHelper.getAdminId();
      final response = await http.post(
        Uri.parse("$baseUrl/get-classes"),
        body: {
          "admin_id": adminId.toString(),
        },
      );

      print("📥 [getClassTypes] Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == true && decoded['classes'] != null) {
          return decoded['classes'];
        }
      }
      return [];
    } catch (e) {
      print("❌ [getClassTypes] Error: $e");
      return [];
    }
  }

  // ───────────── Get Subjects ─────────────
  static Future<List<dynamic>> getSubjects(String classId) async {
    try {
      final adminId = await SessionHelper.getAdminId();
      final response = await http.post(
        Uri.parse("$baseUrl/get-subjects"),
        body: {
          "admin_id": adminId.toString(),
          "class_id": classId,
        },
      );

      print("📥 [getSubjects] Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == true && decoded['subjects'] != null) {
          return decoded['subjects'];
        }
      }
      return [];
    } catch (e) {
      print("❌ [getSubjects] Error: $e");
      return [];
    }
  }

  // ───────────── Schedule Class ─────────────
  static Future<Map<String, dynamic>> scheduleClass({
    required String topicName,
    required String topicDescription,
    required String duration,
    required String date,
    required String time,
    required String subjectId,
    required String classTypeId,
  }) async {
    try {
      final adminId = await SessionHelper.getAdminId();
      final response = await http.post(
        Uri.parse("$baseUrl/schedule_class"),
        body: {
          "admin_id": adminId.toString(),
          "topic_name": topicName,
          "topic_description": topicDescription,
          "duration": duration,
          "date": date,
          "time": time,
          "subject_id": subjectId,
          "class_type_id": classTypeId,
        },
      );

      print("📤 [scheduleClass] Payload: ${{
        "admin_id": adminId,
        "topic_name": topicName,
        "topic_description": topicDescription,
        "duration": duration,
        "date": date,
        "time": time,
        "subject_id": subjectId,
        "class_type_id": classTypeId,
      }}");

      print("📥 [scheduleClass] Response: ${response.body}");

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"status": false, "message": "Server Error"};
      }
    } catch (e) {
      print("❌ [scheduleClass] Error: $e");
      return {"status": false, "message": "Exception: $e"};
    }
  }

  // ───────────── Join Class (API call) ─────────────
  static Future<String?> joinClass(int classId) async {
    try {
      final adminId = await SessionHelper.getAdminId();
      final response = await http.post(
        Uri.parse("$baseUrl/join_class"),
        body: {
          "admin_id": adminId.toString(),
          "class_id": classId.toString(),
        },
      );

      print("📤 [joinClass] Payload: admin_id=$adminId, class_id=$classId");
      print("📥 [joinClass] Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == true && decoded['zoom_link'] != null) {
          return decoded['zoom_link'];
        }
      }
      return null;
    } catch (e) {
      print("❌ [joinClass] Error: $e");
      return null;
    }
  }

  // ───────────── Get Scheduled Classes ─────────────
  static Future<List<dynamic>> getScheduledClasses() async {
    try {
      final adminId = await SessionHelper.getAdminId();
      final response = await http.post(
        Uri.parse("$baseUrl/get_schedule_class"),
        body: {
          "admin_id": adminId.toString(),
        },
      );

      print("📥 [getScheduledClasses] Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded['status'] == true && decoded['data'] != null) {
          return decoded['data'];
        }
      }
      return [];
    } catch (e) {
      print("❌ [getScheduledClasses] Error: $e");
      return [];
    }
  }
}
