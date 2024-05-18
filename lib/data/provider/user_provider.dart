import 'package:ecoville/data/repository/user_repository.dart';
import 'package:ecoville/models/product_model.dart';
import 'package:ecoville/models/user_model.dart';

class UserProvider extends UserTemplate {
  final UserRepository _userRepository;
  UserProvider({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Future<bool> createUser({required UserModel user}) {
    return _userRepository.createUser(user: user);
  }

  @override
  Future<UserModel> getUser() {
    return _userRepository.getUser();
  }

  @override
  Future<UserModel> updateUser({required UserModel user}) {
    return _userRepository.updateUser(user: user);
  }

  @override
  Future<List<ProductModel>> getProductsPosted() {
    return _userRepository.getProductsPosted();
  }

  @override
  Future<List<ProductModel>> getProductsSaved() {
    return _userRepository.getProductsSaved();
  }
}