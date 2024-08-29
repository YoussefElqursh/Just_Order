import '../../models/user_model.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final User user;
  LoginSuccess(this.user);
}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}

class LoginShowPassword extends LoginState {}