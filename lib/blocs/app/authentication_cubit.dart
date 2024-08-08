import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';

/// `AuthenticationCubit` manages the state related to user authentication status.
/// This class extends `Cubit<AuthenticationState>` and handles the app's initial
/// authentication checks and onboarding status.
class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthProvider _authProvider = service<AuthProvider>();
  AuthenticationCubit() : super(AuthenticationState()); // Constructor initializing the cubit with an initial unauthenticated state.

  /// Method to be called when the app starts. This checks if the user is signed in
  /// and if they have completed onboarding.
  Future<void> appStarted() async {
    final response = await _authProvider.isSignedIn(); // Check if the user is signed in by calling the AuthProvider.
    
    // Check if the user has completed onboarding by reading the 'onboarded' value from SharedPreferences.
    final isOnboarded = await SharedPreferences.getInstance().then((value) {
      return value.getBool('onboarded') ?? false;  // Defaults to false if not found.
    });
    if (!isOnboarded) {
      emit(
        AuthenticationState(status: AuthenticationStatus.notOnboarded),
      );
      return;
    }

    // Debug print to check the sign-in status.
    debugPrint('isSignedIn: $response');
    if (response == true && isOnboarded == true) {
      emit(
        AuthenticationState(status: AuthenticationStatus.authenticated),
      );
    } else {
      emit(
        AuthenticationState(status: AuthenticationStatus.unAuthenticated),
      );
    }
  }
}

enum AuthenticationStatus { unAuthenticated, authenticated, notOnboarded }

class AuthenticationState {
  final AuthenticationStatus status;
  AuthenticationState({this.status = AuthenticationStatus.unAuthenticated});

  AuthenticationState copyWith({AuthenticationStatus? status}) {
    return AuthenticationState(status: status ?? this.status);
  }
}
