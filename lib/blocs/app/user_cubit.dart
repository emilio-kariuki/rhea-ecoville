import 'package:ecoville/data/provider/user_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/user_model.dart';
import 'package:ecoville/utilities/packages.dart';

class UserCubit extends Cubit<UserState> {
  final _userProvider = service<UserProvider>();
  UserCubit() : super(UserState());

  Future<void> getUser() async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = await _userProvider.getUser();
      emit(state.copyWith(user: user, status: UserStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.success, message: e.toString()));
    }
  }

  Future<void> updateUser({required UserModel user}) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final updatedUser = await _userProvider.updateUser(user: user);
      emit(state.copyWith(user: updatedUser, status: UserStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.success, message: e.toString()));
    }
  }

  Future<void> getUserById({required String id}) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final user = await _userProvider.getUserById(id: id);
      emit(state.copyWith(user: user, status: UserStatus.success));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.success, message: e.toString()));
    }
  }

}

enum UserStatus { initial, loading, success }

class UserState {
  final UserModel? user;
  final UserStatus status;
  final String message;

  UserState({
    this.user,
    this.status = UserStatus.initial,
    this.message = '',
  });

  UserState copyWith({
    UserModel? user,
    UserStatus? status,
    String? message,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
