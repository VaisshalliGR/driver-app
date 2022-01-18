import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotifyTesting extends StatefulWidget {
  const NotifyTesting({Key? key}) : super(key: key);

  @override
  State<NotifyTesting> createState() => _NotifyTestingState();
}

class _NotifyTestingState extends State<NotifyTesting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: Text("press"),
          onPressed: () {},
        ),
      ),
    );
  }
}
