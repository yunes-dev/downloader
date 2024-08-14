import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationUtils {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  AndroidNotificationDetails? androidNotificationDetails(
      int taskId, double progress, bool show) {
    const int maxProgress = 100;
    return AndroidNotificationDetails(
      taskId.toString(), //channel id
      'Showing channel', //channel name
      channelDescription: 'channel description',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: show,
      playSound: true,
      enableVibration: false,
      maxProgress: maxProgress,
      onlyAlertOnce: true, //play sound on start done
      progress: progress.toInt(),
      ongoing: false, // Make the notification ongoing to prevent dismissal
      sound: const RawResourceAndroidNotificationSound(
          ''), // Set sound to an empty string
    );
  }

  DarwinNotificationDetails iosPlatformChannelSpecifics =
      DarwinNotificationDetails(
    presentSound: false,
    presentBadge: false,
    presentAlert: false,
  );
  Future<void> showStatetNotification(
      {required int taskId,
      required String title,
      required double progress,
      required String body}) async {
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails(taskId, progress, false),
        iOS: iosPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      taskId,
      title,
      body,
      platformChannelSpecifics,
    );
  }

  Future<void> showProgressNotification({
    required int taskId,
    required String title,
    required double progress,
  }) async {
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidNotificationDetails(taskId, progress, true),
        iOS: iosPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      taskId,
      title,
      'Download progress: ${progress.toStringAsFixed(2)}%',
      platformChannelSpecifics,
    );
  }

  static Future<void> cancelNotification(int taskId) async {
    debugPrint('cance id $taskId');
    await _flutterLocalNotificationsPlugin.cancel(taskId);
  }
}
