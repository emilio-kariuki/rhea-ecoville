import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';

class AuthCubit extends Cubit<AuthenticationState> {
  final _authProvider = service<AuthProvider>();
  AuthCubit() : super(AuthenticationState());

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      await _authProvider.signInWithGoogle();
      emit(state.copyWith(
          status: AuthStatus.success, message: "Sign in success"));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.success, message: e.toString()));
    }
  }

  Future<void> signOut() async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _authProvider.signOut();
      if (response) {
        emit(state.copyWith(
            status: AuthStatus.success, message: "Sign out success"));
      } else {
        emit(state.copyWith(status: AuthStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.success, message: e.toString()));
    }
  }

  Future<void> createAccountWithEmailPassword(
      {required String email,
      required String password,
      required String name,
      required String phone,
      }) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _authProvider.createAccountWithEmailPassword(
          email: email, password: password, name: name, phone: phone);
      if (response) {
        emit(state.copyWith(
            status: AuthStatus.success, message: "Account created"));
      } else {
        emit(state.copyWith(status: AuthStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.success, message: e.toString()));
    }
  }

  Future<void> resetPassword({required String email}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _authProvider.resetPassword(email: email);
      if (response) {
        emit(state.copyWith(
            status: AuthStatus.success, message: "Reset password success"));
      } else {
        emit(state.copyWith(status: AuthStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.success, message: e.toString()));
    }
  }

  Future<void> signInWithEmailPassword(
      {required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final response = await _authProvider.signInWithEmailPassword(
          email: email, password: password);
      if (response) {
        emit(state.copyWith(
            status: AuthStatus.success, message: "Sign in success"));
      } else {
        emit(state.copyWith(status: AuthStatus.success));
      }
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.success, message: e.toString()));
    }
  }
}

enum AuthStatus { initial, loading, success }

class AuthenticationState {
  final AuthStatus status;
  final String message;

  AuthenticationState({
    this.status = AuthStatus.initial,
    this.message = '',
  });

  AuthenticationState copyWith({
    AuthStatus? status,
    String? message,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
