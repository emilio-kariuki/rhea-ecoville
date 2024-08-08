import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';

/// `AuthCubit` class manages the state and operations related to user authentication.
/// This class extends `Cubit<AuthenticationState>` and handles various authentication
/// actions such as sign-in, sign-out, account creation, and password reset.
class AuthCubit extends Cubit<AuthenticationState> {
  final _authProvider = service<AuthProvider>(); // Initializing AuthProvider using service locator.
  AuthCubit() : super(AuthenticationState()); // Constructor initializing the cubit with an initial state.


  /// Method to sign in the user with Google authentication.
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading)); // Set state to loading.
    try {
      await _authProvider.signInWithGoogle(); // Call the provider to sign in with Google.
      emit(state.copyWith(
          status: AuthStatus.success, message: "Sign in success"));
    } catch (e) {
      emit(state.copyWith(status: AuthStatus.success, message: e.toString()));
    }
  }

   /// Method to sign out the user from the application.
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

  /// Method to create a new account with email and password.
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

  /// Method to reset the user's password using their email.
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

  /// Method to sign in the user with email and password.
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

/// Enum representing the possible states of authentication operations.
enum AuthStatus { initial, loading, success }

/// `AuthenticationState` class to represent the state of authentication operations.
class AuthenticationState {
  final AuthStatus status; // Current status of the authentication operation.
  final String message; // Message for displaying status or errors.

  AuthenticationState({
    this.status = AuthStatus.initial,
    this.message = '',
  });

  /// Method to create a copy of the current state with updated properties.
   AuthenticationState copyWith({
    AuthStatus? status,
    String? message,
  }) {
    return AuthenticationState(
      status: status ?? this.status, // Keeping current status if not provided.
      message: message ?? this.message, // Keeping current message if not provided.
    );
  }
}
