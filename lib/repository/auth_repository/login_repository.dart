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
        .where('emailVerified', isEqualTo: true)
        .where('phoneNumberVerified', isEqualTo: true)
        .where('userType', isEqualTo: 'customer')
        .get();

    if (result.docs.isEmpty) {
      return null;
    }

    final doc = result.docs.first;
    final user = User.fromJson(doc.data() as Map<String, dynamic>);

    await user?.saveUserToPreferences(user);

    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
