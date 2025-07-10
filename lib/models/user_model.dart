import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'enums/user_type.dart';

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
  bool loginWithGoogle;
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
    this.loginWithGoogle = false,
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
      loginWithGoogle: map["loginWithGoogle"] as bool,
      phoneNumberVerified: map['phoneNumberVerified'] as bool,
      createdAt: map['createdAt'] != null
          ? _parseDate(map['createdAt'])
          : DateTime.now(),
      updatedAt: map['updatedAt'] != null
          ? _parseDate(map['updatedAt'])
          : DateTime.now(),
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
      'loginWithGoogle': loginWithGoogle,
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
      loginWithGoogle: json['loginWithGoogle'],
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

  static DateTime _parseDate(Object timeStamp) {
    if (timeStamp.runtimeType == DateTime) {
      return timeStamp as DateTime;
    } else if (timeStamp.runtimeType == String) {
      return DateTime.parse(timeStamp as String);
    } else {
      // We can throw Exception here but for now we will add current timestamp
      return Timestamp.now().toDate();
    }
  }
}
