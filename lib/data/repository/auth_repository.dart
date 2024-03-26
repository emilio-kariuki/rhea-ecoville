import 'package:ecoville/data/local/local_storage.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class AuthTemplate {
  Future<bool> isSignedIn();
  Future<AuthResponse> signInWithEmailAndPassword(
      String email, String password);
  Future<AuthResponse> signUpWithEmailAndPassword(
      String email, String name, String password);
  Future<AuthResponse> signInWithGoogle();
  Future<bool> signInWithGithub();
  Future<bool> sendPasswordResetEmail(String email);
  Future<bool> signOut();
}

class AuthRepository extends AuthTemplate {
  @override
  Future<bool> isSignedIn() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      return false;
    }
    return true;
  }

  @override
  Future<AuthResponse> signUpWithEmailAndPassword(
      String email, String name, String password) async {
    try {
      final AuthResponse response =
          await supabase.auth.signUp(email: email, password: password);
      await supabase.from('user').insert({
        'id': response.user!.id,
        'email': email,
        'name': name,
        'picture': AppImages.defaultImage,
      });
      await LocalStorageManager(await SharedPreferences.getInstance())
          .saveString('email', email);
      return response;
    } on AuthException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.message);
    }
  }

  @override
  Future<AuthResponse> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResponse response = await supabase.auth
          .signInWithPassword(password: password, email: email);
      return response;
    } on AuthException catch (e) {
      debugPrint(e.toString());
      throw Exception(e.message);
    }
  }

  @override
  Future<bool> signInWithGithub() async {
    try {
      final  response = await supabase.auth.signInWithOAuth(
        OAuthProvider.github,
        redirectTo: 'https://www.ecoville.site',
        // authScreenLaunchMode: LaunchMode.
      );
      return response;
      
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<AuthResponse> signInWithGoogle() async {
    // secret - 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
    // id - 203502494436-hqg1vh46cpqqhpsg5vqvecb96vs6dbpf.apps.googleusercontent.com
    try {
      const webClientId =
          '203502494436-hqg1vh46cpqqhpsg5vqvecb96vs6dbpf.apps.googleusercontent.com';
      const iosClientId =
          '203502494436-hm4jnoru8i7ml1ir7jn5fh8efpki1oql.apps.googleusercontent.com';

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
      return response;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await supabase.auth.resetPasswordForEmail(email);
      return true;
    } catch (error) {
      debugPrint(error.toString());
      return false;
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
