part of 'auth_cubit.dart';

sealed class SupabaseAuthState extends Equatable {
  const SupabaseAuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends SupabaseAuthState {}

final class AuthLoading extends SupabaseAuthState {}

final class AuthSuccess extends SupabaseAuthState {
  final User user;

  const AuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

final class PasswordResetEmailSent extends SupabaseAuthState {}

final class AuthError extends SupabaseAuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
