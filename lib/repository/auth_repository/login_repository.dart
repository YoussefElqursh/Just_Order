import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:just_order/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> login(String email, String password) async {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();

    final QuerySnapshot result = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .where('password', isEqualTo: hashedPassword)
        .get();

    if (result.docs.isEmpty) {
      throw Exception('Invalid email or password');
    }

    final doc = result.docs.first;
    final user = User.fromJson(doc.data() as Map<String, dynamic>);

    await user?.saveUserToPreferences(user);

    // Save login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);

    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
  }
// ... other methods for registration, logout, etc.
}
