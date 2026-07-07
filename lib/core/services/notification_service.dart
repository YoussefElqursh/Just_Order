import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final Dio _dio = Dio();

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize(String email) async {
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

      // Init local notifications
      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon'); // your icon name (no extension)
      const InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
      );
      await _localNotificationsPlugin.initialize(settings: initializationSettings);


      String? token = await FirebaseMessaging.instance.getToken();
      await _sendTokenToServer(
        email,
        token ?? '',
      );
    
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          'Received message while in foreground: ${message.notification?.title}',
        );

        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;

        if (notification != null && android != null) {
          _localNotificationsPlugin.show(
            id: notification.hashCode,
            title: notification.title,
            body: notification.body,
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'default_channel',
                'Default Channel',
                channelDescription: 'Used for important notifications',
                icon: '@mipmap/launcher_icon', // <- your custom icon
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
          );
        }
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

  Future<void> _sendTokenToServer(String email, String token) async {
    const String endpoint = 'https://notify.justorder-eg.com/register_fcm_token';

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
          followRedirects: false, // <== handle redirect manually
          validateStatus: (status) => status != null && status < 400, // accept 307
        ),
      );

      if (response.statusCode == 307) {
        final redirectUrl = response.headers.value('location');
        debugPrint('🔁 Redirecting to: $redirectUrl');

        if (redirectUrl != null) {
          final redirectedResponse = await _dio.post(
            redirectUrl,
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
            '✅ Redirected response: ${redirectedResponse.statusCode} ${redirectedResponse.data}',
          );
        } else {
          debugPrint('⚠️ 307 Redirect received but no `Location` header found.');
        }
      } else {
        debugPrint(
          '✅ Server response: ${response.statusCode} ${response.data}',
        );
      }
    } catch (e) {
      debugPrint('❌ Failed to send token: $e');
    }
  }
}
