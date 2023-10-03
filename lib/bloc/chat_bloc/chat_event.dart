import 'package:equatable/equatable.dart';
import 'package:insta_node_app/models/message.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatEventFetch extends ChatEvent {
  final String token;
  final bool? isRefresh;
  ChatEventFetch({required this.token, this.isRefresh});
  @override
  List<Object?> get props => [token];
}

class ChatEventAddMessage extends ChatEvent {
  final Messages message;
  ChatEventAddMessage({required this.message});
  @override
  List<Object?> get props => [message];
}
