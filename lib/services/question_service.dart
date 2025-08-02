import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';

class QuestionService {
  static const String baseUrl = 'https://rihlaaapp.fr/api/admin';

  // ✅ Get Quiz List (POST with admin_id)
  static Future<List<Map<String, dynamic>>> getQuizList(String adminId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/quiz_list'),
        body: {'admin_id': adminId},
      );

      print('[getQuizList] Response: ${response.body}');

      final data = json.decode(response.body);

      if (data['status'] == true && data['Quiz'] != null) {
        return List<Map<String, dynamic>>.from(data['Quiz']);
      } else {
        return [];
      }
    } catch (e) {
      print('[getQuizList] Error: $e');
      return [];
    }
  }

  // ✅ Add Questions to Quiz (admin_id fetched from SessionHelper)
  static Future<bool> addQuestions({
    required int quizId,
    required List<Map<String, String>> questions,
  }) async {
    try {
      final adminId = await SessionHelper.getAdminId();
      if (adminId == null) return false;

      final response = await http.post(
        Uri.parse('$baseUrl/add_questions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'quiz_id': quizId,
          'admin_id': adminId,
          'questions': questions,
        }),
      );

      print('[addQuestions] Status: ${response.statusCode}');
      print('[addQuestions] Body: ${response.body}');

      final data = json.decode(response.body);
      return data['status'] == true;
    } catch (e) {
      print('[addQuestions] Error: $e');
      return false;
    }
  }
}
