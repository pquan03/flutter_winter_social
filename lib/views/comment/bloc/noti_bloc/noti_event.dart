

import 'package:equatable/equatable.dart';
import 'package:insta_node_app/models/notify.dart';

class NotiEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotiEventFetch extends NotiEvent {
  final String token;
  final bool? isRefresh;
  NotiEventFetch({required this.token, this.isRefresh});
  @override
  List<Object?> get props => [token];
}


class NotiEventAdd extends NotiEvent {
  final Notify notify;
  NotiEventAdd({required this.notify});
  @override
  List<Object?> get props => [notify];
}