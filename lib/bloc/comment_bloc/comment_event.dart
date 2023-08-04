



import 'package:equatable/equatable.dart';
import 'package:insta_node_app/models/post.dart';

class CommentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommentEventFetch extends CommentEvent {
  final String postId;
  CommentEventFetch({required this.postId});
  @override
  List<Object?> get props => [postId];
}


class CreateCommentEvent extends CommentEvent {
  final String postId;
  final String content;
  final String token;
  CreateCommentEvent({required this.postId, required this.content, required this.token});
  @override
  List<Object?> get props => [postId, content, token];
}

class CreateReplyEvent extends CommentEvent {
  final String commentRootId;
  final String postId;
  final String content;
  final UserPost tag;
  final String token;
  CreateReplyEvent({required this.postId, required this.content, required this.token, required this.tag, required this.commentRootId});
  @override
  List<Object?> get props => [postId, content, token, tag, commentRootId];
}
