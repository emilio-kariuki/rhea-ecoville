import 'package:ecoville/data/repository/auth_repository.dart';
import 'package:ecoville/utilities/packages.dart';

class AuthProvider extends AuthTemplate {
  @override
  Future<bool> isSignedIn() {
    return AuthRepository().isSignedIn();
  }
  @override
  Future<bool> sendPasswordResetEmail(String email) {
    return AuthRepository().sendPasswordResetEmail(email);
  }

  @override
  Future<AuthResponse> signInWithEmailAndPassword(
      String email, String password) {
    return AuthRepository().signInWithEmailAndPassword(email, password);
  }

  @override
  Future<AuthResponse> signInWithGoogle() {
    return AuthRepository().signInWithGoogle();
  }

  @override
  Future<bool> signOut() {
    return AuthRepository().signOut();
  }

  @override
  Future<AuthResponse> signUpWithEmailAndPassword(
      String email, String name,String password) async {
    return AuthRepository().signUpWithEmailAndPassword(email,name, password);
  }
}
