import 'package:ecoville/data/provider/auth_provider.dart';
import 'package:ecoville/utilities/packages.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  final AuthProvider _authProvider = AuthProvider();

  Future<void> appStarted() async {
    emit(AuthenticationLoading());
    final response = await _authProvider.isSignedIn();
    debugPrint('isSignedIn: $response');
    if (response) {
      emit(Authenticated());
    } else {
      emit(Unauthenticated());
    }
  }
}
