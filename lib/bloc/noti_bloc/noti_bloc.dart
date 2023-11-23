import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/bloc/noti_bloc/noti_event.dart';
import 'package:insta_node_app/bloc/noti_bloc/noti_state.dart';

class NotiBloc extends Bloc<NotiEvent, NotiState> {
  NotiBloc() : super(NotiStateInitial()) {
    on<NotiEventFetch>(_onFetch);
    on<NotiEventAdd>(_onAddItem);
    on<NotiEventRead>(_onRead);
  }

  void _onFetch(NotiEventFetch event, Emitter<NotiState> emit) async {
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
    if (state is NotiStateSuccess) {
      try {
        emit(NotiStateSuccess(listNoti: [...state.listNoti, event.notify]));
      } catch (err) {
        emit(NotiStateError(error: err.toString()));
      }
    }
  }

  void _onRead(NotiEventRead event, Emitter<NotiState> emit) async {
    final state = this.state;
    if (state is NotiStateSuccess) {
      try {
        final listNoti = [...state.listNoti];
        final index =
            listNoti.indexWhere((element) => element.sId == event.notiId);
        await NotifiApi().readNotifi(event.notiId, event.token);
        if (index != -1) {
          listNoti[index].isRead = true;
          emit(NotiStateSuccess(listNoti: [...listNoti]));
        }
      } catch (err) {
        emit(NotiStateError(error: err.toString()));
      }
    }
  }
}
