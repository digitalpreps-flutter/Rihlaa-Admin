import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  // Fetch Inactive Users
  static Future<List<User>> fetchInactiveUsers(int adminId) async {
    final url = Uri.parse('https://rihlaaapp.fr/api/admin/inactive_users');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'admin_id': adminId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          List<dynamic> usersData = data['data'];
          return usersData.map((user) => User.fromJson(user)).toList();
        } else {
          throw Exception('Failed to load inactive users');
        }
      } else {
        throw Exception('Failed to load inactive users');
      }
    } catch (e) {
      print('Error fetching inactive users: $e');
      rethrow;
    }
  }

  // Accept or Refuse a User
  static Future<bool> manageUserRegistration(int adminId, int userId, String action) async {
    final url = Uri.parse('https://rihlaaapp.fr/api/admin/manage_registration');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'admin_id': adminId,
          'user_id': userId,
          'action': action,  // Action will be 'accept' or 'refuse'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          return true; // User has been accepted/refused successfully
        } else {
          throw Exception('Failed to change user status');
        }
      } else {
        throw Exception('Failed to manage user registration');
      }
    } catch (e) {
      print('Error managing user registration: $e');
      return false;
    }
  }

  // Fetch Payments
  static Future<List<Payment>> fetchPayments(int adminId) async {
    final url = Uri.parse('https://rihlaaapp.fr/api/admin/get_all_payments');
    
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'admin_id': adminId}), // Pass admin_id as part of the request body
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == true) {
          List<dynamic> paymentsData = data['payments'];
          return paymentsData.map((payment) => Payment.fromJson(payment)).toList();
        } else {
          throw Exception('Failed to load payments');
        }
      } else {
        throw Exception('Failed to load payments');
      }
    } catch (e) {
      print('Error fetching payments: $e');
      rethrow;
    }
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String? profilePicture;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profilePicture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePicture: json['profile_pick'],
    );
  }
}

// Payment model
class Payment {
  final String paymentId; // Change to String
  final String stripeId; // Change to String
  final String stripeBill; 
  final String dated;
  final String userName;
  final String userEmail;
  final String classType;

  Payment({
    required this.paymentId,
    required this.stripeId,
    required this.stripeBill,
    required this.dated,
    required this.userName,
    required this.userEmail,
    required this.classType,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['payment_id'].toString(), // Convert to String
      stripeId: json['stripe_id'].toString(),   // Convert to String
      stripeBill: json['stripe_bill'],
      dated: json['dated'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      classType: json['class_type'],
    );
  }
}

