import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:rihalaah_app_admin/Screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          home: const SplashScreen(),  // Always start with splash
        );
      },
    );
  }
}
