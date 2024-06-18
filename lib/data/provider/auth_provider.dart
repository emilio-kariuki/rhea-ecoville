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
  
  @override
  Future<bool> createAccountWithEmailPassword({required String email, required String password, required String name, required String phone}) {
    return _authRepository.createAccountWithEmailPassword(email: email, password: password, name: name, phone: phone);
  }
  
  @override
  Future<bool> resetPassword({required String email}) {
    return _authRepository.resetPassword(email: email);
  }
  
  @override
  Future<bool> signInWithEmailPassword({required String email, required String password}) {
    return _authRepository.signInWithEmailPassword(email: email, password: password);
  }
}
