import 'package:ecoville/data/repository/notification_repository.dart';
import 'package:ecoville/models/notification_model.dart';

class NotificationProvider extends NotificationTemplate {
  final NotificationRepository _notificationRepository;
  NotificationProvider({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository;

  @override
  Future<String> getNotificationToken() {
    return _notificationRepository.getNotificationToken();
  }

  @override
  Future<void> initializeNotifications() {
    return _notificationRepository.initializeNotifications();
  }

  @override
  Future<void> sendNotification({required String title, required String body}) {
    return _notificationRepository.sendNotification(title: title, body: body);
  }

  @override
  Future<void> sendImageNotification(
      {required String title, required String body, required String imageUrl}) {
    return _notificationRepository.sendImageNotification(
        title: title, body: body, imageUrl: imageUrl);
  }

  @override
  Future<bool> deleteNotification({required String id}) {
    return _notificationRepository.deleteNotification(id: id);
  }

  @override
  Future<List<NotificationModel>> getNotifications() {
    return _notificationRepository.getNotifications();
  }

  @override
  Future<bool> readAllNotifications() {
    return _notificationRepository.readAllNotifications();
  }

  @override
  Future<bool> readNotification({required String id}) {
    return _notificationRepository.readNotification(id: id);
  }
}
