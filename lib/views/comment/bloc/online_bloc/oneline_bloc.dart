

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/views/comment/bloc/online_bloc/oneline_event.dart';

class OnlineBloc extends Bloc<OnlineEvent, List<String>> {
  OnlineBloc() : super([]) {
    on<OnlineEventFetch>(_onGetOnline);
  }

  void _onGetOnline(OnlineEventFetch event, Emitter<List<String>> emit) async {
    final state = this.state;
    emit([...state, ...event.listUserId]);
  }
}