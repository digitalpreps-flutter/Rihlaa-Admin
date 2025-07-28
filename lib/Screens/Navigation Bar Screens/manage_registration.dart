import 'package:flutter/material.dart';

class ManageRegistration extends StatefulWidget {
  const ManageRegistration({super.key});

  @override
  State<ManageRegistration> createState() => _ManageRegistrationState();
}

class _ManageRegistrationState extends State<ManageRegistration> {
  int selectedTab = 0;

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

  Widget _buildRegistrationList(double width, double height) {
  return ListView.builder(
    padding: EdgeInsets.symmetric(horizontal: width * 0.05),
    itemCount: 3,
    itemBuilder: (context, index) {
      return Container(
        margin: EdgeInsets.only(bottom: height * 0.015),
        padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.015),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage('assets/images/Rectangle_2246.png'),
            ),
            SizedBox(width: width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Student Full Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.04,
                    ),
                  ),
                  Text(
                    "Example@gmail.com",
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


  Widget _buildPaymentList(double width, double height) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Card(
          elevation: 0,
          color: Colors.white,
          margin: EdgeInsets.only(bottom: height * 0.015),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.02),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/Rectangle_2246.png'),
              ),
              title: Text(
                "Student Full Name",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.04,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                "Cours : Hommes Payé 150\$",
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
