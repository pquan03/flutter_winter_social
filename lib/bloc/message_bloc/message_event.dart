


import 'package:equatable/equatable.dart';

class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object?> get props => [];
}

class MessageEventFecth extends MessageEvent {
  final String userId;
  final String token;
  const MessageEventFecth({required this.userId, required this.token});

  @override
  List<Object?> get props => [userId, token];
}

class CreateMessageEvent extends MessageEvent {
  final Map<String, dynamic> data;
  final String token;
  const CreateMessageEvent({required this.data, required this.token});
  @override
  List<Object?> get props => [data];
}