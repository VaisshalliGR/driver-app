//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
//import 'package:testing/screens/dashboard.dart';
import 'package:testing/screens/home_page.dart';
//import 'package:testing/screens/otp_screen.dart';
import 'screens/login_screen.dart';
import 'notification_test.dart';

Future<void> main() async {
  // Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //   // If you're going to use other Firebase services in the background, such as Firestore,
  //   // make sure you call `initializeApp` before using other Firebase services.
  //
  //   print("Handling a background message: ${message.messageId}");
  //
  // }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onMessage.forEach((element) {print(element.messageId);});
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // initialize() async {
  //   print('yes');
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //     print("message recieved");
  //     print(event.notification!.body);
  //   });
  //   FirebaseMessaging.onMessageOpenedApp.listen((message) {
  //     print('Message clicked!');
  //   });
  //
  //
  //   FirebaseMessaging.onMessage.listen((RemoteMessage event) {
  //     print("message recieved");
  //     print(event.notification!.body);
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text("Notification"),
  //             content: Text(event.notification!.body!),
  //             actions: [
  //               TextButton(
  //                 child: Text("Ok"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               )
  //             ],
  //           );
  //         });
  //   });
  // }

  @override
  void initState() {
    super.initState();
    // initialize();
  }
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
