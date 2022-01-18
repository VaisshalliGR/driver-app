import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//import 'package:testing/classes/information_container.dart';
import 'package:testing/classes/completed_container.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class CompletedPage extends StatefulWidget {
  const CompletedPage({Key? key}) : super(key: key);

  @override
  _CompletedPageState createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  String? getcurrentuser() {
    return auth.currentUser!.phoneNumber!.substring(3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                try{
                  final from = i['from'];
                  //print("1");
                  final to = i['to'];
                  //print("2");
                  final address = i['address'];
                  //print("3");
                  final triptype = i['triptype'];
                  //print("4");
                  final cabtype = i['cabtype'];
                  //print("5");
                  final driverfee = i['driver_fee'];
                  print(driverfee);
                  //print("6");
                  // final fare = i['fare'];
                  // print(fare);
                  //print("7");
                  final totalfare = i['total_fare'];
                  //print("8");
                  print(totalfare);
                  final time = i['time'];
                  //print("9");
                  final day = i['day'];
                  //print("10");
                  final date = i['date'];
                  //print("11");
                  final ride_id = i['ride_id'];
                  //print("12");
                  final driver_name = i['driver_name'];
                  //print("13");
                  final distance = i['distance'];
                  print(distance);
                  //print("14");
                  final duration = i['duration'];
                  print(duration);

                }
                 catch(e){
                  print(e);
                }
                // print("15");
                final triptype = i['triptype'];
                final pickupvales = CompletedContainer(
                  from: i['from'],
                  to: i['to'],
                  address: i['address'],
                  triptype: i['triptype'],
                  cabtype: i['cabtype'],
                  driverphonenumber: getcurrentuser()!,
                  driver_fee: i['driver_fee'],
                  //triptype=='round_way'?i['final_base_fare']:
                  fare: i['fare'],
                  total_fare: i['total_fare'],
                  time: i['time'],
                  day: i['day'],
                  date: i['date'],
                  ride_id: i['ride_id'],
                  driver_name: i['driver_name'],
                  distance: i['distance'].toString(),
                  duration: i['duration'],
                  reward_points: i['reward_points'],
                );
                print(i['total_fare']);
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
