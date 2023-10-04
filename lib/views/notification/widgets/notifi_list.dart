import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/constants/asset_helper.dart';
import 'package:insta_node_app/models/notify.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/utils/time_ago_custom.dart';
import 'package:insta_node_app/bloc/noti_bloc/noti_bloc.dart';
import 'package:insta_node_app/bloc/noti_bloc/noti_event.dart';
import 'package:insta_node_app/bloc/noti_bloc/noti_state.dart';
import 'package:insta_node_app/views/notification/widgets/temp_loading_shimmer_notifi.dart';
import 'package:insta_node_app/views/post/screens/explore_list_post.dart';
import 'package:insta_node_app/views/profile/screens/other_profile.dart';
import 'package:provider/provider.dart';

class NotifiList extends StatefulWidget {
  const NotifiList({super.key});

  @override
  State<NotifiList> createState() => _NotifiListState();
}

class _NotifiListState extends State<NotifiList> {
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
        final notifications = notiState.listNoti;
        if (notifications.isEmpty) return emptyNotifiUi();
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
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notiItem = notifications[index];
              return Container(
                color:
                    notiItem.isRead == true ? Colors.white : Colors.grey[400],
                child: buildNotifiItem(notiItem, context),
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

  ListTile buildNotifiItem(Notify notiItem, BuildContext context) {
    return ListTile(
      onTap: () {
        if (notiItem.type == 'post') {
          // read noti
          if (notiItem.isRead == false) {
            final token = Provider.of<AuthProvider>(context, listen: false)
                .auth
                .accessToken!;
            final notifiBloc = BlocProvider.of<NotiBloc>(context);
            notifiBloc.add(NotiEventRead(notiId: notiItem.sId!, token: token));
            setState(() {
              notiItem.isRead = true;
            });
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  ExploreListPostScreen(posts: const [], title: 'Post')));
        } else if (notiItem.type == 'reel') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) =>
                  ExploreListPostScreen(posts: const [], title: 'Reel')));
        } else if (notiItem.type == 'follow') {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => OtherProfileScreen(
                    userId: notiItem.user!.sId!,
                  )));
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
    );
  }

  Widget emptyNotifiUi() {
    return Center(
      child: ImageHelper.loadImageAsset(AssetHelper.noNotifi),
    );
  }

  dynamic trailingNoti(Notify noti) {
    if (noti.type == 'post') {
      return ImageHelper.loadImageNetWork(noti.image!,
          fit: BoxFit.cover, height: 50, width: 50);
    } else if (noti.type == 'follow') {
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
