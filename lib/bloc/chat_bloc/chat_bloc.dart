import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/recources/message_api.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_event.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatStateInitial()) {
    on<ChatEventFetch>(_onFetch);
    on<ChatEventAddMessage>(_onAddMessage);
  }

  void _onFetch(ChatEventFetch event, Emitter<ChatState> emit) async {
    if (event.isRefresh == null) {
      final state = this.state;
      if (state is ChatStateSuccess) {
        if (state.listConversation.isEmpty) {
          emit(ChatStateSuccess(listConversation: [...state.listConversation]));
        } else {
          return;
        }
      } else {
        emit(ChatStateLoading());
      }
    }
    emit(ChatStateLoading());
    try {
      final listConversation = await MessageApi().getConversations(event.token);
      emit(ChatStateSuccess(listConversation: [...listConversation]));
    } catch (e) {
      emit(ChatStateError(error: e.toString()));
    }
  }

  void _onAddMessage(ChatEventAddMessage event, Emitter<ChatState> emit) {
    final state = this.state;
    if (state is ChatStateSuccess) {
      final listConversation = [...state.listConversation];
      final conversation = listConversation
          .firstWhere((element) => element.sId == event.message.conversationId);
      conversation.isRead = ['${event.message.senderId}'];
      conversation.messages!.insert(0, event.message);
      listConversation.removeWhere(
          (element) => element.sId == event.message.conversationId);
      listConversation.insert(0, conversation);
      emit(ChatStateSuccess(listConversation: [...listConversation]));
    }
  }
}
