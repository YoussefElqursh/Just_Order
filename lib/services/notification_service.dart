import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final Dio _dio = Dio();

  static Future<void> initialize(String email) async {
    try {
      await FirebaseMessaging.instance.requestPermission(
        criticalAlert: true,
        provisional: true,
      );
      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      debugPrint(
        'Permission granted: ${settings.authorizationStatus}',
      );

      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        await _sendTokenToServer(
          email,
          token,
        );
      } else {
        // Log the error
        debugPrint("Token is null");
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          'Received message while in foreground: ${message.notification?.title}',
        );
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint(
          'Message opened: ${message.notification?.body}',
        );
      });
    } catch (e) {
      debugPrint(
        "Error while initialize notification service with error ${e.toString()}",
      );
    }
  }

  static Future<void> _sendTokenToServer(String email, String token) async {
    const String endpoint = 'http://192.168.1.114:5001/register_fcm_token';

    try {
      final response = await _dio.post(
        endpoint,
        data: {
          'email': email,
          'fcm_token': token,
          'user_type': 'client',
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint(
        'Server response: ${response.statusCode} ${response.data}',
      );
    } catch (e) {
      debugPrint('Failed to send token: $e');
    }
  }
}
