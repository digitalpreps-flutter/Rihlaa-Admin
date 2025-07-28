import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx)=> LoginScreen()));
        });
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