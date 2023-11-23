import 'package:flutter/material.dart';
import 'package:insta_node_app/views/notification/widgets/notifi_list.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();
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
