import 'package:ecoville/data/provider/app_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/search_model.dart';
import 'package:ecoville/utilities/packages.dart';

class AppCubit extends Cubit<AppState> {
  final _appProvider = service<AppProvider>();
  AppCubit() : super(AppState());

  void setLoading() => emit(state.copyWith(status: AppStatus.loading));
  void setSuccess() => emit(state.copyWith(status: AppStatus.success));
  void setError(String message) =>
      emit(state.copyWith(status: AppStatus.success, message: message));

  Future<void> launchBrowser(String url) async {
    try {
      setLoading();
      await _appProvider.launchBrowser(url: url);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> launchEmail(String email) async {
    try {
      setLoading();
      await _appProvider.launchEmail(email: email);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> launchPhone(String phone) async {
    try {
      setLoading();
      await _appProvider.launchPhone(phone: phone);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> launchSMS(String phone, String text) async {
    try {
      setLoading();
      await _appProvider.launchSms(phone: phone, text: text);
      setSuccess();
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> insertSearch({required String name}) async {
    try {
      setLoading();
      await _appProvider.insertSearch(name: name);
      emit(state.copyWith(
          status: AppStatus.success, message: "Search has been added"));
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> getSearchList() async {
    try {
      setLoading();
      final searches = await _appProvider.getSearchList();
      emit(state.copyWith(
          status: AppStatus.success,
          searches: searches,
          message: "Search has been fetched"));
    } catch (e) {
      setError(e.toString());
    }
  }

  Future<void> clearSearch() async {
    try {
      setLoading();
      await _appProvider.clearSearchList();
      emit(state.copyWith(
          status: AppStatus.success, message: "Search has been cleared"));
    } catch (e) {
      setError(e.toString());
    }
  }
}

enum AppStatus { initial, loading, success }

class AppState {
  final AppStatus status;
  final List<SearchModel> searches;
  final String message;

  AppState({
    this.status = AppStatus.initial,
    this.searches = const [],
    this.message = '',
  });

  AppState copyWith({
    AppStatus? status,
    List<SearchModel>? searches,
    String? message,
  }) {
    return AppState(
      status: status ?? this.status,
      searches: searches ?? this.searches,
      message: message ?? this.message,
    );
  }
}
