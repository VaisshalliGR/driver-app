import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/classes/completed_container.dart';
import 'package:testing/classes/dash_top_container.dart';
import 'package:testing/screens/login_screen.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
//import 'package:testing/classes/information_container.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? getcurrentuser() {
    return auth.currentUser!.phoneNumber!.substring(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "PROFILE",
          style:
              GoogleFonts.nunito(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        actions: [
          InkWell(
            onTap: ()async{
              await auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  LoginScreen()), (Route<dynamic> route) => false);
            },
              child: Icon(
            Icons.logout,
            size: 28.0,
          ))

        ],
      ),
      // backgroundColor: Colors.white,
      body: Column(
        children: [
          DashTopContainer(),
          const SizedBox(
            height: 10.0,
          ),
          const Divider(
            color: Colors.green,
            height: 4.0,
            thickness: 1.0,
            endIndent: 10.0,
            indent: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Completed Trips",
                style: GoogleFonts.nunito(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 24.0),
              )
            ],
          ),
          const Divider(
            color: Colors.green,
            height: 4.0,
            thickness: 1.0,
            endIndent: 10.0,
            indent: 10.0,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection(
                    'subscribed_users/${getcurrentuser()}/completed_trips')
                .orderBy('time_stamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<CompletedContainer> completedcontainers = [];
              final info = snapshot.data!.docs;
              for (var i in info) {
                final from = i['from'];
                final to = i['to'];
                final address = i['address'];
                final triptype = i['triptype'];
                final cabtype = i['cabtype'];
                final driverfee = i['driver_fee'];
                final fare = i['fare'];
                final totalfare = i['total_fare'];
                final time = i['time'];
                final day = i['day'];
                final date = i['date'];
                final ride_id = i['ride_id'];
                final driver_name = i['driver_name'];
                final distance = i['distance'];
                final duration = i['duration'];
                final pickupvales = CompletedContainer(
                  from: from,
                  to: to,
                  address: address,
                  triptype: triptype,
                  cabtype: cabtype,
                  driverphonenumber: getcurrentuser()!,
                  driver_fee: driverfee,
                  fare: fare,
                  total_fare: totalfare,
                  time: time,
                  day: day,
                  date: date,
                  ride_id: ride_id,
                  driver_name: driver_name,
                  distance: distance.toString(),
                  duration: duration,
                  reward_points: i['reward_points'],
                );
                completedcontainers.add(pickupvales);
              }
              return Expanded(
                child: ListView(
                  children: completedcontainers,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
// Stack(
// children: [
// ListView(
// children: [
// const DashTopContainer(),

//

// ),

// //const InformationContainer(),
// //const InformationContainer(),
// ],
// ),
// ],
// )
