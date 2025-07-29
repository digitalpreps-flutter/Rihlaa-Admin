import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Helpers/toast_helper.dart';
import 'package:rihalaah_app_admin/Screens/Auth%20screen/login.dart';
import 'package:rihalaah_app_admin/services/auth_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String? selectedDay, selectedMonth, selectedYear;
  bool _obscurePassword = true;
  bool _isLoading = false;

  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final List<String> days = List.generate(31, (index) => '${index + 1}');
  final List<String> months = [
    'Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
    'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'
  ];
  final List<String> years =
      List.generate(100, (index) => '${DateTime.now().year - index}');

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: mq.width * 0.06, vertical: mq.height * 0.02),
          child: Column(
            children: [
              SizedBox(height: mq.height * 0.015),
              Image.asset('assets/images/logo.png', height: mq.height * 0.15),
              SizedBox(height: mq.height * 0.02),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Inscrivez-vous maintenant",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Bonjour ! Veuillez saisir vos informations de compte.",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ),
              SizedBox(height: mq.height * 0.025),
              _buildTextField('Nom d\'utilisateur', nameController),
              SizedBox(height: mq.height * 0.015),
              _buildDOBRow(),
              SizedBox(height: mq.height * 0.015),
              _buildTextField('ville', cityController),
              SizedBox(height: mq.height * 0.015),
              _buildTextField('Adresse email', emailController),
              SizedBox(height: mq.height * 0.015),
              _buildTextField('Numéro de téléphone', phoneController),
              SizedBox(height: mq.height * 0.015),
              _buildPasswordField(),
              SizedBox(height: mq.height * 0.015),
              _buildRequestButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) => TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.black45),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF6F8B82), width: 1.5),
          ),
        ),
        cursorColor: const Color(0xFF6F8B82),
      );

  Widget _buildDOBRow() => Row(
        children: [
          Expanded(
              child: _buildDropdown(selectedDay, days, 'Jour',
                  (val) => setState(() => selectedDay = val))),
          const SizedBox(width: 8),
          Expanded(
              child: _buildDropdown(selectedMonth, months, 'Mois',
                  (val) => setState(() => selectedMonth = val))),
          const SizedBox(width: 8),
          Expanded(
              child: _buildDropdown(selectedYear, years, 'Année',
                  (val) => setState(() => selectedYear = val))),
        ],
      );

  Widget _buildDropdown(String? value, List<String> items, String hint,
      ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFCDCDCD)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint, style: const TextStyle(color: Colors.black45)),
          icon: const Icon(Icons.arrow_drop_down),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPasswordField() => TextField(
        controller: passwordController,
        obscureText: _obscurePassword,
        decoration: InputDecoration(
          hintText: 'Mot de passe',
          suffixIcon: IconButton(
            icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                size: 18,
                color: const Color(0xFF6F8B82)),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFCDCDCD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF6F8B82)),
          ),
        ),
        cursorColor: const Color(0xFF6F8B82),
      );

  Widget _buildRequestButton() => ElevatedButton(
        onPressed: _isLoading ? null : registerUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6F8B82),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Request Registration',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
      );

  void registerUser() async {
    setState(() {
      _isLoading = true;
    });
    

    final String? dob = (selectedDay != null && selectedMonth != null && selectedYear != null)
        ? "$selectedDay-$selectedMonth-$selectedYear"
        : null;

    Map<String, dynamic> data = {
      "admin_name": nameController.text.trim(),
      "admin_email": emailController.text.trim(),
      "admin_password": passwordController.text,
      "admin_phone": phoneController.text.trim(),
      "admin_city": cityController.text.trim(),
      "admin_dob": dob ?? "",
      "admin_picture": "", // add base64 image if needed
    };

    print("📤 Sending registration data: $data");

    final response = await AuthService.signup(data);

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['status'] == true) {
      ToastHelper.showSuccess(context, response['message']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } else {
      ToastHelper.showError(
          context, response?['message'] ?? "Registration failed");
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    cityController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
