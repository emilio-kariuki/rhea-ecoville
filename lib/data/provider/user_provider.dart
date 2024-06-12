import 'package:ecoville/data/repository/user_repository.dart';
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
  Future<bool> sendUserInteractions({required String userId, required String interaction, required String productId}) {
    // TODO: implement sendUserInteractions
    throw UnimplementedError();
  }
  
  @override
  Future<UserModel> getUserById({required String id}) {
    return _userRepository.getUserById(id: id);
  }

}
