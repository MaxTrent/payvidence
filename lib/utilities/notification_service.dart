import 'dart:io';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
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
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Initialize Firebase (already called in main.dart, but safe to ensure)
    // await Firebase.initializeApp();

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
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

    // Request permissions for both local and push notifications
    await _requestPermissions();

    // Initialize Firebase Messaging
    // await _initializeFirebaseMessaging();
  }

  Future<void> _requestPermissions() async {
    if (Platform.isAndroid) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      // await _firebaseMessaging.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
    } else if (Platform.isIOS) {
      await _notificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      // await _firebaseMessaging.requestPermission(
      //   alert: true,
      //   badge: true,
      //   sound: true,
      // );
    }
  }

  // Future<void> _initializeFirebaseMessaging() async {
  //   String? token = await _firebaseMessaging.getToken();
  //   print('FCM Token: $token');
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     if (message.notification != null) {
  //       _displayPushNotification(message);
  //     }
  //   });
  //
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print('Notification tapped from background: ${message.notification?.title}');
  //     locator<PayvidenceAppRouter>().navigateNamed('/messages');
  //   });
  //
  //   _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
  //     if (message != null) {
  //       print('Notification tapped from terminated state: ${message.notification?.title}');
  //       locator<PayvidenceAppRouter>().navigateNamed('/messages');
  //     }
  //   });
  // }

  // Future<void> _displayPushNotification(RemoteMessage message) async {
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'push_channel',
  //     'Push Notifications',
  //     channelDescription: 'Channel for FCM push notifications',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //   const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
  //   const NotificationDetails platformDetails = NotificationDetails(
  //     android: androidDetails,
  //     iOS: iosDetails,
  //   );
  //
  //   await _notificationsPlugin.show(
  //     message.hashCode,
  //     message.notification?.title ?? 'No Title',
  //     message.notification?.body ?? 'No Body',
  //     platformDetails,
  //     payload: message.data['payload']?.toString(),
  //   );
  // }

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
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }
}