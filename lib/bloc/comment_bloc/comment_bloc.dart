

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_event.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_state.dart';
import 'package:insta_node_app/models/comment.dart';
import 'package:insta_node_app/recources/comment_api.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentStateInitial()) {
    on<CommentEventFetch>(_onGetComments);
    on<CreateCommentEvent>(_onCreateComment);
    on<CreateReplyEvent> (_onCreateReply);
  }
  List<Comment> _comments = [];
  List<Comment> get items => _comments;

  void _onGetComments(CommentEventFetch event, Emitter<CommentState> emit) async {
    emit(CommentStateLoading());
    final res = await CommentApi().getCommentsByPostId(event.postId);
    if (res is List) {
    _comments.addAll([...res]);
      emit(CommentStateSuccess(listComment: _comments));
    } else {
      emit(CommentStateError(error: res));
    }
  }

  void _onCreateComment(CreateCommentEvent event, Emitter<CommentState> emit) async {
    var data = {
      'content': event.content,
      'postId': event.postId,
    };
    final res = await CommentApi().createComment(data, event.token);
    if (res is String) {
      emit(CommentStateError(error: res));
    } else {
      _comments.insert(0, res);
      emit(CommentStateSuccess(listComment: _comments ));
    }
  }

  void _onCreateReply(CreateReplyEvent event, Emitter<CommentState> emit) async {
    var data = {
      'content': event.content,
      'postId': event.postId,
      'tag': event.tag,
    };
    final res = await CommentApi().createReplyComment(event.commentRootId, data, event.token);
    if (res is String) {
      emit(CommentStateError(error: res));
    } else {
      _comments = _comments.map((e) {
        if (e.sId == event.commentRootId) {
          e.reply!.insert(0, res);
        }
        return e;
      }).toList();
      emit(CommentStateSuccess(listComment: _comments ));
    }
  }
}