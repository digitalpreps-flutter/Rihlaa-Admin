import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';
import 'package:rihalaah_app_admin/Screens/add_questions.dart';
import 'package:rihalaah_app_admin/services/lecture_service.dart';
import 'package:rihalaah_app_admin/Helpers/toast_helper.dart';
import 'package:rihalaah_app_admin/services/quiz_service.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:file_picker/file_picker.dart';

class ContentScrenn extends StatefulWidget {
  const ContentScrenn({super.key});

  @override
  State<ContentScrenn> createState() => _ContentScrennState();
}

class _ContentScrennState extends State<ContentScrenn> {
  bool isQuizUploading = false;
  final green = const Color(0xFF7D948D);
  final gray = const Color(0xFFCDCDCD);

  List<Map<String, dynamic>> classList = [];
  List<Map<String, dynamic>> subjectList = [];
  List<Map<String, dynamic>> courseList = [];
  List<Map<String, dynamic>> chapterList = [];

  String? selectedClassId;
  String? selectedSubjectId;
  String? selectedCourseId;
  String? selectedChapterId;
  String? adminId;

  File? selectedVideo;
  String? videoThumbnailPath;
  File? selectedPdf;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController quizTitleController = TextEditingController();

  bool isUploading = false;
  bool isCourseUpload = true;
  

 @override
void initState() {
  super.initState();
  loadAdminSessionAndData(); // for lecture side
  loadAdminAndQuizData();    // for quiz side
}

Future<void> loadAdminAndQuizData() async {
  adminId = (await SessionHelper.getAdminId())?.toString();
  if (adminId != null) {
    classList = await QuizService.getClasses(adminId!); // ✅ Fix applied
    setState(() {});
  }
}



  Future<void> loadAdminSessionAndData() async {
    adminId = (await SessionHelper.getAdminId())?.toString();
    if (adminId != null) {
      await fetchClasses();
    }
  }

  Future<void> fetchClasses() async {
    classList = await LectureService.getClasses(adminId!);
    setState(() {});
  }

  Future<void> fetchSubjects(String classId) async {
    subjectList =
        await LectureService.getSubjects(int.parse(classId), adminId!);
    selectedSubjectId = null;
    selectedCourseId = null;
    selectedChapterId = null;
    courseList = [];
    chapterList = [];
    setState(() {});
  }

  Future<void> fetchCourses(String subjectId) async {
    courseList =
        await LectureService.getCourses(int.parse(subjectId), adminId!);
    selectedCourseId = null;
    selectedChapterId = null;
    chapterList = [];
    setState(() {});
  }

  Future<void> fetchChapters(String courseId) async {
    chapterList =
        await LectureService.getChapters(int.parse(courseId), adminId!);
    selectedChapterId = null;
    setState(() {});
  }

  Future<void> pickVideoFromGallery() async {
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final thumb = await VideoThumbnail.thumbnailFile(
        video: file.path,
        imageFormat: ImageFormat.PNG,
        maxHeight: 120,
        quality: 75,
      );
      setState(() {
        selectedVideo = file;
        videoThumbnailPath = thumb;
      });
    }
  }

  Future<void> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
      });
    }
  }

  Future<void> uploadLecture() async {
    if (selectedClassId == null ||
        selectedSubjectId == null ||
        selectedCourseId == null ||
        selectedChapterId == null ||
        selectedVideo == null ||
        titleController.text.isEmpty ||
        descController.text.isEmpty ||
        adminId == null) {
      ToastHelper.showError(
          context, 'Veuillez remplir tous les champs requis.');
      return;
    }

    setState(() => isUploading = true);

    bool success = await LectureService.uploadLecture(
      adminId: adminId!,
      lectureTitle: titleController.text,
      lectureDescription: descController.text,
      classId: selectedClassId!,
      subjectId: selectedSubjectId!,
      courseId: selectedCourseId!,
      chapterId: selectedChapterId!,
      videoFile: selectedVideo!,
      pdfFile: selectedPdf,
    );

    setState(() => isUploading = false);

    if (success) {
      ToastHelper.showSuccess(
          context, 'Le cours a été téléchargé avec succès.');
      setState(() {
        selectedClassId = null;
        selectedSubjectId = null;
        selectedCourseId = null;
        selectedChapterId = null;
        selectedVideo = null;
        videoThumbnailPath = null;
        selectedPdf = null;
        titleController.clear();
        descController.clear();
      });
    } else {
      ToastHelper.showError(
          context, "Le téléchargement a échoué. Veuillez réessayer.");
    }
  }

  Widget _buildToggleButton(String text, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? green : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<Map<String, dynamic>> items,
    required String valueKey,
    required String labelKey,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: green, width: 2),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item[valueKey].toString(),
                child: Text(item[labelKey]),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

 Widget _buildQuizUpload() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        controller: quizTitleController,
        decoration: InputDecoration(
          hintText: 'Titre du quiz',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: gray),
          ),
        ),
      ),
      const SizedBox(height: 12),
      _buildDropdown(
        hint: 'Type de classe',
        value: selectedClassId,
        items: classList,
        valueKey: 'class_id',
        labelKey: 'class_type',
        onChanged: (val) async {
          selectedClassId = val;
          selectedSubjectId = null;
          selectedCourseId = null;
          selectedChapterId = null;
          subjectList = await QuizService.getSubjects(int.parse(val!), adminId!);
          courseList = [];
          chapterList = [];
          setState(() {});
        },
      ),
      const SizedBox(height: 12),
      _buildDropdown(
        hint: 'Sujet',
        value: selectedSubjectId,
        items: subjectList,
        valueKey: 'subject_id',
        labelKey: 'subject_name',
        onChanged: (val) async {
          selectedSubjectId = val;
          selectedCourseId = null;
          selectedChapterId = null;
          courseList = await QuizService.getCourses(int.parse(val!), adminId!);
          chapterList = [];
          setState(() {});
        },
      ),
      const SizedBox(height: 12),
      _buildDropdown(
        hint: 'Cours',
        value: selectedCourseId,
        items: courseList,
        valueKey: 'course_id',
        labelKey: 'course_title',
        onChanged: (val) async {
          selectedCourseId = val;
          selectedChapterId = null;
          chapterList = await QuizService.getChapters(int.parse(val!), adminId!);
          setState(() {});
        },
      ),
      const SizedBox(height: 12),
      _buildDropdown(
        hint: 'Chapitre',
        value: selectedChapterId,
        items: chapterList,
        valueKey: 'chapter_id',
        labelKey: 'chapter_name',
        onChanged: (val) {
          setState(() {
            selectedChapterId = val;
          });
        },
      ),
      const SizedBox(height: 20),
      ElevatedButton(
        onPressed: isQuizUploading ? null : uploadQuiz,
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: isQuizUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Créer un quiz", style: TextStyle(color: Colors.white)),
      ),
      const SizedBox(height: 12),
      ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> AddQuestionsScreen()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            minimumSize: const Size.fromHeight(50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: const Text("Ajouter une question",
              style: TextStyle(color: Colors.white)),
        ),
        
    ],
  );
}
Future<void> uploadQuiz() async {
  if (adminId == null ||
      quizTitleController.text.isEmpty ||
      selectedClassId == null ||
      selectedSubjectId == null ||
      selectedCourseId == null ||
      selectedChapterId == null) {
    ToastHelper.showError(context, "Veuillez remplir tous les champs.");
    return;
  }

  setState(() => isQuizUploading = true);

  bool success = await QuizService.addQuiz(
    adminId: adminId!,
    quizTitle: quizTitleController.text,
    classId: selectedClassId!,
    subjectId: selectedSubjectId!,
    courseId: selectedCourseId!,
    chapterId: selectedChapterId!,
  );

  setState(() => isQuizUploading = false);

  if (success) {
    ToastHelper.showSuccess(context, "Quiz créé avec succès.");
    quizTitleController.clear();
    selectedClassId = null;
    selectedSubjectId = null;
    selectedCourseId = null;
    selectedChapterId = null;
    subjectList = [];
    courseList = [];
    chapterList = [];
    setState(() {});
  } else {
    ToastHelper.showError(context, "La création du quiz a échoué.");
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                        "Téléchargement de cours", isCourseUpload, () {
                      setState(() => isCourseUpload = true);
                    }),
                  ),
                  Expanded(
                    child: _buildToggleButton(
                        "Téléchargement du quiz", !isCourseUpload, () {
                      setState(() => isCourseUpload = false);
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isCourseUpload ? _buildCourseUpload() : _buildQuizUpload(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdown(
          hint: 'Type de classe',
          value: selectedClassId,
          items: classList,
          valueKey: 'class_id',
          labelKey: 'class_type',
          onChanged: (val) {
            selectedClassId = val;
            fetchSubjects(val!);
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          hint: 'Sujet',
          value: selectedSubjectId,
          items: subjectList,
          valueKey: 'subject_id',
          labelKey: 'subject_name',
          onChanged: (val) {
            selectedSubjectId = val;
            fetchCourses(val!);
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          hint: 'Cours',
          value: selectedCourseId,
          items: courseList,
          valueKey: 'course_id',
          labelKey: 'course_title',
          onChanged: (val) {
            selectedCourseId = val;
            fetchChapters(val!);
          },
        ),
        const SizedBox(height: 12),
        _buildDropdown(
          hint: 'Chapitre',
          value: selectedChapterId,
          items: chapterList,
          valueKey: 'chapter_id',
          labelKey: 'chapter_name',
          onChanged: (val) {
            selectedChapterId = val;
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: titleController,
          decoration: InputDecoration(
            hintText: 'Titre du cours',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: gray),
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: descController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Description/remarques',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: gray),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: pickPdfFile,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: gray),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.picture_as_pdf, color: Colors.redAccent),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    selectedPdf != null
                        ? selectedPdf!.path.split('/').last
                        : 'PDF format (optionnel)',
                    style: TextStyle(
                      fontSize: 14,
                      color:
                          selectedPdf != null ? Colors.black : Colors.black45,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: pickVideoFromGallery,
          child: Container(
            height: 130,
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: selectedVideo == null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.upload, size: 30, color: Colors.black),
                      SizedBox(height: 10),
                      Text("Télécharger", style: TextStyle(fontSize: 14)),
                      Text("Formats pris en charge: .mp4 uniquement",
                          style:
                              TextStyle(fontSize: 12, color: Colors.black45)),
                    ],
                  )
                : Row(
                    children: [
                      if (videoThumbnailPath != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.file(
                            File(videoThumbnailPath!),
                            height: 100,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedVideo!.path.split('/').last,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: green,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            minimumSize: const Size.fromHeight(50),
          ),
          onPressed: isUploading ? null : uploadLecture,
          child: isUploading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text('Télécharger le cours',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
        )
      ],
    );
  }
}
