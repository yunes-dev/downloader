import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handeleBachgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
  print('----------------------------------------------------------1');
  ApiFireBase().ininLocalNotification();
}
//token cixVXGfWSi-W86gCibKXoa:APA91bHQQ2XOM20nvjU6u-yid1uGl522gF0fIdOMR-HumPk1mD-DD3Dx8iWobftacYgyGAV6H5JqDQHOQw8Vej5I2kTBFncnG-uUEyk85sTA1yNSgBm94QNhK-L820KdPWVRCNXxS2f8

class ApiFireBase {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
      'default_notification_channel_id', 'default_notification_channel_id',
      description: 'this is channel', importance: Importance.high);
  final _localNotification = FlutterLocalNotificationsPlugin();

  void hendleMessage(RemoteMessage? message) {
    if (message == null) return;
    print('----------------------------------------------------------4');
    // novigatorKey.currentState?.pushNamed(HomeScreen.route, arguments: message);
  }

  Future<void> initPushNotification() async {
    Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(hendleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(hendleMessage);
    FirebaseMessaging.onBackgroundMessage(handeleBachgroundMessage);
    FirebaseMessaging.onMessage.listen((event) {
      final notification = event.notification;
      if (notification == null) return;
      _localNotification.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                enableVibration: true,
                vibrationPattern: Int64List.fromList(vibrationPattern),
                //onlyAlertOnce: true,
                importance: Importance.max,
                priority: Priority.max,
                icon: '@mipmap/ic_launcher')),
        payload: jsonEncode(event.toMap()),
      );
    });
  }

  void ininLocalNotification() async {
    print('----------------------------------------------------------2');
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const setting = InitializationSettings(android: android);
    await _localNotification.initialize(
      setting,
      onDidReceiveBackgroundNotificationResponse: (details) {
        //  final message=RemoteMessage.fromMap(jsonDecode(details.));
      },
    );
    final platform = _localNotification.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
    //initPushNotification();
  }

  Future<void> inilizedFirebaseMessaging() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      print('token $fCMToken');
      print('----------------------------------------------------------2');
      //ininLocalNotification();
      initPushNotification();
    } catch (e) {}
  }
}
