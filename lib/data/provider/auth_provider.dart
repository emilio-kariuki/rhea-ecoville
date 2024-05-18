import 'package:ecoville/data/repository/auth_repository.dart';

class AuthProvider extends AuthTemplate {
  final AuthRepository _authRepository;
  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository;
  @override
  Future<bool> isSignedIn() {
    return _authRepository.isSignedIn();
  }

  @override
  Future<bool> signInWithGoogle() {
    return _authRepository.signInWithGoogle();
  }

  @override
  Future<bool> signOut() {
    return _authRepository.signOut();
  }
}
