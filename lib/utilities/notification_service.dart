import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:payvidence/shared_dependency/shared_dependency.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../routes/payvidence_app_router.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {

    await Firebase.initializeApp();


    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print('Notification tapped: ${response.payload}');
        if (response.payload != null) {
          locator<PayvidenceAppRouter>().navigateNamed('/messages');
        }
      },
    );

    tz.initializeTimeZones();


    await _requestPermissions();


    await _initializeFirebaseMessaging();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);


      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        announcement: false,
      );

      print('Notification permission status: ${settings.authorizationStatus}');

      // Add a small delay to allow the system to process the permission
      await Future.delayed(Duration(milliseconds: 1000));
    }
  }

  Future<void> _initializeFirebaseMessaging() async {
    try {
      // Wait for APNs token with retry mechanism
      String? apnsToken = await _getAPNSTokenWithRetry();

      if (apnsToken != null) {
        print('APNs Token: $apnsToken');


        String? token = await _firebaseMessaging.getToken();
        print('FCM Token: $token');


        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          if (message.notification != null) {
            _displayPushNotification(message);
          }
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('Notification tapped from background: ${message.notification?.title}');
          locator<PayvidenceAppRouter>().navigateNamed('/messages');
        });

        _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
          if (message != null) {
            print('Notification tapped from terminated state: ${message.notification?.title}');
            locator<PayvidenceAppRouter>().navigateNamed('/messages');
          }
        });
      } else {
        print('Failed to obtain APNs token after retries');

      }
    } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }

  Future<String?> _getAPNSTokenWithRetry() async {
    String? apnsToken;
    int retryCount = 0;
    const maxRetries = 10;
    const retryDelay = Duration(milliseconds: 500);

    while (apnsToken == null && retryCount < maxRetries) {
      try {
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken == null) {
          print('APNs token not available yet, retrying... (${retryCount + 1}/$maxRetries)');
          await Future.delayed(retryDelay);
          retryCount++;
        }
      } catch (e) {
        print('Error getting APNs token: $e');
        await Future.delayed(retryDelay);
        retryCount++;
      }
    }

    return apnsToken;
  }


  Future<void> _displayPushNotification(RemoteMessage message) async {
    try {
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'push_channel',
        'Push Notifications',
        channelDescription: 'Channel for FCM push notifications',
        importance: Importance.max,
        priority: Priority.high,
      );
      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notificationsPlugin.show(
        message.hashCode,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        platformDetails,
        payload: message.data['payload']?.toString(),
      );
    } catch (e) {
      print('Error displaying push notification: $e');
    }
  }
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'general_channel',
      'General Notifications',
      channelDescription: 'Channel for general app notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformDetails,
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Channel for scheduled notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }
}