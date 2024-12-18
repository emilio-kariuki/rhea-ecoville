import 'package:dio/dio.dart';
import 'package:ecoville/data/repository/app_repository.dart';
import 'package:ecoville/models/notification_model.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

int id = 0;

abstract class NotificationTemplate {
  Future<void> initializeNotifications();
  Future<void> sendNotification({required String title, required String body});
  Future<void> sendImageNotification(
      {required String title, required String body, required String imageUrl});
  Future<String> getNotificationToken();
  Future<List<NotificationModel>> getNotifications();
  Future<bool> deleteNotification({required String id});
  Future<bool> readNotification({required String id});
  Future<bool> readAllNotifications();
}

class NotificationRepository extends NotificationTemplate {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late AndroidNotificationChannel channel;
  NotificationRepository() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    channel = const AndroidNotificationChannel(
      'fcm',
      'Low Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('ecoville');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
      ),
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: false,
    );
  }

  @override
  Future<String> getNotificationToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      debugPrint('The firebase messaging token is: $token');
      return token!;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception('Error getting firebase messaging token');
    }
  }

  @override
  Future<void> initializeNotifications() async {
    try {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: false,
      );
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
            "Foreground Message received: ${message.notification!.title}");
        sendNotification(
          body: message.data['message'] ?? message.notification!.body,
          title: message.data['title'] ?? message.notification!.title!,
        );
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint(
            "Background Message received: ${message.notification!.body}");
        sendNotification(
          body: message.data['message'] ?? message.contentAvailable.toString(),
          title: message.data['title'] ?? message.notification!.title!,
        );
      });
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception("Error initializing firebase messaging");
    }
  }

  @override
  Future<void> sendNotification({required String title, required String body}) {
    return flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "2",
          'normal Notifications',
          channelDescription: "This is the notifications normal channel",
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
    );
  }

  @override
  Future<void> sendImageNotification(
      {required String title,
      required String body,
      required String imageUrl}) async {
    try {
      final String bigPicturePath = await AppRepository()
          .downloadAndSaveFile(url: imageUrl, fileName: 'bigPicture');
      final BigPictureStyleInformation bigPictureStyleInformation =
          BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
              // largeIcon: FilePathAndroidBitmap(largeIconPath),
              contentTitle: title,
              htmlFormatContentTitle: true,
              summaryText: body,
              htmlFormatSummaryText: true);
      final AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails("fcm", 'normal Notifications',
              channelDescription: "This is the notifications normal channel",
              styleInformation: bigPictureStyleInformation);
      final NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          id++, 'big text title', 'silent body', notificationDetails);
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception("Error sending image notification");
    }
  }

  @override
  Future<bool> deleteNotification({required String id}) async {
    try {
      await supabase.from(TABLE_NOTIFICATION).delete().eq("id", id);
      return true;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception("Error deleting notification");
    }
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await Dio().get(
          "$API_URL/notification",
          options: Options(headers: {
            "APIKEY": API_KEY,
            "user": supabase.auth.currentUser!.id
          }));
      final notifications = response.data
          .map((e) => NotificationModel.fromJson(e))
          .toList()
          .cast<NotificationModel>();
      return notifications;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception("Error getting notifications");
    }
  }

  @override
  Future<bool> readAllNotifications() async {
    try {
      final response = await supabase.from(TABLE_NOTIFICATION).select();
      final notifications =
          response.map((e) => NotificationModel.fromJson(e)).toList();
      for (var notification in notifications) {
        await supabase
            .from(TABLE_NOTIFICATION)
            .update({"isRead": true}).eq("id", notification.id);
      }
      return true;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception("Error reading all notifications");
    }
  }

  @override
  Future<bool> readNotification({required String id}) async {
    try {
      await supabase
          .from(TABLE_NOTIFICATION)
          .update({"isRead": true}).eq("id", id);
      return true;
    }   catch (e, stackTrace) {
      await Sentry.captureException(
        e,
        stackTrace: stackTrace,
      );
      debugPrint(e.toString());
      throw Exception("Error reading notification");
    }
  }
}
