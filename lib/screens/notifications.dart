import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/notify.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/screens/other_profile.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/utils/socket_config.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  final List<Notify> notifications;
  final String accessToken;
  const NotificationScreen(
      {super.key, required this.accessToken, required this.notifications});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = false;
  List<Notify> _notifications = [];

  @override
  void initState() {
    super.initState();
    SocketConfig.socket.on('createNotifyToClient', (data) {
      final newNotify = Notify.fromJson(data);
      if (!mounted) return;
      setState(() {
        _notifications.insert(0, newNotify);
      });
    });
    SocketConfig.socket.on('deleteNotifyToClient', (data) {
      final newNotify = Notify.fromJson(data);
      if (!mounted) return;
      setState(() {
        _notifications.removeWhere((element) => element.sId == newNotify.sId);
      });
    });
    if (widget.notifications.isEmpty) {
      getNotifications();
    } else {
      setState(() {
        _notifications = [...widget.notifications];
      });
    }
  }

  void getNotifications() async {
    setState(() {
      _isLoading = true;
    });
    final res = await NotifiApi().getNotifications(widget.accessToken);
    if (res is List) {
      setState(() {
        _notifications = [...res];
      });
    } else {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
        title: 'Notifications',
        onPressed: () => Navigator.pop(context, _notifications),
        action: [
          IconButton(
              onPressed: () async {
                await NotifiApi().deleteAllNotifi(widget.accessToken);
                setState(() {
                  _notifications = [];
                });
              },
              icon: Icon(
                FontAwesomeIcons.trashCan,
                size: 20,
              ))
        ],
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _isLoading
              ? Column(children: [
                  ...List.generate(
                      2,
                      (index) => LoadingShimmer(
                            child: buildTempNotifi(),
                          )).toList()
                ])
              : RefreshIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onRefresh: () async {
                    getNotifications();
                  },
                  child: _notifications.isEmpty
                      ? Center(
                          child: Text('No notifications'),
                        )
                      : ListView.builder(
                          itemCount: _notifications.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                await NotifiApi().readNotifi(
                                    _notifications[index].sId!,
                                    widget.accessToken);
                                setState(() {
                                  _notifications[index].isRead = true;
                                });
                                if (_notifications[index].text ==
                                    'started following you.') {
                                  if (!mounted) return;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => OtherProfileScreen(
                                          userId: _notifications[index].url!,
                                          token: widget.accessToken)));
                                }
                              },
                              child: Container(
                                color: !_notifications[index].isRead!
                                    ? Colors.grey.withOpacity(0.3)
                                    : Colors.transparent,
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                          _notifications[index].user!.avatar!),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                RichText(
                                                    text: TextSpan(
                                                        text: _notifications[
                                                                index]
                                                            .user!
                                                            .username!,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18),
                                                        children: [
                                                      TextSpan(
                                                          text:
                                                              ' ${_notifications[index].text!}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal))
                                                    ])),
                                                const SizedBox(
                                                  height: 8,
                                                ),
                                                Text(
                                                  DateFormat('dd/MM/yyyy hh:mm')
                                                      .format(DateTime.parse(
                                                          _notifications[index]
                                                              .createdAt!)),
                                                  style: TextStyle(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          _notifications[index].image != ''
                                              ? ImageHelper.loadImageNetWork(
                                                  _notifications[index].image!,
                                                  fit: BoxFit.cover,
                                                  height: 50,
                                                  width: 50)
                                              : Container(),
                                          _notifications[index].text ==
                                                  'started following you.'
                                              ? Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Text(
                                                    'Follow',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
        ));
  }

  Widget buildTempNotifi() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.5,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.35,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
              ))
        ],
      ),
    );
  }
}
