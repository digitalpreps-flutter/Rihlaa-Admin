import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rihalaah_app_admin/services/schedule_service.dart';

class ScheduleNewClassScreen extends StatefulWidget {
  const ScheduleNewClassScreen({super.key});

  @override
  State<ScheduleNewClassScreen> createState() => _ScheduleNewClassScreenState();
}

class _ScheduleNewClassScreenState extends State<ScheduleNewClassScreen> {
  List<dynamic> classTypes = [];
  List<dynamic> subjects = [];

  String? selectedClassTypeId;
  String? selectedSubjectId;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  final borderRadius = const BorderRadius.all(Radius.circular(10));
  final gray = const Color(0xFFCDCDCD);
  final green = const Color(0xFF7D948D);

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchClassTypes();
  }

  Future<void> fetchClassTypes() async {
    final data = await ScheduleService.getClassTypes();
    setState(() {
      classTypes = data;
    });
  }

  Future<void> fetchSubjects(String classId) async {
    final data = await ScheduleService.getSubjects(classId);
    setState(() {
      subjects = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ─────────────────────────────
              Row(
                children: [
                  Container(
                    width: 32,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    "Programmer un nouveau cours en direct",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Class Type Dropdown ───────────────
              _buildDropdown(
                hint: "Type de classe",
                value: selectedClassTypeId,
                items: classTypes,
                getLabel: (e) => e['class_type'],
                getValue: (e) => e['class_id'].toString(),
                onChanged: (val) {
                  setState(() {
                    selectedClassTypeId = val;
                    selectedSubjectId = null;
                    subjects = [];
                  });
                  fetchSubjects(val!);
                },
              ),
              const SizedBox(height: 12),

              // ── Subject Dropdown ──────────────────
              _buildDropdown(
                hint: "Sujet",
                value: selectedSubjectId,
                items: subjects,
                getLabel: (e) => e['subject_name'],
                getValue: (e) => e['subject_id'].toString(),
                onChanged: (val) {
                  setState(() => selectedSubjectId = val);
                },
              ),
              const SizedBox(height: 12),

              // ── Date Picker ───────────────────────
              GestureDetector(
                onTap: _pickDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: _inputDecoration(
                      hint: selectedDate == null
                          ? "Date"
                          : DateFormat('yyyy-MM-dd').format(selectedDate!),
                      suffixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF7D948D),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Time Picker ───────────────────────
              GestureDetector(
                onTap: _pickTime,
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: _inputDecoration(
                      hint: selectedTime == null
                          ? "Heure"
                          : selectedTime!.format(context),
                      suffixIcon: const Icon(
                        Icons.access_time,
                        color: Color(0xFF7D948D),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── Duration Field ─────────────────────
              TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(hint: "Durée (minutes)"),
              ),
              const SizedBox(height: 12),

              // ── Title ──────────────────────────────
              TextFormField(
                controller: titleController,
                decoration: _inputDecoration(hint: "Titre de la réunion"),
              ),
              const SizedBox(height: 12),

              // ── Description ───────────────────────
              TextFormField(
                controller: descriptionController,
                maxLines: 3,
                decoration: _inputDecoration(hint: "Description/remarques"),
              ),
              const SizedBox(height: 30),

              // ── Submit Button ─────────────────────
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  ),
                  onPressed: isLoading ? null : _submitSchedule,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Programmer le cours",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ────────────────────── Logic ─────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => selectedTime = picked);
  }

Future<void> _submitSchedule() async {
  // ── Validate Inputs ──
  if (selectedClassTypeId == null ||
      selectedSubjectId == null ||
      selectedDate == null ||
      selectedTime == null ||
      titleController.text.isEmpty ||
      descriptionController.text.isEmpty ||
      durationController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veuillez remplir tous les champs.")),
    );
    return;
  }

  setState(() => isLoading = true);

  // ── Convert Time to 24-Hour Format ──
  final formattedTime =
      "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

  // ── Call API ──
  final response = await ScheduleService.scheduleClass(
    topicName: titleController.text.trim(),
    topicDescription: descriptionController.text.trim(),
    duration: durationController.text.trim(),
    date: DateFormat('yyyy-MM-dd').format(selectedDate!),
    time: formattedTime,
    subjectId: selectedSubjectId!,
    classTypeId: selectedClassTypeId!,
  );

  setState(() => isLoading = false);

  // ── Handle API Response ──
  if (response['status'] == true || response['success'] == true) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("Cours programmé avec succès!")),
  );
  Navigator.pop(context); // or clear form
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text("Erreur: ${response['message'] ?? 'Une erreur est survenue'}"),
    ),
  );
}

}


  // ────────────────────── UI Helpers ────────────────────────

  InputDecoration _inputDecoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: gray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: BorderSide(color: green, width: 2),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<dynamic> items,
    required String Function(dynamic) getLabel,
    required String Function(dynamic) getValue,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(hint: hint),
      iconEnabledColor: green,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      items: items
          .map((item) => DropdownMenuItem(
                value: getValue(item),
                child: Text(getLabel(item)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
