

import 'package:equatable/equatable.dart';

class ChatEvent extends Equatable {
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