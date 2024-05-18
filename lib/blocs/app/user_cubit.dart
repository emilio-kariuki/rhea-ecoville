import 'package:ecoville/data/provider/user_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/product_model.dart';
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

  Future<void> getProductsPosted() async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final products = await _userProvider.getProductsPosted();
      emit(
          state.copyWith(status: UserStatus.success, productsPosted: products));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.success, message: e.toString()));
    }
  }

  Future<void> getProductsSaved() async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      final products = await _userProvider.getProductsSaved();
      emit(state.copyWith(status: UserStatus.success, productsSaved: products));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.success, message: e.toString()));
    }
  }
}

enum UserStatus { initial, loading, success }

class UserState {
  final UserModel? user;
  final List<ProductModel> productsPosted;
  final List<ProductModel> productsSaved;
  final UserStatus status;
  final String message;

  UserState({
    this.user,
    this.productsPosted = const <ProductModel>[],
    this.productsSaved = const <ProductModel>[],
    this.status = UserStatus.initial,
    this.message = '',
  });

  UserState copyWith({
    UserModel? user,
    List<ProductModel>? productsPosted,
    List<ProductModel>? productsSaved,
    UserStatus? status,
    String? message,
  }) {
    return UserState(
      user: user ?? this.user,
      productsPosted: productsPosted ?? this.productsPosted,
      productsSaved: productsSaved ?? this.productsSaved,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
