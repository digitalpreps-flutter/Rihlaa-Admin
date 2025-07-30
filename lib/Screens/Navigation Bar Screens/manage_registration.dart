import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart'; // Import CupertinoActivityIndicator for iOS
import 'package:rihalaah_app_admin/Helpers/session_helper.dart';
import 'package:rihalaah_app_admin/services/user_service.dart';  // Import UserService

class ManageRegistration extends StatefulWidget {
  const ManageRegistration({super.key});

  @override
  State<ManageRegistration> createState() => _ManageRegistrationState();
}

class _ManageRegistrationState extends State<ManageRegistration> {
  int selectedTab = 0;
  List<User> inactiveUsers = [];
  List<Payment> payments = [];  // To store payment data
  bool _isLoading = true;  // To track loading state

  @override
  void initState() {
    super.initState();
    _fetchInactiveUsers(); // Fetch inactive users when the screen is initialized
    _fetchPayments();  // Fetch payments
  }

  // Fetch inactive users
  Future<void> _fetchInactiveUsers() async {
    try {
      final adminId = await SessionHelper.getAdminId(); // Get admin ID from session

      if (adminId == null) {
        print('Admin ID is not available');
        return;
      }

      // Fetch users using UserService and pass adminId
      final users = await UserService.fetchInactiveUsers(adminId);

      setState(() {
        inactiveUsers = users;
        _isLoading = false;  // Set loading to false once data is fetched
      });
    } catch (e) {
      setState(() {
        _isLoading = false;  // Stop loading if there is an error
      });
      print('Error fetching inactive users: $e');
    }
  }

  // Fetch payments from the API
  Future<void> _fetchPayments() async {
    try {
      final adminId = await SessionHelper.getAdminId(); // Get admin ID from session

      if (adminId == null) {
        print('Admin ID is not available');
        return;
      }

      final paymentList = await UserService.fetchPayments(adminId);

      setState(() {
        payments = paymentList;
      });
    } catch (e) {
      print('Error fetching payments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F2F2),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF2F2F2),
          elevation: 0,
          toolbarHeight: height * 0.015,
        ),
        body: Column(
          children: [
            SizedBox(height: height * 0.015),
            _buildToggle(width, height),
            SizedBox(height: height * 0.02),
            Expanded(
              child: IndexedStack(
                index: selectedTab,
                children: [
                  _buildRegistrationList(width, height),
                  _buildPaymentList(width, height),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Toggle between registration and payment tabs
  Widget _buildToggle(double width, double height) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.1),
      child: Row(
        children: [
          _buildToggleButton("Gérer l'inscription", 0, width, height),
          _buildToggleButton("Gérer le paiement", 1, width, height),
        ],
      ),
    );
  }

  // Toggle button design
  Widget _buildToggleButton(String text, int index, double width, double height) {
    final isSelected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: height * 0.015),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF7D948D) : const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: width * 0.035,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // List for inactive users
  Widget _buildRegistrationList(double width, double height) {
    return _isLoading
        ? Center(
            child: Platform.isIOS
                ? CupertinoActivityIndicator(radius: 20)
                : CircularProgressIndicator(),  // Show loading indicator on iOS or Android
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            itemCount: inactiveUsers.length,
            itemBuilder: (context, index) {
              final user = inactiveUsers[index];
              print('Displaying user: ${user.name}, Email: ${user.email}, Profile Picture: ${user.profilePicture}');
              
              return Container(
                margin: EdgeInsets.only(bottom: height * 0.015),
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    user.profilePicture != null && user.profilePicture!.isNotEmpty
                        ? CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(user.profilePicture!),
                          )
                        : const CircleAvatar(
                            radius: 24,
                            backgroundImage: AssetImage('assets/images/Rectangle_2246.png'),
                          ),
                    SizedBox(width: width * 0.03),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: width * 0.04,
                            ),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(
                              color: const Color(0xFFCC9900),
                              fontSize: width * 0.035,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: width * 0.02),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton("Accepter", width, height),
                        SizedBox(width: width * 0.015),
                        _buildActionButton("Refuser", width, height),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
  }

  // List for payments
  Widget _buildPaymentList(double width, double height) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      itemCount: payments.length,
      itemBuilder: (context, index) {
        final payment = payments[index];
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.only(bottom: height * 0.015),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/Rectangle_2246.png'),  // Static image for now
              ),
              title: Text(
                payment.userName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "Cours : ${payment.classType} Payé ${payment.stripeBill}\$",
                style: TextStyle(
                  fontSize: width * 0.035,
                  color: const Color(0xFFCC9900),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Action button for accept/refuse
  Widget _buildActionButton(String text, double width, double height) {
    final isRefuse = text.toLowerCase() == 'refuser';
    final borderColor = isRefuse ? Colors.red : Color(0xFF7D948D);
    final textColor = isRefuse ? Colors.red : Color(0xFF7D948D);

    return Container(
      height: height * 0.045,
      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.transparent,
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
            fontSize: width * 0.035,
          ),
        ),
      ),
    );
  }
}
