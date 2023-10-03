import 'package:insta_node_app/models/comment.dart';

abstract class CommentState {
  final List<Comment>? comments;
  final String? requestId;
  const CommentState({this.comments, this.requestId});
  @override
  List<Object?> get props => [];
}

class CommentStateInitial extends CommentState {}

class CommentStateLoading extends CommentState {}

class CommentStateError extends CommentState {
  final String error;
  CommentStateError({required this.error});
  @override
  List<Object?> get props => [error];
}

class CommentStateSuccess extends CommentState {
  final List<Comment> listComment;
  final String? successRequestId;
  CommentStateSuccess({
    required this.listComment,
    this.successRequestId,
  });
  @override
  List<Object?> get props => [listComment, successRequestId];
}
