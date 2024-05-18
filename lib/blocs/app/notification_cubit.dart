import 'package:ecoville/data/provider/notification_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
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
          status: NotificationStatus.success, message: e.toString()));
    }
  }

  Future<void> initializeNotifications() async {
    emit(state.copyWith(status: NotificationStatus.loading));
    try {
      await _notificationProvider.initializeNotifications();
      emit(state.copyWith(status: NotificationStatus.success));
    } catch (e) {
      emit(state.copyWith(
          status: NotificationStatus.success, message: e.toString()));
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
          status: NotificationStatus.success, message: e.toString()));
    }
  }
}

enum NotificationStatus { initial, loading, success }

class NotificationState {
  final NotificationStatus status;
  final String notificationToken;
  final String message;

  NotificationState({
    this.status = NotificationStatus.initial,
    this.notificationToken = '',
    this.message = '',
  });

  NotificationState copyWith({
    NotificationStatus? status,
    String? notificationToken,
    String? message,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notificationToken: notificationToken ?? this.notificationToken,
      message: message ?? this.message,
    );
  }
}
