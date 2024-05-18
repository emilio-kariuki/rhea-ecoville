import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';

class AuthCubit extends Cubit<AuthState> {
  final _authProvider = service<AuthProvider>();
  AuthCubit() : super(AuthState());

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
}

enum AuthStatus { initial, loading, success }

class AuthState {
  final AuthStatus status;
  final String message;

  AuthState({
    this.status = AuthStatus.initial,
    this.message = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
