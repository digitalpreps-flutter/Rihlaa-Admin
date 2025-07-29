import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rihalaah_app_admin/Helpers/session_helper.dart';
import 'package:rihalaah_app_admin/Screens/splash_screen.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/bottom_nav_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isLoggedIn = await SessionHelper.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rihlaa Admin Panel',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: isLoggedIn ? const BottomNavScreen() : const SplashScreen(),
        );
      },
    );
  }
}
