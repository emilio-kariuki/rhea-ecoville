import 'package:ecoville/models/messages/conversation_model.dart';
import 'package:ecoville/models/messages/message_response.dart';
import 'package:ecoville/utilities/packages.dart';

abstract class MessageTemplate {
  Future<bool> createConversation({required String sellerId});
  Future<bool> sendMessage({required String message, required String conversationId,required String sellerId});
  Future<List<MessageResponseModel>> getMessages({required String conversationId});
  Future<List<ConversationModel>> getConversations();
}

class MessageRepository implements MessageTemplate {
  @override
  Future<List<MessageResponseModel>> getMessages(
      {required String conversationId}) async {
    try {
      final response = await supabase
          .from(TABLE_MESSAGE)
          .select('ecoville_user(*), *')
          .eq(
            'conversationsId',
            conversationId,
          )
          .order('createdAt', ascending: true);
        debugPrint("response: $response");
      final messages = response.map((e) {
        debugPrint(e.toString());
        return MessageResponseModel.fromJson(e);
      }).toList();
      debugPrint("all messages: $messages");
      return messages;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> sendMessage(
      {required String message, required String conversationId, required String sellerId}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await supabase.from(TABLE_MESSAGE).insert({
        'id': "${const Uuid().v4()}_$userId",
        'userId': userId,
        'sellerId': sellerId,
        'message': message,
        'conversationsId':conversationId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<bool> createConversation({required String sellerId}) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      debugPrint("userId: $userId");
      await supabase.from(TABLE_CONVERSATIONS).insert({
        'id': "${sellerId}_$userId",
        'userId': userId,
        'sellerId': sellerId,
        'message': 'Hello, I am interested in your product',
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      debugPrint("error: $e");
      throw Exception(e);
    }
  }

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase
          .from(TABLE_CONVERSATIONS)
          .select('ecoville_user(*), *')
          .ilike("id", '%$userId%')
          .order('createdAt', ascending: true);
      final messages =
          response.map((e) => ConversationModel.fromJson(e)).toList();
      debugPrint("response: $messages");
      return messages;
    } catch (e) {
      throw Exception(e);
    }
  }
}
