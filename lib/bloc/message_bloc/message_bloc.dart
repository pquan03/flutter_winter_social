import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/bloc/message_bloc/message_event.dart';
import 'package:insta_node_app/bloc/message_bloc/message_state.dart';
import 'package:insta_node_app/models/message.dart';
import 'package:insta_node_app/recources/message_api.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc() : super(MessageStateInitial()) {
    on<MessageEventFecth>(_onGetMessages);
    on<CreateMessageEvent>(_onCreateMessage);
  }
  final List<Messages> _messages = [];
  List<Messages> get messages => _messages;

  void _onGetMessages(
      MessageEventFecth event, Emitter<MessageState> emit) async {
    emit(MessageStateLoading());
    if(_messages.isNotEmpty) return;
    final res = await MessageApi().getMessages(event.userId, event.token);
    if (res is List) {
      _messages.addAll([...res]);
      emit(MessageStateSuccess(listMessage: _messages));
    } else {
      emit(MessageStateError(error: res));
    }
  }

  void _onCreateMessage(CreateMessageEvent event, Emitter<MessageState> emit) async {
    final res = await MessageApi().createMessage(event.data, event.token);
    if (res is Messages) {
      _messages.insert(0, res);
      emit(MessageStateSuccess(listMessage: _messages));
    } else {
      emit(MessageStateError(error: res));
    }
  }
}
