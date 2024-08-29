import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_order/repository/auth_repository/login_repository.dart';

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
  void changePasswordState(){
    isPassword = ! isPassword;
    suffixIcon = isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined ;
    emit(LoginShowPassword());
  }

}
