import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:printingservices/page/view_order.dart';
import 'package:rxdart/rxdart.dart';

import '../core/colors.dart';
import '../core/notification_constant.dart';
import '../core/text_style.dart';
import '../widget/griddashboard.dart';

class Home extends StatefulWidget {
  final String username;
  final String userId;
  Home({required this.username, required this.userId});

  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();

  @override
  void initState() {
    notificationOnBackground();
    notificationConfigure();
    super.initState();
  }

  void notificationConfigure() async {
    FirebaseMessaging.instance.subscribeToTopic(widget.userId);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: false,
            requestBadgePermission: false,
            requestSoundPermission: false,
            onDidReceiveLocalNotification:
                (int? id, String? title, String? body, String? payload) async {
              didReceiveLocalNotificationSubject.add(ReceivedNotification(
                  id: id, title: title, body: body, payload: payload));
            });
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse? payload) async {
      final NotificationAppLaunchDetails? details =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => ViewOrder(
            userId: widget.userId,
          ),
        ),
      );
      selectNotificationSubject.add(payload!.payload!);
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("background 2");
      final obj = message.data;

      late RemoteNotification notification = message.notification!;

      final NotificationAppLaunchDetails? details =
          await flutterLocalNotificationsPlugin
              .getNotificationAppLaunchDetails();
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (builder) => ViewOrder(
            userId: widget.userId,
          ),
        ),
      );
      selectNotificationSubject.add(obj["payload"]);
    });

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      print('foreground');

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            NotificationApp().channel.id,
            NotificationApp().channel.name,
            icon: android?.smallIcon,
            priority: Priority.high,
          ),
        ),
        //  payload: jsonPayload,
      );
    });
  }

  void notificationOnBackground() {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) async {
      if (message != null) {
        final NotificationAppLaunchDetails? details =
            await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (builder) => ViewOrder(
              userId: widget.userId,
            ),
          ),
        );
        //   selectNotificationSubject.add(obj["payload"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: blackBG,
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 110,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.username,
                      style: headline3.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Dashboard",
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Color(0xffa29aac),
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                // IconButton(
                //   alignment: Alignment.topCenter,
                //   icon: Image.asset(
                //     "assets/notification.png",
                //     width: 24,
                //   ),
                //   onPressed: () {},
                // )
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          GridDashboard(
            userId: widget.userId,
            username: widget.username,
          ),
        ],
      ),
    );
  }
}
