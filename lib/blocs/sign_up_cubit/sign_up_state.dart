part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitialState extends SignUpState {}

final class SignUpLoadingState extends SignUpState {}

final class SignUpISuccessState extends SignUpState {}

final class SignUpFailureState extends SignUpState {
  final String message;
  SignUpFailureState(this.message);
}

final class SignUpShowPassword extends SignUpState {}
