import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/bloc/conversation_bloc/conversation_event.dart';
import 'package:insta_node_app/bloc/conversation_bloc/conversation_state.dart';
import 'package:insta_node_app/models/conversation.dart';
import 'package:insta_node_app/recources/message_api.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc() : super(ConversationInitial()) {
    on<ConversationEventFectch>(_onGetConversations);
    on<ConversationEventRead>(_onReadConversation);
  }
  List<Conversations> _conversations = [];
  List<Conversations> get conversations => _conversations;

  void _onGetConversations(
      ConversationEventFectch event, Emitter<ConversationState> emit) async {
    emit(ConversationLoading());
    if (_conversations.isNotEmpty) _conversations.clear();
    final res = await MessageApi().getConversations(event.token);
    if (res is List) {
      _conversations.addAll([...res]);
      emit(ConversationSuccess(listConversation: _conversations));
    } else {
      emit(ConversationError(message: res));
    }
  }

  void _onReadConversation(
      ConversationEventRead event, Emitter<ConversationState> emit) async {
    await MessageApi().readMessage(event.conversationId, event.token);
    _conversations = _conversations.map((e) {
      if (e.sId == event.conversationId) {
        e.isRead = true;
      }
      return e;
    }).toList();
    emit(ConversationSuccess(listConversation: _conversations));
  }
}
