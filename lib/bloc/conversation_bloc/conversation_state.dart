

import 'package:insta_node_app/models/conversation.dart';

abstract class ConversationState {
  final List<Conversations>? conversations;
  const ConversationState({this.conversations});
  
  @override
  List<Object?> get props => [];
}

class ConversationInitial extends ConversationState {}
class ConversationLoading extends ConversationState {}
class ConversationError extends ConversationState {
  final String message;
  const ConversationError({required this.message});
  @override
  List<Object?> get props => [message];
}

class ConversationSuccess extends ConversationState {
  final List<Conversations>? listConversation;
  const ConversationSuccess({this.listConversation});
  @override
  List<Object?> get props => [listConversation];
}
