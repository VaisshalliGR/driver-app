import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:testing/screens/home_page.dart';
import 'package:testing/screens/mytrippage.dart';
import 'login_screen.dart';

final FirebaseAuth auth = FirebaseAuth.instance;


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getcurrentuser() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.instance.subscribeToTopic('driver');

    final User? user = auth.currentUser;
    setState(() {
      user != null ? notification_bool = 1 : notification_bool = 0;
    });


    widgetreturner();
  }

  void widgetreturner() {
    print(notification_bool);
    if (notification_bool == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else if (notification_bool == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  int notification_bool = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // print(userphonenumber);
    getcurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
