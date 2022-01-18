import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:testing/classes/information_container.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class MyTripPage extends StatefulWidget {
  const MyTripPage({Key? key}) : super(key: key);

  @override
  _MyTripPageState createState() => _MyTripPageState();
}

class _MyTripPageState extends State<MyTripPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('subscribed_users/${getcurrentuser()}/mytrips')
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
              // //final driveraccepted = i['driveraccepted'];
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
    // final from = i['from'];
    // final to = i['to'];
    // final address = i['address'];
    // final triptype = i['triptype'];
    // final cabtype = i['cabtype'];
    // final driverfee = i['driver_fee'];
    // final fare = i['fare'];
    // final totalfare = i['total_fare'];
    // final time = i['time'];
    // final day = i['day'];
    // final date = i['date'];
    // final end_otp= i['end_otp'];
    // final ride_id = i['ride_id'];
    // final user_id = i['user_id'];
    // final docid = i.id;
    // final from_id = i['from_id'];
    // final to_id = i['to_id'];
    // final referred_by = i['referred_by'];
    // print(user_id);
    // print(docid);

              final pickupvales = InformationContainer(
                from: i['from'],
                to: i['triptype']== 'rental'?'':i['to'],
                address:i['address'],
                triptype:i['triptype'],
                cabtype: i['cabtype'],
                driverphonenumber: getcurrentuser()!,
                driver_fee: i['triptype']== 'rental'?0:i['driver_fee'],
                fare: i['triptype']== 'rental'?0:i['fare'],
                total_fare: i['total_fare'],
                time: i['time'],
                day: i['day'],
                date: i['date'],
                buttonsrequired: false,
                otpfieldrequired: true,
                end_otp: i['end_otp'],
                ride_id: i['ride_id'],
                user_id: i['user_id'],
                docid: i.id,
                from_id: i['from_id'],
                to_id: i['triptype'] == 'rental'?'':i['to_id'],
                referred_by: i['referred_by'],
                rental_state: rental_state,
                duration: i['triptype'] == 'rental'?i['duration']:'',
                distance: i['triptype']== 'rental'?i['distance']:'',
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
    );
  }

  String? getcurrentuser() {
    return auth.currentUser!.phoneNumber!.substring(3);
  }
}
// late AnimationController animationController;
//void initState() {
//   // TODO: implement initState
//   animationController = AnimationController(
//       vsync: this, duration: const Duration(milliseconds: 500));
//   super.initState();
// }
// GestureDetector(
// onHorizontalDragEnd: (details) {
// if (details.primaryVelocity! <= 120) {
// print("yes");
// animationController.reverse();
// } else {
// print("yes");
// animationController.reverse();
// }
// },
// child: WidgetSlider(
// sliderController: animationController,
// firstWidget: Column(
// children: const [
// InformationContainer(),
//
// ],
// ),
// secondWidget: Column(
// children: const [
// InformationContainer(),
// ],
// ),
// ),
// )
