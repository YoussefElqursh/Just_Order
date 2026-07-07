import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_order/models/enums/user_type.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';
import 'package:just_order/core/services/notification_service.dart';
import 'package:just_order/core/di/service_locator.dart';

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
    suffixIcon = isPassword
        ? Icons.visibility_outlined
        : Icons.visibility_off_outlined;
    emit(LoginShowPassword());
  }

  Future<void> loginWithGoogle() async {
    emit(LoginLoading());
    final GoogleSignIn googleSignIn = GoogleSignIn.instance;

    try {
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      if (googleAuth.idToken == null) {
        emit(LoginFailure("Google sign-in failed: No ID token found"));
        return;
      }

      // Retrieve user details from Google account
      final String email = googleUser.email;
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      if (documents.isNotEmpty) {
        // ✅ Existing user
        User? user = await User.fromMap(
          documents.first.data() as Map<String, dynamic>,
        );

        if (user != null) {
          await user.saveUserToPreferences(user);
        }

        emit(LoginSuccess(user!));
      } else {
        // ✅ New user registration
        final String googleId = googleUser.id;
        final String name = googleUser.displayName ?? "No Name Provided";

        // Create user instance without userId initially
        final user = User(
          userId: '',
          googleId: googleId,
          firstName: name,
          lastName: '',
          email: email,
          password: digestPassword(googleUser.id),
          loginWithGoogle: true,
          phoneNumber: '--',
          userType: UserType.customer,
          emailVerified: true,
          phoneNumberVerified: true,
          createdAt: Timestamp.now().toDate(),
        );

        // ✅ Add to Firestore with auto ID and set userId before saving
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(); // generate ID
        user.userId = docRef.id; // update user object
        await docRef.set(user.toJson()); // single write

        // ✅ Save to preferences & notifications
        await user.saveUserToPreferences(user);
        await getIt<NotificationService>().initialize(user.email);

        emit(LoginSuccess(user));
      }
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // User backed out of the account picker — not a real error.
        debugPrint("Google sign-in canceled");
        emit(LoginInitial()); // swap for your actual idle/initial state
        return;
      }
      emit(LoginFailure("Google sign-in failed: ${e.description ?? e.code}"));
    } catch (e) {
      emit(LoginFailure("An error occurred: ${e.toString()}"));
    }
  }

  String digestPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();
    return hashedPassword;
  }
}