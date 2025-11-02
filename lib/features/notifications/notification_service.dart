import 'dart:io';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';

/// ## NotificationService
/// A service class responsible for managing local notifications and scheduled alarms
/// in a Flutter application, primarily for Android devices. It uses 
/// `flutter_local_notifications` for displaying notifications and 
/// `android_alarm_manager_plus` for scheduling periodic tasks.
///
/// This class provides methods to:
/// - Initialize the notification plugin and alarm manager
/// - Request notification permissions
/// - Display immediate notifications
/// - Schedule periodic notifications at intervals of 5 minutes, 10 minutes, 1 hour, and 6 hours
/// - Dispose timers when they are no longer needed
///
/// ### Properties
/// - `_oneMinTimer`: Timer for one-minute periodic notifications (currently unused)
/// - `_fiveMinTimer`: Timer for five-minute periodic notifications
/// - `_tenMinTimer`: Timer for ten-minute periodic notifications
///
/// ### Methods
/// - `init()`: Initializes local notifications and the Android alarm manager.
/// - `requestPermission()`: Requests notification permission from the user (Android only).
/// - `showNotification({id, channelId, channelName, title, body})`: Shows an immediate notification with the specified details.
/// - `_callback5Min()`: Callback function to display a notification every 5 minutes.
/// - `_callback10Min()`: Callback function to display a notification every 10 minutes.
/// - `_callback1Hour()`: Callback function to display a notification every 1 hour.
/// - `_callback6Hour()`: Callback function to display a notification every 6 hours.
/// - `scheduleNotifications()`: Schedules periodic notifications using timers and Android alarm manager.
/// - `startNotifications()`: Requests permissions, triggers initial notifications, and starts scheduling periodic notifications.
/// - `dispose()`: Cancels all active timers to free resources.
///
/// ### Usage
/// ```dart
/// // Initialize the service
/// await NotificationService.init();
///
/// // Start notifications
/// await NotificationService.startNotifications();
///
/// // Dispose when no longer needed (e.g., on app close)
/// NotificationService.dispose();
/// ```


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationService {
  static Timer? _oneMinTimer;
  static Timer? _fiveMinTimer;
  static Timer? _tenMinTimer;

  static Future<void> init() async {
    if (Platform.isAndroid) {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const InitializationSettings settings =
          InitializationSettings(android: androidSettings);

      await flutterLocalNotificationsPlugin.initialize(settings);
    }

    await AndroidAlarmManager.initialize();
  }

  static Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.notification.status;
      if (!status.isGranted) {
        PermissionStatus result = await Permission.notification.request();
        if (!result.isGranted) {
          print("Notification permission not granted!");
        }
      }
    }
  }

  static Future<void> showNotification({
    required int id,
    required String channelId,
    required String channelName,
    String? title,
    String? body,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Scheduled notification',
      importance: Importance.high,
      priority: Priority.high,
    );

    final NotificationDetails details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? 'یادآوری خودکار',
      body ?? 'این نوتیفیکیشن زمان‌بندی شده است.',
      details,
    );
  }

  static Future<void> _callback5Min() async {
    await showNotification(
      id: 5,
      channelId: 'channel_5min',
      channelName: 'Every 5 Minutes',
      title: 'نوتیفیکیشن 5 دقیقه‌ای',
      body: 'این نوتیفیکیشن هر 5 دقیقه نمایش داده می‌شود.',
    );
  }

  static Future<void> _callback10Min() async {
    await showNotification(
      id: 10,
      channelId: 'channel_10min',
      channelName: 'Every 10 Minutes',
      title: 'نوتیفیکیشن 10 دقیقه‌ای',
      body: 'این نوتیفیکیشن هر 10 دقیقه نمایش داده می‌شود.',
    );
  }

  static Future<void> _callback1Hour() async {
    await showNotification(
      id: 2,
      channelId: 'channel_1hour',
      channelName: 'Every 1 Hour',
      title: 'نوتیفیکیشن 1 ساعته',
      body: 'این نوتیفیکیشن هر 1 ساعت نمایش داده می‌شود.',
    );
  }

  static Future<void> _callback6Hour() async {
    await showNotification(
      id: 3,
      channelId: 'channel_6hour',
      channelName: 'Every 6 Hours',
      title: 'نوتیفیکیشن 6 ساعته',
      body: 'این نوتیفیکیشن هر 6 ساعت نمایش داده می‌شود.',
    );
  }

  static Future<void> scheduleNotifications() async {
  

    _fiveMinTimer = Timer.periodic(
      const Duration(minutes: 5),
      (timer) async => await _callback5Min(),
    );

    _tenMinTimer = Timer.periodic(
      const Duration(minutes: 10),
      (timer) async => await _callback10Min(),
    );

    await AndroidAlarmManager.periodic(
      const Duration(hours: 1),
      2,
      _callback1Hour,
      wakeup: true,
      exact: true,
    );

    await AndroidAlarmManager.periodic(
      const Duration(hours: 6),
      3,
      _callback6Hour,
      wakeup: true,
      exact: true,
    );
  }

  static Future<void> startNotifications() async {
    await requestPermission();

    await _callback5Min();
    await _callback10Min();
    await _callback1Hour();
    await _callback6Hour();
    await scheduleNotifications();
  }

  static void dispose() {
    _oneMinTimer?.cancel();
    _fiveMinTimer?.cancel();
    _tenMinTimer?.cancel();
  }
}
