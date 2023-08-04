


import 'package:insta_node_app/models/message.dart';

abstract class MessageState {
  final List<Messages>? messages;
  const MessageState({this.messages});

  @override
  List<Object?> get props => [];
}

class MessageStateInitial extends MessageState {}
class MessageStateLoading extends MessageState {}
class MessageStateError extends MessageState {
  final String error;
  MessageStateError({required this.error});
  @override
  List<Object?> get props => [error];
}

class MessageStateSuccess extends MessageState {
  final List<Messages> listMessage;
  MessageStateSuccess({required this.listMessage}): super(messages: listMessage);
  @override
  List<Object?> get props => [messages];
}