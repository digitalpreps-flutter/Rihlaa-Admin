import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleNewClassScreen extends StatefulWidget {
  const ScheduleNewClassScreen({super.key});

  @override
  State<ScheduleNewClassScreen> createState() => _ScheduleNewClassScreenState();
}

class _ScheduleNewClassScreenState extends State<ScheduleNewClassScreen> {
  String? selectedClassType;
  String? selectedSubject;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final borderRadius = const BorderRadius.all(Radius.circular(10));
  final gray = const Color(0xFFCDCDCD);
  final green = const Color(0xFF7D948D);

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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 16),
                      onPressed: () {},
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
                value: selectedClassType,
                items: ['classe d''hommes', 'classe de femmes'],
                onChanged: (val) => setState(() => selectedClassType = val),
              ),
              const SizedBox(height: 12),

              // ── Subject Dropdown ──────────────────
              _buildDropdown(
                hint: "Sujet",
                value: selectedSubject,
                items: ['Fiqh', 'Hadith', 'Tafsir'],
                onChanged: (val) => setState(() => selectedSubject = val),
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

              // ── Start/End Time ────────────────────
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(isStart: true),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration(
                            hint: startTime == null
                                ? "Heure de début"
                                : startTime!.format(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _pickTime(isStart: false),
                      child: AbsorbPointer(
                        child: TextFormField(
                          decoration: _inputDecoration(
                            hint: endTime == null
                                ? "Heure de fin"
                                : endTime!.format(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Meeting Title ─────────────────────
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
                  onPressed: () {
                    // TODO: Handle submission
                  },
                  child: const Text(
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

  // ────────────────────── Helpers ─────────────────────────────

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
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: _inputDecoration(hint: hint),
      iconEnabledColor: green,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor: Colors.white,
            colorScheme: ColorScheme.light(
              primary: green,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: green,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }
}
