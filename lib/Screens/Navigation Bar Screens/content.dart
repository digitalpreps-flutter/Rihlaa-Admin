import 'package:flutter/material.dart';

class ContentScrenn extends StatefulWidget {
  const ContentScrenn({super.key});

  @override
  State<ContentScrenn> createState() => _ContentScrennState();
}

class _ContentScrennState extends State<ContentScrenn> {
  bool isCourseUpload = true;

  final green = const Color(0xFF7D948D);
  final gray = const Color(0xFFCDCDCD);

  String? selectedClassType;
  String? selectedSubject;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: ColorScheme.light(
          primary: green,
          onPrimary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        splashColor: green.withOpacity(0.1),
        highlightColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Toggle Button
                Row(
                  children: [
                    Expanded(
                      child: _buildToggleButton("Téléchargement de cours", isCourseUpload, () {
                        setState(() => isCourseUpload = true);
                      }),
                    ),
                    Expanded(
                      child: _buildToggleButton("Téléchargement du quiz", !isCourseUpload, () {
                        setState(() => isCourseUpload = false);
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                isCourseUpload
                    ? _buildCourseUpload(width)
                    : _buildQuizUpload(width),
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget _buildCourseUpload(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dropdown(
          hint: "Type de classe",
          value: selectedClassType,
          items: ['classe d''hommes', 'classe de femmes'],
          onChanged: (val) => setState(() => selectedClassType = val),
        ),
        const SizedBox(height: 12),
        _textField("Titre du cours"),
        const SizedBox(height: 12),
        _textField("Description/remarques", maxLines: 3),
        const SizedBox(height: 20),
        Container(
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.upload, size: 30, color: Colors.black),
                SizedBox(height: 10),
                Text("Télécharger", style: TextStyle(fontSize: 14)),
                Text(
                  "Formats pris en charge .Mp4, .mp3",
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _primaryButton("Télécharger le cours"),
      ],
    );
  }

  Widget _buildQuizUpload(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dropdown(
          hint: "Type de classe",
          value: selectedClassType,
          items: ['classe d ' 'hommes', 'classe de femmes'],
          onChanged: (val) => setState(() => selectedClassType = val),
        ),
        const SizedBox(height: 12),
        _dropdown(
          hint: "Sujet",
          value: selectedSubject,
          items: ['Quran', 'Anjeel'],
          onChanged: (val) => setState(() => selectedSubject = val),
        ),
        const SizedBox(height: 20),
        const Text("Question 1",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        _textField("Question 1"),
        const SizedBox(height: 14),
        const Text("Options", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _textField("Option A"),
        const SizedBox(height: 8),
        _textField("Option B"),
        const SizedBox(height: 8),
        _textField("Option C"),
        const SizedBox(height: 8),
        _textField("Option D"),
        const SizedBox(height: 16),
        const Text("Correct Answer",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          children: ['A', 'B', 'C', 'D'].map((opt) {
            return OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: green,
                side: BorderSide(color: green,),
              ),
              onPressed: () {},
              child: Text(opt),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: green,
            side: BorderSide(color: green),
          ),
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("Ajouter une autre question"),
        ),
        const SizedBox(height: 20),
        _primaryButton("Créer un quiz"),
      ],
    );
  }

  Widget _textField(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: green, width: 2),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: gray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: green, width: 2),
        ),
      ),
      iconEnabledColor: green,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _primaryButton(String text) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: green,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        onPressed: () {},
        child: Text(text,
            style: const TextStyle(fontSize: 18, color: Colors.white)),
      ),
    );
  }
}
