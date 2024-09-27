import 'enums/user_type.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String userId;
  String firstName;
  String lastName;
  String email;
  String password;
  String phoneNumber;
  UserType userType;
  bool emailVerified;
  bool phoneNumberVerified;
  DateTime createdAt;
  DateTime? updatedAt;

  User({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.userType,
    required this.emailVerified,
    required this.phoneNumberVerified,
    required this.createdAt,
    this.updatedAt,
  });

  static Future<User>? fromMap(Object? data) {
    if (data == null) {
      return null;
    }

    final Map<String, dynamic> map = data as Map<String, dynamic>;
    return Future.value(User(
      userId: map['userId'] as String,
      firstName: map['firstName'] as String,
      lastName: map['lastName'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNumber: map['phoneNumber'] as String,
      userType: UserType.values
          .firstWhere((e) => e.toString() == 'UserType.${map['userType']}'),
      emailVerified: map['emailVerified'] as bool,
      phoneNumberVerified: map['phoneNumberVerified'] as bool,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      updatedAt: map['updatedAt'] == null
          ? null
          : (map['updatedAt'] as Timestamp).toDate(),
    ));
  }

  Future<void> saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('user', jsonEncode(user.toJson()));
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'userType': userType.toString().split('.').last,
      'emailVerified': emailVerified,
      'phoneNumberVerified': phoneNumberVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  static Future<User?> getUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('user');
    if (user == null) {
      return null;
    }
    return User.fromJson(jsonDecode(user));
  }

  static User? fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      userType: UserType.values
          .firstWhere((e) => e.toString() == 'UserType.${json['userType']}'),
      emailVerified: json['emailVerified'],
      phoneNumberVerified: json['phoneNumberVerified'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? json['updatedAt'] is Timestamp
              ? (json['updatedAt'] as Timestamp).toDate()
              : DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
