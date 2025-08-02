import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';
import 'package:rihalaah_app_admin/services/question_service.dart';

class AddQuestionsScreen extends StatefulWidget {
  const AddQuestionsScreen({super.key});

  @override
  State<AddQuestionsScreen> createState() => _AddQuestionsScreenState();
}

class _AddQuestionsScreenState extends State<AddQuestionsScreen> {
  final Color green = const Color(0xFF7D948D);
  final Color gray = const Color(0xFFCDCDCD);

  int? selectedQuizId;
  List<Map<String, dynamic>> quizList = [];

  List<Map<String, dynamic>> questions = [
    _createQuestion(),
  ];

  static Map<String, dynamic> _createQuestion() {
    return {
      'questionController': TextEditingController(),
      'optionAController': TextEditingController(),
      'optionBController': TextEditingController(),
      'optionCController': TextEditingController(),
      'optionDController': TextEditingController(),
      'correctAnswer': 'A',
    };
  }

  void _addQuestion() {
    setState(() {
      questions.add(_createQuestion());
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      questions.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    loadQuizList();
  }

  Future<void> loadQuizList() async {
  final adminId = await SessionHelper.getAdminId();
  if (adminId != null) {
    quizList = await QuestionService.getQuizList(adminId.toString());
    setState(() {});
  }
}


  Future<void> submitQuestions() async {
    if (selectedQuizId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez sélectionner un quiz.")),
      );
      return;
    }

    int? adminId = await SessionHelper.getAdminId();
    if (adminId == null) return;

    List<Map<String, String>> questionData = questions.map((q) {
      return {
        'question_text': (q['questionController'] as TextEditingController).text,
        'option_a': (q['optionAController'] as TextEditingController).text,
        'option_b': (q['optionBController'] as TextEditingController).text,
        'option_c': (q['optionCController'] as TextEditingController).text,
        'option_d': (q['optionDController'] as TextEditingController).text,
        'correct_option': q['correctAnswer'] as String,
      };
    }).toList();

    bool success = await QuestionService.addQuestions(
      quizId: selectedQuizId!,
      questions: questionData,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Questions ajoutées avec succès." : "Échec de l'envoi des questions."),
      ),
    );
  }

  @override
  void dispose() {
    for (var q in questions) {
      q['questionController'].dispose();
      q['optionAController'].dispose();
      q['optionBController'].dispose();
      q['optionCController'].dispose();
      q['optionDController'].dispose();
    }
    super.dispose();
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text("Add Questions", style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              value: selectedQuizId,
              hint: const Text("Select Quiz title"),
              decoration: InputDecoration(
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
              items: quizList.map((quiz) => DropdownMenuItem<int>(
                value: quiz['quiz_id'] as int,
                child: Text(quiz['quiz_title']),
              )).toList(),
              onChanged: (val) => setState(() => selectedQuizId = val),
            ),
            const SizedBox(height: 20),
            ...questions.asMap().entries.map((entry) {
              int index = entry.key;
              var q = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Question ${index + 1}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        if (questions.length > 1)
                          IconButton(
                            onPressed: () => _removeQuestion(index),
                            icon: const Icon(Icons.remove_circle, color: Colors.red),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(q['questionController'], "Question"),
                    const SizedBox(height: 14),
                    const Text("Possibilités",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    _buildTextField(q['optionAController'], "Option A"),
                    const SizedBox(height: 8),
                    _buildTextField(q['optionBController'], "Option B"),
                    const SizedBox(height: 8),
                    _buildTextField(q['optionCController'], "Option C"),
                    const SizedBox(height: 8),
                    _buildTextField(q['optionDController'], "Option D"),
                    const SizedBox(height: 16),
                    const Text("Bonne réponse",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      children: ['A', 'B', 'C', 'D'].map((opt) {
                        return ChoiceChip(
                          label: Text(opt),
                          selected: q['correctAnswer'] == opt,
                          selectedColor: green,
                          onSelected: (_) {
                            setState(() {
                              q['correctAnswer'] = opt;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: green,
                side: BorderSide(color: green),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _addQuestion,
              icon: const Icon(Icons.add),
              label: const Text("Ajouter une autre question"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: submitQuestions,
              child: const Text("Créer un quiz",
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
