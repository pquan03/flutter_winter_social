

import 'package:equatable/equatable.dart';
import 'package:insta_node_app/models/conversation.dart';


abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

final class ChatStateInitial extends ChatState {}
final class ChatStateLoading extends ChatState {}
class ChatStateSuccess extends ChatState {
  final List<Conversations> listConversation;
  const ChatStateSuccess({required this.listConversation});
  @override
  List<Object?> get props => [listConversation];
}
class ChatStateError extends ChatState {
  final String error;
  const ChatStateError({required this.error});
  @override
  List<Object?> get props => [error];
}