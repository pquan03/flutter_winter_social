import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:insta_node_app/constants/themes.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/providers/theme.dart';
import 'package:insta_node_app/views/auth/screens/splash.dart';
import 'package:insta_node_app/utils/notifi_config.dart';
import 'package:insta_node_app/utils/socket_config.dart';
import 'package:insta_node_app/views/comment/bloc/chat_bloc/chat_bloc.dart';
import 'package:insta_node_app/views/comment/bloc/noti_bloc/noti_bloc.dart';
import 'package:insta_node_app/views/comment/bloc/simple_bloc_observer.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  Bloc.observer = SimpleBlocObserver();
  SocketConfig.socket.connect();
  if(Platform.isAndroid) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ThemeModel()),
  ], child: MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => NotiBloc()),
      BlocProvider(create: (_) => ChatBloc())
    ],
    child: const MyApp(),
  )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        themeAnimationCurve: Curves.easeInOut,
        themeAnimationDuration: const Duration(milliseconds: 500),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        themeMode: Provider.of<ThemeModel>(context).theme == 'system'
            ? ThemeMode.system
            : Provider.of<ThemeModel>(context).theme == 'light'
                ? ThemeMode.light
                : ThemeMode.dark,
        theme: ThemeClass
            .lightTheme, // applies this theme if the device theme is light mode
        darkTheme: ThemeClass
            .darkTheme, 
        home: const SplashPage());
  }
}
