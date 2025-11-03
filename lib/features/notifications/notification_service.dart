import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
class NotificationService {
  static const int _id5Min = 5;
  static const int _id10Min = 10;
  static const int _id1Hour = 2;
  static const int _id6Hour = 3;

  static bool _isInitialized = false;
  static bool _isScheduled = false;
  static Future<void> init() async {
    if (_isInitialized) return;
    _isInitialized = true;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(settings);
    await AndroidAlarmManager.initialize();

    if (Platform.isAndroid) {
      await _requestExactAlarmPermission();
    }

    print("NotificationService: Initialized");
  }

  static Future<void> _requestExactAlarmPermission() async {
    try {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null &&
          !(await androidPlugin.canScheduleExactNotifications() ?? true)) {
        await androidPlugin.requestExactAlarmsPermission();
      }
    } catch (e) {
      print("Exact alarm error: $e");
    }
  }

  static Future<void> requestPermission() async {
    if (!Platform.isAndroid) return;
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      final result = await Permission.notification.request();
      print(
        result.isGranted
            ? "POST_NOTIFICATIONS granted"
            : "POST_NOTIFICATIONS denied",
      );
    }
  }

  static Future<void> showNotification({
    required int id,
    required String channelId,
    required String channelName,
    String? title,
    String? body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'scheduled_notifications',
          'Scheduled Notifications',
          channelDescription: 'نوتیفیکیشن‌های زمان‌بندی شده',
          importance: Importance.high,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title ?? 'یادآوری خودکار',
      body ?? 'این نوتیفیکیشن زمان‌بندی شده است.',
      details,
    );

    print("NotificationService: Shown ID=$id");
  }

  @pragma('vm:entry-point')
  static Future<void> _callback5Min() async =>
      _showScheduled(_id5Min, '5 دقیقه', 'هر 5 دقیقه');

  @pragma('vm:entry-point')
  static Future<void> _callback10Min() async =>
      _showScheduled(_id10Min, '10 دقیقه', 'هر 10 دقیقه');

  @pragma('vm:entry-point')
  static Future<void> _callback1Hour() async =>
      _showScheduled(_id1Hour, '1 ساعت', 'هر 1 ساعت');

  @pragma('vm:entry-point')
  static Future<void> _callback6Hour() async =>
      _showScheduled(_id6Hour, '6 ساعت', 'هر 6 ساعت');

  static Future<void> _showScheduled(
    int id,
    String interval,
    String body,
  ) async {
    await showNotification(
      id: id,
      channelId: 'channel_$id',
      channelName: 'Every $interval',
      title: 'نوتیفیکیشن $interval',
      body: 'این نوتیفیکیشن $body نمایش داده می‌شود.',
    );
  }

  static Future<void> scheduleNotifications() async {
    if (_isScheduled) {
      print("Already scheduled. Skipping.");
      return;
    }

    final config = [
      _AlarmConfig(_id5Min, Duration(minutes: 5), _callback5Min),
      _AlarmConfig(_id10Min, Duration(minutes: 10), _callback10Min),
      _AlarmConfig(_id1Hour, Duration(hours: 1), _callback1Hour),
      _AlarmConfig(_id6Hour, Duration(hours: 6), _callback6Hour),
    ];

    for (final c in config) {
      try {
        final success = await AndroidAlarmManager.periodic(
          c.duration,
          c.id,
          c.callback,
          startAt: DateTime.now().add(const Duration(seconds: 5)),
          wakeup: true,
          exact: true,
          allowWhileIdle: true,
          rescheduleOnReboot: true,
        );
        print("Scheduled ${c.duration.inMinutes}min (ID: ${c.id}) -> $success");
      } catch (e) {
        print("Failed to schedule ID ${c.id}: $e");
      }
    }

    _isScheduled = true;
  }

  static Future<void> start() async {
    try {
      await init();
      await requestPermission();
      await _callback5Min();
      await _callback10Min();
      await scheduleNotifications();
      print("NotificationService: Started successfully");
    } catch (e, stack) {
      print("Start failed: $e\n$stack");
    }
  }

  static Future<void> cancelAll() async {
    final ids = [_id5Min, _id10Min, _id1Hour, _id6Hour];
    for (final id in ids) {
      try {
        await AndroidAlarmManager.cancel(id);
        print("Cancelled ID: $id");
      } catch (e) {
        print("Failed to cancel ID $id: $e");
      }
    }
    _isScheduled = false;
  }
}

class _AlarmConfig {
  final int id;
  final Duration duration;
  final Function callback;
  _AlarmConfig(this.id, this.duration, this.callback);
}
