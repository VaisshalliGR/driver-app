import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/screens/completedtrips.dart';
import 'package:testing/screens/dashboard.dart';
import 'package:testing/screens/mytrippage.dart';
import 'package:testing/screens/new_bookings.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool subscribed_user_checker = false ;
  void showSnackBar(String title) {
    final snackbar = SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(horizontal: 14.0),
        duration: Duration(seconds: 1),
        content: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.0)));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: Container(),
          title: Text(
            "Home",
            style: GoogleFonts.slabo13px(
                fontWeight: FontWeight.bold,
                fontSize: 26.0,
                letterSpacing: 1.0),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: <Widget>[
            GestureDetector(
              onTap: () async{
                await _firestore.collection('subscribed_users').doc((_auth.currentUser!.phoneNumber!.substring(3))).get().then((value) {
                  subscribed_user_checker = value.exists;
                  print(value.id);
                });
                if(subscribed_user_checker){Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardPage()));}
                else{
                  showSnackBar("You Are Not A Subscribed User");
                }

              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40.0,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  "New Bookings",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.slabo13px(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0),
                ),
              ),
              Tab(
                child: Text(
                  "My Trip",
                  style: GoogleFonts.slabo13px(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0),
                ),
              ),
              Tab(
                child: Text(
                  "Completed",
                  style: GoogleFonts.slabo13px(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0),
                ),
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: const TabBarView(children: [
          NewBookings(),
          MyTripPage(),
          CompletedPage(),
        ]),
      ),
    );
  }
}
