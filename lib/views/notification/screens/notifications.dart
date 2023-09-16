import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/notify.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/utils/time_ago_custom.dart';
import 'package:insta_node_app/views/comment/bloc/noti_bloc/noti_bloc.dart';
import 'package:insta_node_app/views/comment/bloc/noti_bloc/noti_event.dart';
import 'package:insta_node_app/views/comment/bloc/noti_bloc/noti_state.dart';
import 'package:insta_node_app/views/notification/widgets/temp_loading_shimmer_notifi.dart';
import 'package:insta_node_app/views/profile/screens/other_profile.dart';
import 'package:provider/provider.dart';

class TestNotificationScreen extends StatefulWidget {
  const TestNotificationScreen({super.key});

  @override
  State<TestNotificationScreen> createState() => _TestNotificationScreenState();
}

class _TestNotificationScreenState extends State<TestNotificationScreen> {
  @override
  void initState() {
    super.initState();
    fetchNotificationData();
  }

  void fetchNotificationData() async {
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final notifiBloc = BlocProvider.of<NotiBloc>(context);
    notifiBloc.add(NotiEventFetch(token: token));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        titleSpacing: 5,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 30,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            const Text('Notifications',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      body: NotifiList(),
    );
  }
}

class NotifiList extends StatelessWidget {
  const NotifiList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotiBloc, NotiState>(builder: (context, notiState) {
      if (notiState is NotiStateLoading) {
        return Column(children: [
          ...List.generate(
              2,
              (index) => LoadingShimmer(
                    child: CardLoadingShimmerNotifiWidget(),
                  )).toList()
        ]);
      } else if (notiState is NotiStateError) {
        return Center(
          child: Text(
            notiState.error,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        );
      } else if (notiState is NotiStateSuccess) {
        final _notifications = notiState.listNoti;
        return RefreshIndicator(
          color: Colors.green,
          onRefresh: () async {
            // reload
            final token = Provider.of<AuthProvider>(context, listen: false)
                .auth
                .accessToken!;
            final notifiBloc = BlocProvider.of<NotiBloc>(context);
            notifiBloc.add(NotiEventFetch(token: token, isRefresh: true));
          },
          child: ListView.builder(
            itemCount: _notifications.length,
            itemBuilder: (context, index) {
              final notiItem = _notifications[index];
              return Container(
                color:
                    notiItem.isRead == true ? Colors.white : Colors.grey[400],
                child: ListTile(
                  onTap: () {
                    if (notiItem.text!.contains('post') ||
                        notiItem.text!.contains('comment')) {
                    } else if (notiItem.text!.contains('follow')) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) =>
                              OtherProfileScreen(userId: notiItem.url!)));
                    }
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(notiItem.user!.avatar!),
                  ),
                  title: Text(
                    notiItem.text!,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    convertTimeAgo(notiItem.createdAt!),
                  ),
                  trailing: trailingNoti(notiItem),
                ),
              );
            },
          ),
        );
      } else {
        return const Center(
          child: Text('Something went wrong!'),
        );
      }
    });
  }

  dynamic trailingNoti(Notify noti) {
    if (noti.image!.isNotEmpty) {
      return ImageHelper.loadImageNetWork(noti.image!,
          fit: BoxFit.cover, height: 50, width: 50);
    } else if (noti.text == 'started following you.') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Follow',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    return null;
  }
}
