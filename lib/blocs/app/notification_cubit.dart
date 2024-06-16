import 'package:ecoville/data/provider/notification_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/notification_model.dart';
import 'package:ecoville/utilities/packages.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final _notificationProvider = service<NotificationProvider>();

  NotificationCubit() : super(NotificationState());

  Future<void> getNotificationToken() async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final notificationToken =
          await _notificationProvider.getNotificationToken();
      emit(state.copyWith(
          status: NotificationStatus.success,
          notificationToken: notificationToken));
    } catch (e) {
      emit(state.copyWith(
          status: NotificationStatus.error, message: e.toString()));
    }
  }

  Future<void> initializeNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      await _notificationProvider.initializeNotifications();
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: NotificationStatus.error, message: e.toString()));
    }
  }

  Future<void> sendNotification(
      {required String title, required String body}) async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      await _notificationProvider.sendNotification(title: title, body: body);
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: NotificationStatus.error, message: e.toString()));
    }
  }

  Future<void> getAllNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      final notifications = await _notificationProvider.getNotifications();
      final unreadNotifications =
          notifications.where((element) => element.isRead == false).toList();
      final readNotifications =
          notifications.where((element) => element.isRead == true).toList();
      emit(state.copyWith(
          status: NotificationStatus.success,
          notifications: notifications,
          unreadNotifications: unreadNotifications,
          readNotifications: readNotifications));
    } catch (e) {
      emit(state.copyWith(
          status: NotificationStatus.error, message: e.toString()));
    }
  }

  Future<void> readAllNotifications() async {
    try {
      await _notificationProvider.readAllNotifications();
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: NotificationStatus.error, message: e.toString()));
    }
  }

   Future<void> readNotification({required String id}) async {
    try {
      await _notificationProvider.readNotification(id: id);
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: NotificationStatus.error, message: e.toString()));
    }
  }



}

enum NotificationStatus { initial, loading, success, error }

class NotificationState {
  final NotificationStatus status;
  final String notificationToken;
  final List<NotificationModel> notifications;
  final List<NotificationModel> unreadNotifications;
  final List<NotificationModel> readNotifications;
  final String message;

  NotificationState({
    this.notifications = const [],
    this.unreadNotifications = const [],
    this.readNotifications = const [],
    this.status = NotificationStatus.initial,
    this.notificationToken = '',
    this.message = '',
  });

  NotificationState copyWith({
    NotificationStatus? status,
    String? notificationToken,
    List<NotificationModel>? notifications,
    List<NotificationModel>? unreadNotifications,
    List<NotificationModel>? readNotifications,
    String? message,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notificationToken: notificationToken ?? this.notificationToken,
      notifications: notifications ?? this.notifications,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      readNotifications: readNotifications ?? this.readNotifications,
      message: message ?? this.message,
    );
  }
}
