import 'package:ecoville/data/repository/socket_repository.dart';

class SocketProvider extends SocketTemplate {
  final SocketRepository _socketRepository;
  SocketProvider({required SocketRepository socketRepository})
      : _socketRepository = socketRepository;

  @override
  Future<void> connect() {
    return _socketRepository.connect();
  }

  @override
  Future<void> disconnect() {
    return _socketRepository.disconnect();
  }

  @override
  // TODO: implement messageStream
  Stream<String> get messageStream => throw UnimplementedError();

  @override
  Future<void> sendMessage(String message) {
    return _socketRepository.sendMessage(message);
  }
}
