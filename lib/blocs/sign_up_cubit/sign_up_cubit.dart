import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:just_order/models/enums/user_type.dart';
import 'package:just_order/models/user_model.dart';
import 'package:just_order/shared/function/connectivity_plus.dart';
import 'package:just_order/shared/function/validations.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  SignUpCubit() : super(SignUpInitialState());

  Future<void> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required String phoneNumber,
  }) async {
    emit(SignUpLoadingState());

    // Input Validation
    if (!InputValidator.isValidEmail(email)) {
      emit(SignUpFailureState('Invalid email format'));
      return;
    }

    if (!InputValidator.isValidPassword(password)) {
      emit(SignUpFailureState('Password must be at least 8 characters long'));
      return;
    }

    if (!InputValidator.isValidPhoneNumber(phoneNumber)) {
      emit(SignUpFailureState('Invalid phone number'));
      return;
    }

    // Network Connectivity Check
    if (!await isConnected()) {
      emit(SignUpFailureState('No Internet Connection'));
      return;
    }

    try {
      // Check if the user already exists
      final existingUsers = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        emit(SignUpFailureState('User with this email already exists.'));
        return;
      }

      // Proceed with user creation
      final bytes = utf8.encode(password);
      final digest = sha256.convert(bytes);
      final hashedPassword = digest.toString();

      final userId = _firestore.collection('users').doc().id;
      final user = User(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: hashedPassword,
        phoneNumber: phoneNumber,
        userType: UserType.customer,
        emailVerified: true,
        phoneNumberVerified: true,
        createdAt: Timestamp.now().toDate(),
      );

      await _firestore.collection('users').doc(userId).set(user.toJson());
      emit(SignUpISuccessState());
    } catch (e) {
      emit(SignUpFailureState('An error occurred: ${e.toString()}'));
    }
  }

  IconData suffixIcon = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordState() {
    isPassword = !isPassword;
    suffixIcon =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(SignUpShowPassword());
  }
}
