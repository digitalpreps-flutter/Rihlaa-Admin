import 'package:flutter/material.dart';
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';
import '../Auth screen/login.dart';
import 'edit_profile.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _notificationsEnabled = true;
  String? adminName;
  String? adminEmail;
  String? adminPicture;

  @override
  void initState() {
    super.initState();
    _loadSessionData();
  }

  Future<void> _loadSessionData() async {
    final name = await SessionHelper.getAdminName();
    final email = await SessionHelper.getAdminEmail();
    final picture = await SessionHelper.getAdminPicture();

    setState(() {
      adminName = name;
      adminEmail = email;
      adminPicture = picture;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final textScale = MediaQuery.of(context).textScaleFactor;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Top Bar
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.05,
                  vertical: screenHeight * 0.03,
                ),
                width: double.infinity,
                color: const Color(0xFFF2F2F2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20 * textScale,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      height: screenHeight * 0.06,
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.02),

              // Profile Image with Shadow
              Container(
                width: screenWidth * 0.35,
                height: screenWidth * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.215),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset('assets/images/Ellipse_26.png',
                          fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Admin Name
              Text(
                adminName ?? 'Admin',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20 * textScale,
                ),
              ),

              // Admin Email
              Text(
                adminEmail ?? 'admin@example.com',
                style: TextStyle(
                  fontSize: 14 * textScale,
                  color: const Color(0xFF727272),
                ),
              ),

              SizedBox(height: screenHeight * 0.015),

              // Edit Profile Button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7D948D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 18, color: Colors.white),
                label: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 14 * textScale,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // Notifications
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.015,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 16 * textScale,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF7D948D),
                        ),
                      ),
                      Switch(
                        activeColor: const Color(0xFF7D948D),
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Logout Button (yet to implement)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // logout logic will come later
                      _logout();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7D948D),
                      padding: EdgeInsets.symmetric(
                        vertical: screenHeight * 0.018,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Se déconnecter',
                      style: TextStyle(
                        fontSize: 16 * textScale,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _logout() async {
    // Show confirmation dialog
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to logout?'),
          content: const Text('You will be logged out of your account.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);  // User pressed No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);  // User pressed Yes
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    // If user confirmed, proceed with logout
    if (confirmLogout == true) {
      await SessionHelper.logout(); // Clears session
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()), // Redirect to login
      );
    }
  }
}