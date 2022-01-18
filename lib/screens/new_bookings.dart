import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/classes/information_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testing/screens/login_screen.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class NewBookings extends StatefulWidget {
  const NewBookings({Key? key}) : super(key: key);

  @override
  _NewBookingsState createState() => _NewBookingsState();
}

class _NewBookingsState extends State<NewBookings> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int driver_wal = 0;
  driver_wallet()async{
    await _firestore
        .collection('subscribed_users')
        .doc(getcurrentuser()!)
        .get()
        .then((value) {
          setState(() {
            driver_wal = value['wallet'];
          });
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driver_wallet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('proceded')
                .orderBy('time_stamp', descending: true)
                .snapshots(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              List<InformationContainer> informationcontainers = [];
              final info = snapshot.data!.docs;
              bool rental_state = false;
              // String distance = '';
              // String duration ='';
              // int fare = 0;
              // int driverfee = 0;
              // String to ='';
              // String to_id = '';
              for (var i in info) {
                // final from = i['from'];
                //
                // // final to = i['to'];
                // final address = i['address'];
                //
                // final triptype = i['triptype'];
                //
                // final cabtype = i['cabtype'];
                //
                // // final fare = i['fare'];
                // final date = i['date'];
                //
                // final day = i['day'];
                //
                // final totalfare = i['total_fare'];
                //
                // // final driverfee = i['driver_fee'];
                // final time = i['time'];
                //
                // final driveraccepted = i['driveraccepted'];
                //
                // final docid = i.id;
                //
                // final end_otp = i['end_otp'];
                //
                // final user_id= i['user_id'];
                //
                // final ride_id = i['ride_id'];
                //
                // final from_id = i['from_id'];
                //
                // //final to_id = i['to_id'];
                //
                // final referred_by = i['referred_by'];
                // print("15");
                //
                // if(triptype == 'round trip'||triptype=='one way'){
                //   fare = i['fare'];
                //   driverfee = i['driver_fee'];
                //   to = i['to'];
                //   to_id = i['to_id'];
                // }
                // else{
                //   distance = i['distance'];
                //   duration = i['duration'];
                //   rental_state = true;
                // }
                //
                // print(user_id);
                final pickupvales = InformationContainer(
                  from: i['from'],
                  to: i['triptype'] == 'rental' ? '' : i['to'],
                  address: i['address'],
                  triptype: i['triptype'],
                  cabtype: i['cabtype'],
                  driverphonenumber: getcurrentuser()!,
                  fare: i['triptype'] == 'rental' ? 0 : i['fare'],
                  date: i['date'],
                  day: i['day'],
                  total_fare: i['total_fare'],
                  driver_fee: i['triptype'] == 'rental' ? 0 : i['driver_fee'],
                  time: i['time'],
                  buttonsrequired: true,
                  skip: () {},
                  otpfieldrequired: false,
                  driver_accepted: i['driveraccepted'],
                  docid: i.id,
                  end_otp: i['end_otp'],
                  user_id: i['user_id'],
                  ride_id: i['ride_id'],
                  from_id: i['from_id'],
                  to_id: i['triptype'] == 'rental' ? '' : i['to_id'],
                  referred_by: i['referred_by'],
                  rental_state: rental_state,
                  distance: i['triptype'] == 'rental' ? i['distance'] : '',
                  duration: i['triptype'] == 'rental' ? i['duration'] : '',
                  reward_points: i['reward_points'],
                );

                informationcontainers.add(pickupvales);

              }
              return Expanded(
                child: ListView(
                  children: informationcontainers,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String? getcurrentuser() {
    return auth.currentUser!.phoneNumber!.substring(3);
  }
}
