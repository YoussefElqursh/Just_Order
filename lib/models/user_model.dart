import 'enums/user_type.dart';

class User {
  String userId;
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNumber;
  UserType userType;
  String createdAt;
  String updatedAt;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.userType,
    required this.createdAt,
    required this.updatedAt,
  });
}