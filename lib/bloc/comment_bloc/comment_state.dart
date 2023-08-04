

import 'package:insta_node_app/models/comment.dart';

abstract class CommentState {
  final List<Comment>? comments;
  const CommentState({this.comments});
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
  CommentStateSuccess({required this.listComment}): super(comments: listComment);
  @override
  List<Object?> get props => [comments];
}
