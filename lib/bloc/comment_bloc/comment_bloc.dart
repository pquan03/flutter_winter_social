import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_event.dart';
import 'package:insta_node_app/bloc/comment_bloc/comment_state.dart';
import 'package:insta_node_app/recources/comment_api.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  CommentBloc() : super(CommentStateInitial()) {
    on<CommentEventFetch>(_onGetComments);
    on<CreateCommentEvent>(_onCreateComment);
    on<CreateReplyEvent>(_onCreateReply);
  }

  void _onGetComments(
      CommentEventFetch event, Emitter<CommentState> emit) async {
    print(event.postId);
    final currentState = this.state is CommentStateSuccess ? this.state : null;
    if (currentState?.requestId != null &&
        currentState?.requestId == event.postId) {
      print('requestId: ${currentState?.requestId} - postId: ${event.postId}');
      return;
    }
    emit(CommentStateLoading());
    await Future.delayed(Duration(milliseconds: 300));
    if (event.type == 'post') {
      final res =
          await CommentApi().getCommentsByPostId(event.postId, event.token);
      if (res is List) {
        emit(CommentStateSuccess(
            listComment: [...currentState?.comments ?? [], ...res],
            successRequestId: event.postId));
      } else {
        emit(CommentStateError(error: res));
      }
    } else {
      final res =
          await CommentApi().getCommentsByReelId(event.postId, event.token);
      if (res is List) {
        emit(CommentStateSuccess(
            listComment: [...currentState?.comments ?? [], ...res],
            successRequestId: event.postId));
      } else {
        emit(CommentStateError(error: res));
      }
    }
  }

  void _onCreateComment(
      CreateCommentEvent event, Emitter<CommentState> emit) async {
    var data = {
      'content': event.content,
      'postId': event.postId,
    };
    if (event.type == 'post') {
      final res = await CommentApi().createCommentPost(data, event.token);
      if (res is String) {
        emit(CommentStateError(error: res));
      } else {
        final state = this.state as CommentStateSuccess;
        emit(CommentStateSuccess(listComment: [...state.listComment, res]));
      }
    } else {
      final res = await CommentApi().createCommentReel(data, event.token);
      if (res is String) {
        emit(CommentStateError(error: res));
      } else {
        final state = this.state as CommentStateSuccess;
        emit(CommentStateSuccess(listComment: [...state.listComment, res]));
      }
    }
  }

  void _onCreateReply(
      CreateReplyEvent event, Emitter<CommentState> emit) async {
    var data = {
      'content': event.content,
      'postId': event.postId,
      'tag': event.tag,
    };
    final res = await CommentApi()
        .createReplyComment(event.commentRootId, data, event.token);
    if (res is String) {
      emit(CommentStateError(error: res));
    } else {
      final state = this.state as CommentStateSuccess;
      final listComments = state.listComment;
      final temp = listComments.map((e) {
        if (e.sId == event.commentRootId) {
          e.reply!.insert(0, res);
        }
        return e;
      }).toList();
      emit(CommentStateSuccess(listComment: temp));
    }
  }
}
