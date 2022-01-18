import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testing/screens/history_page.dart';
import 'package:testing/screens/login_screen.dart';
import 'package:testing/screens/splash_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:testing/screens/test.dart';
import 'package:testing/screens/user_info_screen.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'foreground_channel_1', // id
  'Foreground Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  sound: RawResourceAndroidNotificationSound('alert_driver'),
);
const AndroidNotificationChannel channel1 = AndroidNotificationChannel(
  'background_channel_2', // id
  'background Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  playSound: false,
);


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print("000000000");
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  //RemoteNotification? notification = message.notification;
  //AndroidNotification? android = message.notification?.android;

  AudioCache().play("alert_admin.mpeg");
  // AudioCache().play("alert_driver.mpeg");
  flutterLocalNotificationsPlugin.show(
      1,
      message.data['title'],
      message.data['body'],
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel1.id,
          channel1.name,
          channel1.description,
          icon: '@mipmap/ic_launcher',
          playSound: false,
          // other properties...
        ),
      ));
  print("111111111111111");
  print("Handling a background message: ${message.messageId}");
}


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.subscribeToTopic('driver');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  //var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("000000000");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.

      //AudioPlayer().play('alerttone.mp3',isLocal: true);
      print("222222222222");
      // AudioCache().play("alerttone.mp3");

      flutterLocalNotificationsPlugin.show(
          1,
          message.data['title'],
          message.data['body'],
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: '@mipmap/ic_launcher',
              playSound: false,
              // other properties...
            ),
          )
      );
    }
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}






