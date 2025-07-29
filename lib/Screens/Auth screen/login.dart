import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Screens/registration.dart';
import 'package:rihalaah_app_admin/Services/auth_service.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/bottom_nav_screen.dart';
import 'package:rihalaah_app_admin/Helpers/toast_helper.dart';
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool _isLoading = false;

  void loginUser() async {
  setState(() {
    _isLoading = true;
  });

  print("🔄 Attempting to login...");

  final response = await AuthService.login(
    email: emailController.text.trim(),
    password: passwordController.text,
  );

  setState(() {
    _isLoading = false;
  });

  if (response != null && response.status) {
    print("✅ Login successful: ${response.admin.adminName}");

    ToastHelper.showSuccess(context, "Connexion réussie");

    // 🔐 Store session in SharedPreferences
    print("✅ Login successful: ${response.admin.adminName}");

await SessionHelper.saveAdminSession(
  id: response.admin.adminId,
  name: response.admin.adminName,
  email: response.admin.adminEmail,
  phone: response.admin.adminPhone,
  picture: response.admin.adminPicture ?? "",
  status: response.admin.status,
);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const BottomNavScreen()),
    );
  } else {
    print("❌ Login failed.");
    ToastHelper.showError(context, "Échec de la connexion");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Stack(
          children: [
            _buildLoginForm(),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset('assets/images/logo.png', height: 120),
            const SizedBox(height: 50),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bienvenu!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Nom de l'administrateur",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Adresse email/Numéro de téléphone',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: 'Mot de passe',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7D948D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30,),
            Center(
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                        children: [
                          const TextSpan(text: 'Vous n’avez pas de compte ? '),
                          TextSpan(
                            text: 'inscrivez-vous maintenant',
                            style: const TextStyle(
                              color: Color(0xFF6F8B82),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => const RegistrationScreen(),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}


