import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizService {
  static const String baseUrl = 'https://rihlaaapp.fr/api/admin';

  // ✅ Get Classes
  static Future<List<Map<String, dynamic>>> getClasses(String adminId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-classes'),
      body: {'admin_id': adminId},
    );

    print('[QuizService.getClasses] Response: ${response.body}');

    final data = json.decode(response.body);
    if (data['status'] == true && data['classes'] != null) {
      return List<Map<String, dynamic>>.from(data['classes']);
    } else {
      return [];
    }
  }

  // ✅ Get Subjects based on Class
  static Future<List<Map<String, dynamic>>> getSubjects(int classId, String adminId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-subjects'),
      body: {
        'class_id': classId.toString(),
        'admin_id': adminId,
      },
    );

    print('[QuizService.getSubjects] Response: ${response.body}');

    final data = json.decode(response.body);
    if (data['status'] == true && data['subjects'] != null) {
      return List<Map<String, dynamic>>.from(data['subjects']);
    } else {
      return [];
    }
  }

  // ✅ Get Courses based on Subject
  static Future<List<Map<String, dynamic>>> getCourses(int subjectId, String adminId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-courses'),
      body: {
        'subject_id': subjectId.toString(),
        'admin_id': adminId,
      },
    );

    print('[QuizService.getCourses] Response: ${response.body}');

    final data = json.decode(response.body);
    if (data['status'] == true && data['courses'] != null) {
      return List<Map<String, dynamic>>.from(data['courses']);
    } else {
      return [];
    }
  }

  // ✅ Get Chapters based on Course
  static Future<List<Map<String, dynamic>>> getChapters(int courseId, String adminId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-chapters'),
      body: {
        'course_id': courseId.toString(),
        'admin_id': adminId,
      },
    );

    print('[QuizService.getChapters] Response: ${response.body}');

    final data = json.decode(response.body);
    if (data['status'] == true && data['chapters'] != null) {
      return List<Map<String, dynamic>>.from(data['chapters']);
    } else {
      return [];
    }
  }

  // ✅ Add Quiz
  static Future<bool> addQuiz({
    required String adminId,
    required String classId,
    required String subjectId,
    required String courseId,
    required String chapterId,
    required String quizTitle,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_quiz'),
      body: {
        'admin_id': adminId,
        'class_id': classId,
        'subject_id': subjectId,
        'course_id': courseId,
        'chapter_id': chapterId,
        'quiz_title': quizTitle,
      },
    );

    print('[QuizService.addQuiz] Status: ${response.statusCode}');
    print('[QuizService.addQuiz] Body: ${response.body}');

    final data = json.decode(response.body);
    return data['status'] == true;
  }
}
