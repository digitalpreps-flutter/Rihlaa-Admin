import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';
import 'package:rihalaah_app_admin/Screens/Auth%20screen/login.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Delay for splash effect

    final isLoggedIn = await SessionHelper.isLoggedIn();

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => isLoggedIn
            ?  BottomNavScreen()
            : LoginScreen(), // or your actual login screen
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4D5A52), // dark greenish background
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Image.asset(
              'assets/images/splash_screen_logo.png',
              width: 300,
            ),
          ),
        ],
      ),
    );
  }
}