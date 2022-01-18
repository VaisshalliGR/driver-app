import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/screens/history_page.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class DashTopContainer extends StatefulWidget {
  const DashTopContainer({Key? key}) : super(key: key);

  @override
  _DashTopContainerState createState() => _DashTopContainerState();
}

class _DashTopContainerState extends State<DashTopContainer> {
  String drivername = '';
  String driverphonenumber = '';
  String carnumber = '';
  String carname = '';
  String length = '';
  String end_date = '';
  int wallet = 0;
  String? getcurrentuser() {
    return auth.currentUser!.phoneNumber!.substring(3);
  }

  void user_details() async {
    _firestore
        .collection('subscribed_users')
        .doc(getcurrentuser())
        .get()
        .then((value) {
      setState(() {
        drivername = value['name'];
        driverphonenumber = value['phone_number'];
        carnumber = value['car_number'];
        carname = value['car_name'];
        end_date = (365 -
                DateTime.now()
                    .difference(DateTime.tryParse(value['subscribed_date'])!)
                    .inDays)
            .toString();
        wallet = value['wallet'];
      });
    });
    await _firestore
        .collection('subscribed_users')
        .doc(getcurrentuser())
        .collection('completed_trips')
        .get()
        .then((value) => setState(() {
              length = value.docs.length.toString();
            }));
    print("End Date"+end_date);
  }

  @override
  void initState() {
    // TODO: implement initState
    user_details();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260.0,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
        color: Colors.green,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // const SizedBox(
          //   height: 10.0,
          // ),
          Flexible(
            child: Row(
              children: [
                const SizedBox(
                  width: 30.0,
                ),
                const SizedBox(
                  height: 120.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    child: Image(
                      image: AssetImage("images/logo.jpg"),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 30.0,
                ),
                SizedBox(
                  height: 120.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: Text(
                          drivername,
                          style: GoogleFonts.slabo13px(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "+91-$driverphonenumber",
                          style: GoogleFonts.slabo13px(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          "-$carnumber" ,
                          style: GoogleFonts.slabo13px(
                              color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                      Flexible(
                        child: Text(
                           " $carname",
                          style: GoogleFonts.slabo13px(
                              color: Colors.white, fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  // Text(
                  //   "Rides",
                  //   style: GoogleFonts.rubik(
                  //       color: Colors.white,
                  //       fontSize: 22.0,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Icon(
                    Icons.directions_car,
                    size: 35.0,
                    color: Colors.white,
                  ),
                  Text(
                    length,
                    style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  // Text(
                  //   "Wallet",
                  //   style: GoogleFonts.rubik(
                  //       color: Colors.white,
                  //       fontSize: 22.0,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryPage()));
                    },
                    child: Icon(
                      Icons.account_balance_wallet,
                      size: 35,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "$wallet",
                        style: GoogleFonts.rubik(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      // const Icon(
                      //   Icons.star,
                      //   color: Colors.white,
                      // ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.access_time_filled,
                    size: 35,
                    color: Colors.white,
                  ),
                  // Text(
                  //   "Ends In",
                  //   style: GoogleFonts.rubik(
                  //       color: Colors.white,
                  //       fontSize: 22.0,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "$end_date" " Days Left",
                        style: GoogleFonts.rubik(
                            color: Colors.pink,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              InkWell(
                onTap: (){
                  launch('whatsapp://send?text=hi&phone=919551114411');
                },
                child: Container(
                  height: 50.0,
                  width: 80.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Center(child: Text("Contact",style: GoogleFonts.slabo13px(fontSize: 20,color: Colors.green,fontWeight: FontWeight.bold),)),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }
}
