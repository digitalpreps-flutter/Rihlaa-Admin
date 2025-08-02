import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class LectureService {
  static const String baseUrl = 'https://rihlaaapp.fr/api/admin';

  // ✅ Get Classes
  static Future<List<Map<String, dynamic>>> getClasses(String adminId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/get-classes'),
      body: {'admin_id': adminId},
    );

    print('[getClasses] Response: ${response.body}');

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

    print('[getSubjects] Response: ${response.body}');

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

    print('[getCourses] Response: ${response.body}');

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

    print('[getChapters] Response: ${response.body}');

    final data = json.decode(response.body);
    if (data['status'] == true && data['chapters'] != null) {
      return List<Map<String, dynamic>>.from(data['chapters']);
    } else {
      return [];
    }
  }

  // ✅ Upload Lecture (with video + optional PDF)
  static Future<bool> uploadLecture({
    required String adminId,
    required String lectureTitle,
    required String lectureDescription,
    required String classId,
    required String subjectId,
    required String courseId,
    required String chapterId,
    required File videoFile,
    File? pdfFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload_lecture'),
      );

      // Required fields
      request.fields['admin_id'] = adminId;
      request.fields['lecture_title'] = lectureTitle;
      request.fields['lecture_description'] = lectureDescription;
      request.fields['class_id'] = classId;
      request.fields['subject_id'] = subjectId;
      request.fields['course_id'] = courseId;
      request.fields['chapter_id'] = chapterId;

      // Required: Lecture video file
      request.files.add(await http.MultipartFile.fromPath(
        'lecture_file',
        videoFile.path,
        contentType: MediaType('video', 'mp4'),
      ));

      // Optional: PDF file
      if (pdfFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'pdf_file',
          pdfFile.path,
          contentType: MediaType('application', 'pdf'),
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('[uploadLecture] Status: ${response.statusCode}');
      print('[uploadLecture] Body: ${response.body}');

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('[uploadLecture] Error: $e');
      return false;
    }
  }
}
