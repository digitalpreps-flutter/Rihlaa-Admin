import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/bottom_nav_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 120,
                  width: 162,
                ),
              ),
              const SizedBox(height: 50),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Bienvenu!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nom de l''administrateur',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Adresse email/Numéro de téléphone',
                  hintStyle: TextStyle(
                    color: Color(0xFFA4A4A4)
                  ),
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(color: Colors.pink),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Mot de passe',
                  hintStyle: TextStyle(
                    color: Color(0xFFA4A4A4)
                  ),
                  filled: true,
                  fillColor: Color(0xFFF2F2F2),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF7D948D),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7D948D), 
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  ),
                  onPressed: () {
                    // Login logic here
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> BottomNavScreen()));
                  },
                  child: const Text(
                    'Se connecter',
            
                    style: TextStyle(fontSize: 18,color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}