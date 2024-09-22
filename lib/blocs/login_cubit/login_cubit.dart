import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository repository;

  LoginCubit(this.repository) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    try {
      final user = await repository.login(email, password);
      if (user != null) {
        emit(LoginSuccess(user)); // Successful login
      } else {
        emit(LoginFailure("Invalid credentials")); // Explicitly emit failure
      }
    } catch (e) {
      emit(LoginFailure("An error occurred")); // Handle potential errors
    }
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;
  void changePasswordState() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(LoginShowPassword());
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        emit(LoginFailure("Google sign-in aborted"));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      if (googleAuth.idToken == null) {
        emit(LoginFailure("Google sign-in failed"));
        return;
      }

      final String email = googleUser.email;
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.isNotEmpty) {
        User? user =
            await User.fromMap(documents.first.data() as Map<String, dynamic>);
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', jsonEncode(user?.toJson()));
        emit(LoginSuccess(user!));
      } else {
        emit(LoginFailure("User not found in Firestore"));
      }
    } catch (e) {
      emit(LoginFailure("An error occurred: ${e.toString()}"));
    }
  }
}
