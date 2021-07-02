import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    "High Importance Notifcations",
    "This channel is used important notification",
    groupId: "Notification_group");

final FlutterLocalNotificationsPlugin flutterLocalNotificationplugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message : ${message.messageId}");
  print(message.data);
}

class FirebaseNotification {
  initialize() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationplugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var intializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
        print('id: $id, title: $title, body: $body');
      },
    );
    var initializationSettings =
    InitializationSettings(android: intializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationplugin.initialize(initializationSettings);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    requestPermissionNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        AndroidNotificationDetails notificationDetails =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: channel.groupId);
        NotificationDetails notificationDetailsPlatformSpefics =
        NotificationDetails(android: notificationDetails);
        flutterLocalNotificationplugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            notificationDetailsPlatformSpefics);
      }

      List<ActiveNotification> activeNotifications =
      await flutterLocalNotificationplugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.getActiveNotifications();
      if (activeNotifications.length > 0) {
        List<String> lines =
        activeNotifications.map((e) => e.title.toString()).toList();
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            lines,
            contentTitle: "${activeNotifications.length - 1} messages",
            summaryText: "${activeNotifications.length - 1} messages");
        AndroidNotificationDetails groupNotificationDetails =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            styleInformation: inboxStyleInformation,
            setAsGroupSummary: true,
            groupKey: channel.groupId);

        NotificationDetails groupNotificationDetailsPlatformSpefics =
        NotificationDetails(android: groupNotificationDetails);
        await flutterLocalNotificationplugin.show(
            0, '', '', groupNotificationDetailsPlatformSpefics);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        AndroidNotificationDetails notificationDetails =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: channel.groupId);
        NotificationDetails notificationDetailsPlatformSpefics =
        NotificationDetails(android: notificationDetails);
        flutterLocalNotificationplugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            notificationDetailsPlatformSpefics);
      }

      List<ActiveNotification> activeNotifications =
      await flutterLocalNotificationplugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.getActiveNotifications();
      if (activeNotifications.length > 0) {
        List<String> lines =
        activeNotifications.map((e) => e.title.toString()).toList();
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            lines,
            contentTitle: "${activeNotifications.length - 1} messages",
            summaryText: "${activeNotifications.length - 1} messages");
        AndroidNotificationDetails groupNotificationDetails =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            styleInformation: inboxStyleInformation,
            setAsGroupSummary: true,
            groupKey: channel.groupId);

        NotificationDetails groupNotificationDetailsPlatformSpefics =
        NotificationDetails(android: groupNotificationDetails);
        await flutterLocalNotificationplugin.show(
            0, '', '', groupNotificationDetailsPlatformSpefics);
      }
    });
    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        AndroidNotificationDetails notificationDetails =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            importance: Importance.max,
            priority: Priority.high,
            groupKey: channel.groupId);
        NotificationDetails notificationDetailsPlatformSpefics =
        NotificationDetails(android: notificationDetails);
        flutterLocalNotificationplugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            notificationDetailsPlatformSpefics);
      }

      List<ActiveNotification> activeNotifications =
      await flutterLocalNotificationplugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.getActiveNotifications();
      if (activeNotifications.length > 0) {
        List<String> lines =
        activeNotifications.map((e) => e.title.toString()).toList();
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            lines,
            contentTitle: "${activeNotifications.length - 1} messages",
            summaryText: "${activeNotifications.length - 1} messages");
        AndroidNotificationDetails groupNotificationDetails =
        AndroidNotificationDetails(
            channel.id, channel.name, channel.description,
            styleInformation: inboxStyleInformation,
            setAsGroupSummary: true,
            groupKey: channel.groupId);

        NotificationDetails groupNotificationDetailsPlatformSpefics =
        NotificationDetails(android: groupNotificationDetails);
        await flutterLocalNotificationplugin.show(
            0, '', '', groupNotificationDetailsPlatformSpefics);
      }
    });
  }

  Future<String> getToken() async {
    String token = await FirebaseMessaging.instance.getToken();
    print(token);
    return token;
  }

  Future<void> requestPermissionNotification() async{
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}