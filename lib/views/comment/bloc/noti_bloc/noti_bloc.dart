import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/views/comment/bloc/noti_bloc/noti_event.dart';
import 'package:insta_node_app/views/comment/bloc/noti_bloc/noti_state.dart';

class NotiBloc extends Bloc<NotiEvent, NotiState> {
  NotiBloc() : super(NotiStateInitial()) {
    on<NotiEventFetch>(_onFetch);
    on<NotiEventAdd>(_onAddItem);
  }

  void _onFetch(NotiEventFetch event, Emitter<NotiState> emit) async {
    if (event.isRefresh == null) {
      final state = this.state;
      if (state is NotiStateSuccess) {
        if (state.listNoti.isEmpty) {
          emit(NotiStateSuccess(listNoti: [...state.listNoti]));
        } else {
          return;
        }
      } else {
        emit(NotiStateLoading());
      }
    }
    emit(NotiStateLoading());
    try {
      final listNoti = await NotifiApi().getNotifications(event.token);
      emit(NotiStateSuccess(listNoti: [...listNoti]));
    } catch (e) {
      emit(NotiStateError(error: e.toString()));
    }
  }

  void _onAddItem(NotiEventAdd event, Emitter<NotiState> emit) async {
    final state = this.state;
    if(state is NotiStateSuccess){
      try {
        emit(NotiStateSuccess(listNoti: [...state.listNoti, event.notify]));
      } catch(err) {
        emit(NotiStateError(error: err.toString()));
      }
    }
  }
}
