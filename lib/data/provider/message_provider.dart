import 'package:ecoville/data/repository/message_repository.dart';
import 'package:ecoville/models/messages/conversation_model.dart';
import 'package:ecoville/models/messages/message_response.dart';

class MessageProvider extends MessageTemplate {
  final MessageRepository _messageRepository;
  MessageProvider({required MessageRepository messageRepository})
      : _messageRepository = messageRepository;

  @override
  Future<List<MessageResponseModel>> getMessages({required String conversationId}) {
    return _messageRepository.getMessages(conversationId: conversationId);
  }

  @override
  Future<bool> sendMessage(
      {required String message, required String sellerId,required String conversationId,}) {
    return _messageRepository.sendMessage(message: message, sellerId: sellerId, conversationId: conversationId);
  }
  
  @override
  Future<bool> createConversation({required String sellerId}) {
    return _messageRepository.createConversation(sellerId: sellerId);
  }

  @override
  Future<List<ConversationModel>> getConversations() {
    return _messageRepository.getConversations();
  }
}
