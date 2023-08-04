import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/notify.dart';
import 'package:insta_node_app/recources/notifi_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends StatefulWidget {
  final String accessToken;
  const NotificationScreen({super.key, required this.accessToken});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool _isLoading = false;
  List<Notify> _notifications = [];

  @override
  void initState() {
    super.initState();
    getNotifications();
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
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: _isLoading
              ? Column(
                children: [...List.generate(2, (index) => LoadingShimmer(
                  child: buildTempNotifi(),
                )).toList()]
              )
              : RefreshIndicator(
                onRefresh: () async{
                  getNotifications();
                },
                child: ListView.builder(
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          print('hi');
                        },
                        child: Container(
                          color: _notifications[index].isRead! ? Colors.grey.withOpacity(0.2) : Colors.transparent,
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
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: _notifications[index]
                                                .user!
                                                .username!,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            children: [
                                          TextSpan(
                                              text:
                                                  ' ${_notifications[index].text!}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.normal))
                                        ])),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      DateFormat('dd/MM/yyyy hh:mm').format(
                                          DateTime.parse(
                                              _notifications[index].createdAt!)),
                                      style: TextStyle(
                                          color: Colors.white.withOpacity(0.5)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              ImageHelper.loadImageNetWork(
                                  _notifications[index].image!,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50)
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
            )
          )
        ],
      ),
    );
  }
}
