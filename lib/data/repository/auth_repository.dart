import 'package:ecoville/data/local/local_storage.dart';
import 'package:ecoville/data/provider/notification_provider.dart';
import 'package:ecoville/data/provider/user_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/user_model.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class AuthTemplate {
  Future<bool> isSignedIn();
  Future<bool> signInWithGoogle();
  Future<bool> signOut();
}

class AuthRepository extends AuthTemplate {
  final _userService = service<UserProvider>();
  final _notificationService = service<NotificationProvider>();
  @override
  Future<bool> isSignedIn() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> signInWithGoogle() async {
    try {
      const webClientId =
          '593038226855-9sig16n4amih1hg6egik5rps21m5u4iq.apps.googleusercontent.com';
      const iosClientId =
          '593038226855-iq9b65tu6bohevl82a5qj8gffdg87uli.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
        clientId: iosClientId,
        serverClientId: webClientId,
      );
      final googleUser = await googleSignIn.signIn();
      final googleAuth = await googleUser!.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found.';
      }
      if (idToken == null) {
        throw 'No ID Token found.';
      }

      AuthResponse response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      final token = await _notificationService.getNotificationToken();
      await _userService.createUser(
        user: UserModel(
          id: response.user!.id,
          name: response.user!.userMetadata?['full_name'],
          email: response.user!.email!,
          image: response.user!.userMetadata?['avatar_url'],
          token: token,
        ),
      );
      return true;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await supabase.auth.signOut();
      await LocalStorageManager(await SharedPreferences.getInstance())
          .remove('email');
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
