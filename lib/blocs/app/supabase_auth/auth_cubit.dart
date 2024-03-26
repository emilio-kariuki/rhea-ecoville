import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/utilities/packages.dart';
import 'package:equatable/equatable.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<SupabaseAuthState> {
  AuthCubit() : super(AuthInitial());

  final AuthProvider _authProvider = AuthProvider();

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      emit(AuthLoading());
      final response =
          await _authProvider.signInWithEmailAndPassword(email, password);
      if (response.user != null) {
        emit(AuthSuccess(response.user!));
      } else {
        emit(const AuthError("Something went wrong"));
      }
    } catch (e) {
      emit(AuthError(e.toString().toException()));
    }
  }

  Future<void> signUpWithEmailAndPassword(
      String email, String name, String password) async {
    try {
      emit(AuthLoading());
      final response =
          await _authProvider.signUpWithEmailAndPassword(email, name, password);
      if (response.user != null) {
        emit(AuthSuccess(response.user!));
      } else {
        emit(const AuthError("Something went wrong"));
      }
    } catch (e) {
      emit(AuthError(e.toString().toException()));
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());
      final response = await _authProvider.signInWithGoogle();
      if (response.user != null) {
        emit(AuthSuccess(response.user!));
      } else {
        emit(const AuthError('Something went wrong'));
      }
    } catch (e) {
      emit(AuthError(e.toString().toException()));
    }
  }

  // Future<void> signInWithGithub() async {
  //   try {
  //     emit(AuthLoading());
  //     final response = await _authProvider.signInWithGithub();
  //     if (response) {
  //       emit(AuthSuccess(response.user!));
  //     } else {
  //       emit(const AuthError('Something went wrong'));
  //     }
  //   } catch (e) {
  //     emit(AuthError(e.toString().toException()));
  //   }
  // }

  Future<void> signOut() async {
    emit(AuthLoading());
    final response = await _authProvider.signOut();
    if (response) {
      emit(AuthInitial());
    } else {
      emit(const AuthError('Failed to sign out'));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    final response = await _authProvider.sendPasswordResetEmail(email);
    if (response) {
      emit(PasswordResetEmailSent());
    } else {
      emit(const AuthError('Failed to send password reset email'));
    }
  }
}
