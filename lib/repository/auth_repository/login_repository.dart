import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_order/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

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
    try {
      // Attempt to sign out
      await _googleSignIn.signOut();
      print("User signed out successfully.");

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Attempt to disconnect (optional, handle failure gracefully)
      try {
        await _googleSignIn.disconnect();
        print("User disconnected successfully.");
      } catch (e) {
        // Log the error, but don't break the app
        print("Failed to disconnect: $e");
      }
    } catch (e) {
      // Catch any other errors during logout
      print("Error during logout: $e");
    }
  }
}
