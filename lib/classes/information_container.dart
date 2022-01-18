import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/classes/dash_top_container.dart';
import 'package:testing/screens/test.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// DashTopContainer _dashTopContainer = DashTopContainer;
class InformationContainer extends StatefulWidget {
  const InformationContainer(
      {Key? key,
      required this.from,
      required this.to,
      required this.address,
      required this.cabtype,
      required this.triptype,
      required this.driverphonenumber,
      required this.date,
      required this.day,
      required this.time,
      required this.driver_fee,
      required this.fare,
      required this.total_fare,
      this.skip,
      required this.buttonsrequired,
      required this.otpfieldrequired,
      this.driver_accepted,
      this.docid,
      this.end_otp,
      this.user_id,
      required this.ride_id,
      required this.from_id,
      required this.to_id,
      required this.referred_by,
      this.rental_state,
      this.distance,
      this.duration,
      required this.reward_points})
      : super(key: key);
  final String from;
  final String to;
  final String address;
  final String cabtype;
  final String triptype;
  final String driverphonenumber;
  final String date;
  final String day;
  final String time;
  final int driver_fee;
  final int fare;
  final int total_fare;
  final VoidCallback? skip;
  final bool buttonsrequired;
  final bool otpfieldrequired;
  final int? driver_accepted;
  final String? docid;
  final String? end_otp;
  final String? user_id;
  final String ride_id;
  final String from_id;
  final String to_id;
  final String referred_by;
  final bool? rental_state;
  final String? distance;
  final String? duration;
  final int reward_points;

  @override
  _InformationContainerState createState() => _InformationContainerState();
}

class _InformationContainerState extends State<InformationContainer> {
  TextEditingController otpcontroller = TextEditingController();
  TextEditingController kmreadingcontroller = TextEditingController();
  TextEditingController endkmreadingcontroller = TextEditingController();
  final FocusNode _focusNode0 = FocusNode();
  final FocusNode _focusNode1 = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  String driver_name = '';
  int driver_wal = 0;
  var duration;
  bool loading = false;
  String end_date = '';
   int final_fare = 0;
  Future<int> buttonsstate() async {
    int boolvar = 0;
    await _firestore
        .collection('subscribed_users/${widget.driverphonenumber}/mytrips')
        .doc(widget.docid)
        .get()
        .then((value) {
      boolvar = value['buttons_state'];
    });
    return boolvar;
  }

  static int getNoOfDays(String startDate, String endDate) {
    return DateTime.parse(endDate)
                .difference(
                  DateTime.parse(startDate),
                )
                .inHours ==
            0
        ? 1
        : ((DateTime.parse(endDate)
                        .difference(
                          DateTime.parse(startDate),
                        )
                        .inHours +
                    24) /
                24)
            .floor();
  }

  Future<void> trip_calculation() async {

    print("trip_calclation");
    String start_reading = '';
    String end_reading = '';
    int fare = 0;
    int result = 0;
    String end_date = '';
    String start_duration = '';
    String end_duration = '';
    await _firestore
        .collection('profile')
        .doc(widget.user_id)
        .collection('trips')
        .doc(widget.ride_id)
        .get()
        .then((value) => {
              print("get"),
              start_reading = value['start_reading'],
              end_reading = value['end_reading'],
              end_date = value['trip_return_date'],
              start_duration = value['start_duration'],
              end_duration = value['end_duration'],
            });
    print("stat reading" + start_reading);
    print("end_reading" + end_reading);
    print("end_date" + end_date);
    print("start_duration" + start_duration);
    print("end_duration" + end_duration);
    print(int.parse(end_reading) - int.parse(start_reading));
    // await _firestore
    //     .collection('car_modes')
    //     .doc(widget.triptype)
    //     .get()
    //     .then((value) => fare = value[widget.cabtype]['fare']);
    duration =
        ((DateTime.now().difference(DateTime.parse(start_duration)).inMinutes) /
                    60)
                .floor() +
            1;
    // setState(() {});
    print("duration" + duration.toString());
    await _firestore
        .collection('profile')
        .doc(widget.user_id)
        .collection('trips')
        .doc(widget.ride_id)
        .update({
      'distance':
          (int.parse(end_reading) - int.parse(start_reading)).toString() + "Km",
      'duration': duration.toString() + "Hrs"
    });

    if (widget.triptype == 'one_way') {
      final http.Response response = await http.get(Uri.parse(
          "https://us-central1-chennai-cabs-new.cloudfunctions.net/calculateFare?trip_type=one_way&distance=${int.parse(end_reading) - int.parse(start_reading)}&car_mode=${widget.cabtype}"));
      result = jsonDecode(response.body)['subtotal'];
      // result = (int.parse(end_reading) - int.parse(start_reading)) * fare;
      print("result");
      print(result);
    } else if (widget.triptype == 'round_way') {
      final http.Response response = await http.get(Uri.parse(
          "https://us-central1-chennai-cabs-new.cloudfunctions.net/calculateFare?trip_type=round_way&distance=${int.parse(end_reading) - int.parse(start_reading)}&car_mode=${widget.cabtype}&no_of_days=${getNoOfDays(widget.date, end_date)}"));
      result = jsonDecode(response.body)['subtotal'];
      //result = (int.parse(end_reading) - int.parse(start_reading)) * fare;
      print(result);
    } else {
      final http.Response response = await http.get(Uri.parse(
          "https://us-central1-chennai-cabs-new.cloudfunctions.net/calculateFare?trip_type=rental&distance=${int.parse(end_reading) - int.parse(start_reading)}&duration=$duration&car_mode=${widget.cabtype}"));
      result = jsonDecode(response.body)['subtotal'];
    }
    await calculation_updation(result);
  }

  Future<void> calculation_updation(int basefare) async {
    String start_reading = '';
    String end_reading = '';
    int fare = 0;
    int result = 0;
    String end_date = '';
    String start_duration = '';
    String end_duration = '';
    await _firestore
        .collection('profile')
        .doc(widget.user_id)
        .collection('trips')
        .doc(widget.ride_id)
        .get()
        .then((value) => {
              print("get"),
              start_reading = value['start_reading'],
              end_reading = value['end_reading'],
              end_date = value['trip_return_date'],
              start_duration = value['start_duration'],
              end_duration = value['end_duration'],
            });
    duration =
        ((DateTime.now().difference(DateTime.parse(start_duration)).inMinutes) /
                    60)
                .floor() +
            1;

    int total_fare = (basefare - widget.fare) + widget.fare;
    print("base_fare");
    print(basefare);
    print("total_fare");
    print(total_fare);
    print("Driver_");
    await _firestore
        .collection('subscribed_users')
        .doc(widget.driverphonenumber)
        .collection('completed_trips')
        .doc(widget.ride_id)
        .set({
      'fare': total_fare,
      'total_fare': basefare,
      'distance':
          (int.parse(end_reading) - int.parse(start_reading)).toString() + "Km",
      'duration': duration.toString() + "Hrs",
    }, SetOptions(merge: true));

    await _firestore.collection('completed_trips').doc(widget.ride_id).set({
      'from': widget.from,
      'to': widget.to,
      'address': widget.address,
      'triptype': widget.triptype,
      'cabtype': widget.cabtype,
      'time_stamp': FieldValue.serverTimestamp(),
      'driverphonenumber': widget.driverphonenumber,
      'driver_fee': widget.driver_fee,
      'fare': total_fare,
      'total_fare': basefare,
      'date': widget.date,
      'day': widget.day,
      'time': widget.time,
      'referred_by': widget.referred_by,
      'ride_id': widget.ride_id,
      'driver_name': driver_name,
      'distance':
          (int.parse(end_reading) - int.parse(start_reading)).toString() + "Km",
      'duration': duration.toString() + "Hrs",
      'reward_points': widget.reward_points
    });
    print("trip_status_updation");
    await _firestore
        .collection('profile')
        .doc(widget.user_id)
        .collection('trips')
        .doc(widget.ride_id)
        .update({
      'trip_status': 'completed',
      'base_fare': basefare,
      'total_fare': basefare + widget.driver_fee,
      'subtotal': basefare + widget.driver_fee
    });

    print("completed");
  }

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

  Future<int> fare_per_km(String trip_type, String car_mode) async {
    var fare = await _firestore
        .collection('car_modes')
        .doc(trip_type)
        .get()
        .then((value) => value.data()![car_mode]['fare']);
    print(fare);
    return fare;
  }

  String? getcurrentuser() {
    return auth.currentUser!.phoneNumber!.substring(3);
  }

  void driverdetails() async{
    await _firestore
        .collection('subscribed_users')
        .doc(getcurrentuser())
        .get()
        .then((value) {
      setState(() {
        driver_name = value['name'];

      });
    });

  }

  driver_wallet() async {
    await _firestore
        .collection('subscribed_users')
        .doc(getcurrentuser()!)
        .get()
        .then((value) {
      setState(() {
        driver_wal = value['wallet'];
        end_date = (365 -
            DateTime.now()
                .difference(DateTime.tryParse(value['subscribed_date'])!)
                .inDays)
            .toString();
      });
    });
  }
  Future<dynamic>diaologue_boxes(BuildContext context){
    return showDialog(
      context: context,
      builder: (context) {
        bool loading = false;
        return StatefulBuilder(
          builder: (context, state) =>
              AlertDialog(
                title: Text(
                    "Are You Sure You Want To End Trip ?"),
                actions: [
                  //cancel
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                          8.0),
                      child: Container(
                        height: 50.0,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(
                                Radius
                                    .circular(
                                    5.0)),
                            color: Colors.green),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style:
                            GoogleFonts.rubik(
                                color: Colors
                                    .white,
                                fontSize:
                                22.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  //end_trip
                  InkWell(
                    onTap: () async {
                      if (endkmreadingcontroller
                          .text.isNotEmpty) {
                        state(() {
                          loading = true;
                        });
                        await _firestore
                            .collection('profile')
                            .doc(widget.user_id)
                            .collection('trips')
                            .doc(widget.ride_id)
                            .update({
                          'end_reading':
                          endkmreadingcontroller
                              .text,
                          'end_duration':
                          DateTime.now()
                              .toString(),
                        });

                        print(
                            endkmreadingcontroller);
                        print(
                            kmreadingcontroller);
                        _firestore
                            .collection(
                            'subscribed_users/${widget.driverphonenumber}/completed_trips')
                            .doc(widget.ride_id)
                            .set({
                          'from': widget.from,
                          'to': widget.to,
                          'address':
                          widget.address,
                          'triptype':
                          widget.triptype,
                          'cabtype':
                          widget.cabtype,
                          'time_stamp': FieldValue
                              .serverTimestamp(),
                          'driverphonenumber': widget
                              .driverphonenumber,
                          'driver_fee':
                          widget.driver_fee,
                          'fare': widget.fare,
                          'total_fare':
                          widget.total_fare,
                          'date': widget.date,
                          'day': widget.day,
                          'time': widget.time,
                          'ride_id':
                          widget.ride_id,
                          'driver_name':
                          driver_name,
                          'distance':
                          widget.distance,
                          'duration':
                          widget.duration,
                          'reward_points':
                          widget.reward_points
                        });
                        print(widget.docid);
                        await trip_calculation();

                        final final_total_fare = await _firestore
                            .collection(
                            'subscribed_users')
                            .doc(widget
                            .driverphonenumber)
                            .collection(
                            'completed_trips')
                            .doc(widget.ride_id)
                            .get()
                            .then((value) => value[
                        'total_fare']);
                        setState(() {
                          final_fare = final_total_fare;
                        });
                        await _firestore
                            .collection(
                            'subscribed_users/${widget.driverphonenumber}/mytrips')
                            .doc(widget.docid)
                            .delete();
                        await _firestore
                            .collection(
                            'allotted_booking')
                            .doc(widget.ride_id)
                            .delete();
                        // Navigator.pop(context);
                         Navigator.pop(context);
                         Navigator.push(context, MaterialPageRoute(builder: (context)=>TestScreen(final_fare: (final_fare+widget.driver_fee).toString(),)));
                      } else {
                        showSnackBar(
                            "Enter The End Km Readings");
                      }
                    },
                    child: Padding(
                      padding:
                      const EdgeInsets.all(
                          8.0),
                      child: Container(
                        height: 50.0,
                        decoration: const BoxDecoration(
                            borderRadius:
                            BorderRadius.all(
                                Radius
                                    .circular(
                                    5.0)),
                            color: Colors.green),
                        child: Center(
                          child: loading
                              ? SizedBox(
                              child:
                              CircularProgressIndicator())
                              : Text(
                            "End Trip",
                            style: GoogleFonts.rubik(
                                color: Colors
                                    .white,
                                fontSize:
                                22.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        );

      },
    );
  }
  // Future<dynamic>dialogue_box2(){
  //   return showDialog(
  //       context: context,
  //       builder:
  //           (context1) =>
  //           AlertDialog(
  //             content: Container(
  //               height: 200.0,
  //               width: 300.0,
  //               child: Column(
  //                 //mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Text(
  //                     "Collect",
  //                     style: GoogleFonts.rubik(
  //                         fontSize:
  //                         40,
  //                         fontWeight:
  //                         FontWeight.bold,
  //                         color: Colors.green),
  //                   ),
  //                   SizedBox(height: 40.0,),
  //                   Text(
  //                       "$final_fare",
  //                       style: GoogleFonts.rubik(
  //                           fontSize: 50,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.black)),
  //                   Container(
  //                     height: 50.0,
  //                     decoration: const BoxDecoration(
  //                         borderRadius:
  //                         BorderRadius.all(
  //                             Radius
  //                                 .circular(
  //                                 5.0)),
  //                         color: Colors.green),
  //                     child: Center(
  //                       child: Text(
  //                         "Okay",
  //                         style:
  //                         GoogleFonts.rubik(
  //                             color: Colors
  //                                 .white,
  //                             fontSize:
  //                             22.0),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ));
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    driverdetails();
    driver_wallet();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Material(
        shadowColor: Colors.greenAccent,
        borderRadius: BorderRadius.circular(10.0),
        elevation: 10.0,
        child: Container(
          //height: 260.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.green, width: 1.5),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 7.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  widget.reward_points!=0?Container(
                    // height: 30.0,
                    // width: 110.0,

                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        border: Border.all(color: Colors.green)),
                    child: Text("R",style: GoogleFonts.slabo13px(fontSize: 20.0,color: Colors.green,fontWeight: FontWeight.bold),),
                  ):SizedBox(),

                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          border: Border.all(color: Colors.green)),
                      child: FutureBuilder<DocumentSnapshot>(
                        builder: (context, future) => future.hasData
                            ? Text(
                                future.data!['trip_status'],
                                style: GoogleFonts.slabo13px(
                                    fontSize: 22.0,
                                    color: (future.data!['trip_status'] ==
                                            'ongoing')
                                        ? Colors.orange
                                        : Colors.green,
                                    fontWeight: FontWeight.bold),
                              )
                            : SizedBox(

                                //child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white),),
                                ),
                        future: _firestore
                            .collection('profile')
                            .doc(widget.user_id)
                            .collection('trips')
                            .doc(widget.ride_id)
                            .get(),
                      )),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: widget.triptype == 'rental'
                    ? Text(
                        "${widget.from}-Rental",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.slabo13px(
                            color: Colors.green,
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500),
                      )
                    : Text(
                        "${widget.from} to ${widget.to}",
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        style: GoogleFonts.slabo13px(
                            color: Colors.green,
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold),
                      ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 18.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ride Id :" "${widget.ride_id}",
                                  style: GoogleFonts.slabo13px(
                                    //letterSpacing: 2.0,
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    //fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  "Trip Type:" "${widget.triptype}",
                                  style: GoogleFonts.slabo13px(
                                    //letterSpacing: 2.0,
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                                Text(
                                  "Cab Type:" "${widget.cabtype}",
                                  style: GoogleFonts.slabo13px(
                                    //letterSpacing: 2.0,
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Container(
                              //padding: EdgeInsets.symmetric(vertical: 10.0),
                              width: 130.0,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.green, width: 1.5),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                          color: Colors.green,
                                        ),
                                        height: 20.0,
                                        width: 127.0,
                                        child: Center(
                                          child: Text(
                                            "Start Date",
                                            style: GoogleFonts.slabo13px(
                                                color: Colors.white,
                                                fontSize: 17.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.day,
                                        style: GoogleFonts.slabo13px(fontSize: 22.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.date,
                                        style: GoogleFonts.slabo13px(fontSize: 16.0),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    //crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        widget.time,
                                        style: GoogleFonts.slabo13px(
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const SizedBox(
                    //   width: 50.0,
                    // ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.green,
                thickness: 1.5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.triptype == 'rental'
                        ? Column(
                            children: [
                              Text(
                                "Distance",
                                style: GoogleFonts.slabo13px(
                                    color: Colors.green, fontSize: 20.0),
                              ),
                              Text(
                                widget.distance!,
                                style: GoogleFonts.slabo13px(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                "Fare",
                                style: GoogleFonts.slabo13px(
                                    color: Colors.green, fontSize: 20.0),
                              ),
                              FutureBuilder<int>(
                                builder: (context, future) {
                                  if (future.hasData) {
                                    return Text(
                                      "₹" + future.data.toString(),
                                      style: GoogleFonts.slabo13px(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                },
                                future: fare_per_km(
                                    widget.triptype, widget.cabtype),
                              )
                            ],
                          ),
                    widget.triptype == 'rental'
                        ? Column(
                            children: [
                              Text(
                                "Duration",
                                style: GoogleFonts.slabo13px(
                                    color: Colors.green, fontSize: 20.0),
                              ),
                              Text(
                                widget.duration!,
                                style: GoogleFonts.slabo13px(
                                  color: Colors.black,
                                  fontSize: 18.0,
                                ),
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Text(
                                "Driver Fee",
                                style: GoogleFonts.slabo13px(
                                    color: Colors.green, fontSize: 20.0),
                              ),
                              Text(
                                "₹${widget.driver_fee}",
                                style: GoogleFonts.slabo13px(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                ),
                              )
                            ],
                          ),
                    Column(
                      children: [
                        Text(
                          "Est.Total Fare",
                          style: GoogleFonts.slabo13px(
                              color: Colors.green, fontSize: 20.0),
                        ),
                        Text(
                          "₹${widget.total_fare}",
                          style: GoogleFonts.rubik(
                            color: Colors.black,
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const Divider(
                color: Colors.green,
                thickness: 1.5,
              ),
              const SizedBox(
                height: 8.0,
              ),
              if (widget.buttonsrequired)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () async {
                          setState(() {
                            loading = true;
                          });
                          await driver_wallet();

                          final trip_state = await _firestore
                              .collection('profile')
                              .doc(widget.user_id)
                              .collection('trips')
                              .doc(widget.ride_id)
                              .get()
                              .then((value) => value.data()!['trip_status']);
                          print(trip_state);
                          if(end_date!='0'&& !int.parse(end_date).isNegative){
                            if (trip_state != 'completed') {
                              if (driver_wal > 500) {
                                if (widget.driver_accepted == 0) {
                                  print(driver_wal);
                                  print("pressed");
                                  await _firestore
                                      .collection('driveraccepted')
                                      .doc(widget.ride_id)
                                      .set({
                                    'from': widget.from,
                                    'to': widget.to,
                                    'address': widget.address,
                                    'triptype': widget.triptype,
                                    'cabtype': widget.cabtype,
                                    'time_stamp': FieldValue.serverTimestamp(),
                                    'driverphonenumber':
                                        widget.driverphonenumber,
                                    'driver_fee': widget.driver_fee,
                                    'fare': widget.fare,
                                    'total_fare': widget.total_fare,
                                    'date': widget.date,
                                    'day': widget.day,
                                    'time': widget.time,
                                    'end_otp': widget.end_otp,
                                    'user_id': widget.user_id,
                                    'ride_id': widget.ride_id,
                                    'from_id': widget.from_id,
                                    'to_id': widget.to_id,
                                    'referred_by': widget.referred_by,
                                    'distance': widget.distance,
                                    'duration': widget.duration,
                                    'driver_name': driver_name,
                                    'reward_points': widget.reward_points
                                  });
                                  await _firestore
                                      .collection('new_booking')
                                      .doc(widget.ride_id)
                                      .delete();
                                  await _firestore
                                      .collection('proceded')
                                      .doc(widget.docid)
                                      .update({'driveraccepted': 1});
                                  setState(() {
                                    loading = false;
                                  });
                                  showSnackBar("Request is Sent Please Wait");
                                } else {
                                  setState(() {
                                    loading = false;
                                  });
                                  showSnackBar("Another Driver is Picked");
                                }
                              } else {
                                setState(() {
                                  loading = false;
                                });
                                showSnackBar("Your Wallet Balance is Low");
                              }
                            } else {
                              setState(() {
                                loading = false;
                              });
                              showSnackBar("The Trip is Already Completed");
                            }
                          }
                          else{
                            showSnackBar('Subscription Has Ended');
                            setState(() {
                              loading = false;
                            });
                          }
                        },
                        child: Container(
                          height: 35.0,
                          width: 100.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: widget.driver_accepted==0?Colors.green:Colors.red, width: 1.0),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            //color: Colors.green
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                loading
                                    ? SizedBox(
                                        child: CircularProgressIndicator())
                                    : widget.driver_accepted == 0
                                        ? Text(
                                            "ACCEPT",
                                            style: GoogleFonts.slabo13px(
                                                color: Colors.green,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          )
                                        : Text(
                                            "Picked Up",
                                            style: GoogleFonts.slabo13px(
                                                color: widget.driver_accepted==0?Colors.green:Colors.red,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w600),
                                          ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              if (widget.otpfieldrequired)
                FutureBuilder<int>(
                    future: buttonsstate(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == 0) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    final String mapurl = 'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(widget.address)}&destination_place_id=${widget.from_id}&travelmode=car';
                                    // final String mapurl =
                                    //     'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeFull(widget.address)}&travelmode=car';
                                    launch(mapurl);
                                    print(mapurl);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 50.0,
                                      // width: 170.0,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          color: Colors.green),
                                      child: Center(
                                        child: Text(
                                          "Pick Up ",
                                          style: GoogleFonts.slabo13px(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await _firestore
                                        .collection(
                                            'subscribed_users/${widget.driverphonenumber}/mytrips')
                                        .doc(widget.docid)
                                        .update({'buttons_state': 1});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 50.0,
                                      // width: 170.0,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          color: Colors.green),
                                      child: Center(
                                        child: Text(
                                          "Reached ",
                                          style: GoogleFonts.slabo13px(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    String telnumber = "";
                                    await _firestore
                                        .collection('profile')
                                        .doc(widget.user_id)
                                        .get()
                                        .then((value) =>
                                            telnumber = value['phone_number']);
                                    FlutterPhoneDirectCaller.callNumber(
                                        telnumber);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      height: 50.0,
                                      // width: 170.0,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0)),
                                          color: Colors.green),
                                      child: Center(
                                        child: Text(
                                          "Call",
                                          style: GoogleFonts.slabo13px(
                                              color: Colors.white,
                                              fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else if (snapshot.data == 1) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 6) {
                                      _focusNode0.unfocus();
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  focusNode: _focusNode0,
                                  controller: kmreadingcontroller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter Start Km Reading ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 4) {
                                      _focusNode1.unfocus();
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                  focusNode: _focusNode1,
                                  controller: otpcontroller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter OTP ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    if (kmreadingcontroller.text.isNotEmpty) {
                                      if (otpcontroller.text ==
                                          widget.end_otp) {
                                        await _firestore
                                            .collection(
                                                'subscribed_users/${widget.driverphonenumber}/mytrips')
                                            .doc(widget.docid)
                                            .update({
                                          'buttons_state': 2,
                                        });
                                        await _firestore
                                            .collection('profile')
                                            .doc(widget.user_id)
                                            .collection('trips')
                                            .doc(widget.ride_id)
                                            .update({
                                          'start_reading':
                                              kmreadingcontroller.text,
                                          'start_duration':
                                              DateTime.now().toString(),
                                          'end_duration': ''
                                        });

                                        final String mapurl =
                                            'https://www.google.com/maps/dir/?api=1&destination=${Uri.encodeComponent(widget.to)}&destination_place_id=${widget.to_id}&travelmode=car';
                                        launch(mapurl);
                                        print(mapurl);

                                        // await _firestore.collection('subscribed_users/${widget.driverphonenumber}/completed_trips').add({
                                        //   'from': widget.from,
                                        //   'to': widget.to,
                                        //   'address': widget.address,
                                        //   'triptype': widget.triptype,
                                        //   'cabtype': widget.cabtype,
                                        //   'time_stamp': FieldValue.serverTimestamp(),
                                        //   'driverphonenumber': widget.driverphonenumber,
                                        //   'driver_fee': widget.driver_fee,
                                        //   'fare': widget.fare,
                                        //   'total_fare': widget.total_fare,
                                        //   'date': widget.date,
                                        //   'day': widget.day,
                                        //   'time': widget.time,
                                        // });
                                      } else {
                                        showSnackBar('Enter The Correct Otp');
                                      }
                                    } else {
                                      showSnackBar('Enter the Reading');
                                    }
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.green),
                                    child: Center(
                                      child: Text(
                                        "Start Trip",
                                        style: GoogleFonts.slabo13px(
                                            color: Colors.white,
                                            fontSize: 22.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  onChanged: (value) {
                                    if (value.length == 6) {
                                      _focusNode2.unfocus();
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(6),
                                  ],
                                  focusNode: _focusNode2,
                                  controller: endkmreadingcontroller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Enter End Km readings ',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () async {
                                    if (endkmreadingcontroller
                                        .text.isNotEmpty) {
                                      await diaologue_boxes(context);
                                    } else {
                                      showSnackBar("Enter The End Km readings");
                                    }
                                  },
                                  child: Container(
                                    height: 50.0,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.green),
                                    child: Center(
                                      child: Text(
                                        "End Trip",
                                        style: GoogleFonts.slabo13px(
                                            color: Colors.white,
                                            fontSize: 22.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),


            ],
          ),
        ),
      ),
    );
  }


}
