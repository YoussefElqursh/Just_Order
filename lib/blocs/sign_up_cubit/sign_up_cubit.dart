import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:just_order/models/enums/user_type.dart';
import 'package:just_order/models/user_model.dart';

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
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString();

    emit(SignUpLoadingState());
    try {
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
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(userId).set(user.toJson());

      emit(SignUpISuccessState());
    } catch (e) {
      emit(SignUpFailureState(e.toString()));
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
