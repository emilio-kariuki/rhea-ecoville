import 'package:ecoville/data/provider/message_provider.dart';
import 'package:ecoville/data/service/service_locator.dart';
import 'package:ecoville/models/messages/conversation_model.dart';
import 'package:ecoville/models/messages/message_response.dart';
import 'package:ecoville/utilities/packages.dart';

class MessageCubit extends Cubit<MessageState> {
  final _messageProvider = service<MessageProvider>();
  MessageCubit() : super(MessageState());

  Future<void> getMessages({required String conversationId}) async {
    emit(state.copyWith(status: MessageStatus.loading));
    try {
      final messages =
          await _messageProvider.getMessages(conversationId: conversationId);
      emit(state.copyWith(status: MessageStatus.success, messages: messages));
    } catch (e) {
      emit(state.copyWith(status: MessageStatus.error, messages: []));
    }
  }

  Future<void> sendMessage({
    required String message,
    required String sellerId,
    required String conversationId,
  }) async {
    emit(state.copyWith(status: MessageStatus.loading));
    try {
      await _messageProvider.sendMessage(
          message: message, sellerId: sellerId, conversationId: conversationId);
      emit(state.copyWith(status: MessageStatus.success));
    } catch (e) {
      emit(state.copyWith(status: MessageStatus.error));
    }
  }

  Future<void> createConversation({required String sellerId}) async {
    emit(state.copyWith(status: MessageStatus.loading));
    try {
      await _messageProvider.createConversation(sellerId: sellerId);
      emit(state.copyWith(status: MessageStatus.success));
    } catch (e) {
      emit(state.copyWith(status: MessageStatus.error));
    }
  }

  Future<void> getConversations() async {
    emit(state.copyWith(status: MessageStatus.loading));
    try {
      final conversations = await _messageProvider.getConversations();
      emit(state.copyWith(
        status: MessageStatus.success,
        conversations: conversations,
      ));
    } catch (e) {
      emit(state.copyWith(status: MessageStatus.error));
    }
  }
}

enum MessageStatus { initial, loading, success, error }

class MessageState {
  final MessageStatus status;
  final List<MessageResponseModel> messages;
  final List<ConversationModel> conversations;

  MessageState({
    this.status = MessageStatus.initial,
    this.messages = const [],
    this.conversations = const [],
  });

  MessageState copyWith(
      {MessageStatus? status,
      List<MessageResponseModel>? messages,
      List<ConversationModel>? conversations}) {
    return MessageState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      conversations: conversations ?? this.conversations,
    );
  }
}
