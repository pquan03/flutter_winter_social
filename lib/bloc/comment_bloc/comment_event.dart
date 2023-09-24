



import 'package:equatable/equatable.dart';
import 'package:insta_node_app/models/post.dart';

class CommentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CommentEventFetch extends CommentEvent {
  final String postId;
  final String token;
  final String type;
  CommentEventFetch({required this.postId, required this.token, required this.type});
  @override
  List<Object?> get props => [postId, token];
}


class CreateCommentEvent extends CommentEvent {
  final String postId;
  final String content;
  final String token;
  final String type;
  CreateCommentEvent({required this.postId, required this.content, required this.token, required this.type});
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
