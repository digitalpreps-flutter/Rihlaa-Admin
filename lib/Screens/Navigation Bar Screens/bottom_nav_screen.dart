import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/content.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/home_screen.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/live_classes.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/manage_registration.dart';
import 'package:rihalaah_app_admin/Screens/Navigation%20Bar%20Screens/settings.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  int _selectedIndex = 0;

  final screens = [
    HomeScreen(),
    ManageRegistration(),
    LiveClasses(),
    ContentScrenn(),
    Settings()
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color:Color(0xFF7D948D),
          buttonBackgroundColor: Color(0xFF7D948D),
          height: 70,
          index: _selectedIndex,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: <Widget>[
            navItem('assets/images/home.png', 'Maison', 0),
            navItem('assets/images/manage.png', 'Gérer', 1),
            navItem('assets/images/live.png', 'live', 2),
            navItem('assets/images/content.png', 'Contenu', 3),
            navItem('assets/images/setting.png', 'Paramètres', 4),
          ],
        ),
        body: screens[_selectedIndex],
      ),
    );
  }

  Widget navItem(String assetPath, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          assetPath,
          width: 24,
          height: 24,
          color: Colors.white, // ALWAYS white color
        ),
        const SizedBox(height: 2),
        if (!isSelected)
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
      ],
    );
  }
}
