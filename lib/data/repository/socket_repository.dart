import 'package:ecoville/utilities/packages.dart';

abstract class SocketTemplate {
  Future<void> connect();
  Future<void> disconnect();
  Future<void> sendMessage(String message);
  Stream<String> get messageStream;
}

// Socket socket = io('https://84.247.174.84/ecoville/');
// Socket socket = io(
//     'http://localhost:4003',
//     OptionBuilder().setTransports(['websocket']) // For Flutter or Dart VM
//         .setExtraHeaders({
//       'user': supabase.auth.currentUser!.id,
//     }) // Optional: Extra headers
//         .build());

class SocketRepository extends SocketTemplate {
  @override
  Future<void> connect() async {
    try {
      // socket.io.options!['extraHeaders'] = {
      //   'user': supabase.auth.currentUser!.id,
      //   'email': supabase.auth.currentUser!.email,
      // };
      // socket.connect();
      
      // socket.onConnectError((data) {
      //   debugPrint('Connection error: $data');
      // });
      // socket.onConnectTimeout((data) {
      //   debugPrint('Connection timeout: $data');
      // });
      // socket.onDisconnect((data) {
      //   debugPrint('Disconnected: $data');
      // });
      return;
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> disconnect() {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  // TODO: implement messageStream
  Stream<String> get messageStream => throw UnimplementedError();

  @override
  Future<void> sendMessage(String message) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }
}
