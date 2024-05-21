import 'package:ecoville/utilities/packages.dart';

class AppCubit extends Cubit<AppState>{
  AppCubit() : super(AppState());

}

enum AppStatus { initial, loading, success }

class AppState {
  final AppStatus status;
  final String message;

  AppState({
    this.status = AppStatus.initial,
    this.message = '',
  });

  AppState copyWith({
    AppStatus? status,
    String? message,
  }) {
    return AppState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}