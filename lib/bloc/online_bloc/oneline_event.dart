

import 'package:equatable/equatable.dart';

class OnlineEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnlineEventFetch extends OnlineEvent {
  final List<String> listUserId;
  OnlineEventFetch({required this.listUserId});
  @override
  List<Object> get props => [listUserId];
}