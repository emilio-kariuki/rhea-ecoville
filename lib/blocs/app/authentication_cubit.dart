import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/utilities/packages.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final AuthProvider _authProvider = service<AuthProvider>();
  AuthenticationCubit() : super(AuthenticationState());

  Future<void> appStarted() async {
    final response = await _authProvider.isSignedIn();
    final isOnboarded = await SharedPreferences.getInstance().then((value) {
      return value.getBool('onboarded') ?? false;
    });
    if (!isOnboarded) {
      emit(
        AuthenticationState(status: AuthenticationStatus.notOnboarded),
      );
      return;
    }
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
