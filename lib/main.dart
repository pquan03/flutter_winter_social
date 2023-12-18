import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insta_node_app/app.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/providers/theme.dart';
import 'package:insta_node_app/utils/notifi_config.dart';
import 'package:insta_node_app/utils/socket_config.dart';
import 'package:insta_node_app/bloc/chat_bloc/chat_bloc.dart';
import 'package:insta_node_app/bloc/noti_bloc/noti_bloc.dart';
import 'package:insta_node_app/bloc/online_bloc/oneline_bloc.dart';
import 'package:insta_node_app/bloc/simple_bloc_observer.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.red,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Bloc.observer = SimpleBlocObserver();
  SocketConfig.socket.connect();
  if (Platform.isAndroid) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeModel()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => NotiBloc()),
          BlocProvider(create: (_) => ChatBloc()),
          BlocProvider(create: (_) => OnlineBloc()),
        ],
        child: const MyApp(),
      )));
}
