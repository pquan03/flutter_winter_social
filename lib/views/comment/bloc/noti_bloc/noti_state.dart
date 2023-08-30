

import 'package:equatable/equatable.dart';
import 'package:insta_node_app/models/notify.dart';


class NotiState extends Equatable {
  const NotiState();
  @override
  List<Object?> get props => [];
}

final class NotiStateInitial extends NotiState {}
final class NotiStateLoading extends NotiState {}
class NotiStateSuccess extends NotiState {
  final List<Notify> listNoti;
  const NotiStateSuccess({required this.listNoti});
  @override
  List<Object?> get props => [listNoti];
}
class NotiStateError extends NotiState {
  final String error;
  const NotiStateError({required this.error});
  @override
  List<Object?> get props => [error];
}