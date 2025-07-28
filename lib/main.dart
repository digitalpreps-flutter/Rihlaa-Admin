import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart'; 
import 'package:rihalaah_app_admin/Screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer( // ✅ Wrap MaterialApp with Sizer
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
