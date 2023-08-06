
import 'package:equatable/equatable.dart';

class ConversationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConversationEventFectch extends ConversationEvent {
  final String token;
  ConversationEventFectch({ required this.token});
  @override
  List<Object> get props => [token];
}

class ConversationEventRead extends ConversationEvent {
  final String conversationId;
  final String token;
  ConversationEventRead({ required this.token, required this.conversationId});
  @override
  List<Object> get props => [token, conversationId];
}