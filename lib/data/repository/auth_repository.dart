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
          '377119171510-chp0j4b1u1f638ajsosufe39cc8ha3qk.apps.googleusercontent.com';
      const iosClientId =
          '377119171510-66892ga8mr2q9e02akq47efjj28of08v.apps.googleusercontent.com';

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
