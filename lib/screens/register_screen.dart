import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/screens/home_page.dart';
import 'package:testing/screens/otp_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class NewDriver extends StatefulWidget {
  const NewDriver({Key? key}) : super(key: key);

  @override
  _NewDriverState createState() => _NewDriverState();
}

class _NewDriverState extends State<NewDriver> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  bool subscribed_user_checker = false ;
  String dropdownValue = 'Round';
  String cabtypevalue = 'Suv-Ac';
  DateTime _dateTime = DateTime.now();
  String name ='';
  String phone_number='';
  String address='';
  String car_number = '';
  String car_name = '';
  late String verificationId;

  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.0)));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green[400],
        title: Text(
          "Register ",
          style: GoogleFonts.ubuntu(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //name
            Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    "Name",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value){
                  name=value;
                },
                style: GoogleFonts.ubuntu(),
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  filled: true,
                  hintText: "Enter Name",
                  hintStyle: GoogleFonts.ubuntu(color: Colors.grey),
                  fillColor: Colors.green[100],
                  // labelText: "Phone.No",
                  // labelStyle: GoogleFonts.ubuntu(color: Colors.green),
                ),
              ),
            ),

            //mobile_number
            Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    "Mobile Number",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value){
                  phone_number=value;
                },
                style: GoogleFonts.ubuntu(),
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  hintText: "Enter Mobile Number ",
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.grey),
                  fillColor: Colors.green[100],
                  // labelText: "Phone.No",
                  // labelStyle: GoogleFonts.ubuntu(color: Colors.green),
                ),
              ),
            ),

            //date
            Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    "Date",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                showDatePicker(
                    context: context,
                    initialDate:
                    _dateTime,
                    firstDate: DateTime(2019),
                    lastDate: DateTime(2022)).then((date) {
                  setState(() {
                    _dateTime = date!;
                  });
                });
              },
              child: Container(
                height: 57.0,
                width: 350.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.green[100],
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 10.0,),
                    Text(_dateTime == null
                        ? "nothing"
                        : _dateTime
                        .toString()
                        .replaceRange(11, _dateTime.toString().length, ''),style: GoogleFonts.ubuntu(fontSize: 19.0),),
                    const SizedBox(width: 180.0,),
                    const Icon(Icons.calendar_today,color: Colors.green,)
                  ],
                ),
              ),
            ),

            //car_number
            Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    "Car Number",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value){
                  car_number=value;
                },
                style: GoogleFonts.ubuntu(),
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  filled: true,
                  hintText: "Enter Car Number",
                  hintStyle: GoogleFonts.ubuntu(color: Colors.grey),
                  fillColor: Colors.green[100],
                  // labelText: "Phone.No",
                  // labelStyle: GoogleFonts.ubuntu(color: Colors.green),
                ),
              ),
            ),

            //car_name
            Row(
              children: [
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: Text(
                    "Car Name",
                    style: GoogleFonts.ubuntu(
                        fontSize: 18.0,
                        color: Colors.green,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: TextField(
                onChanged: (value){
                  car_name=value;
                },
                style: GoogleFonts.ubuntu(),
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(color: Colors.green),
                  ),
                  filled: true,
                  hintText: "Enter Car Name",
                  hintStyle: GoogleFonts.ubuntu(color: Colors.grey),
                  fillColor: Colors.green[100],
                  // labelText: "Phone.No",
                  // labelStyle: GoogleFonts.ubuntu(color: Colors.green),
                ),
              ),
            ),


            const SizedBox(height: 20.0,),


            //button
            InkWell(
              onTap: ()async{
                if (phone_number.length != 10) {
                  showSnackBar("Enter The Valid Phone Number");
                }

                else {
                  setState(() {
                    loading = true;
                  });


                  await _auth.verifyPhoneNumber(
                      phoneNumber:
                      "+91 " + phone_number,
                      verificationCompleted:
                          (phoneAuthCredential) async {
                        setState(() {
                          loading = true;
                        });

                        await _auth.signInWithCredential(phoneAuthCredential);
                        await _firestore.collection('subscribed_users').doc((_auth.currentUser!.phoneNumber!.substring(3))).get().then((value) {
                          subscribed_user_checker = value.exists;
                          print(value.id);
                        });

                        // setState(() {
                        //   loading = true;
                        // });
                        final token = await FirebaseMessaging.instance.getToken();
                        await _firestore.collection('subscribed_users').doc(_auth.currentUser!.phoneNumber!.substring(3)).set({'token':token},SetOptions(merge: true));
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                            HomePage()), (Route<dynamic> route) => false);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => const HomePage()));


                        // await _auth.signOut();
                        // showSnackBar("You Are Not A Subscribed User");
                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

                        print('111111111111111');
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //         const HomePage()));
                      },
                      verificationFailed:
                          (verificationFailed) async {
                        setState(() {
                          loading = false;
                        });
                        showSnackBar(verificationFailed.code);

                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(verificationFailed.toString())));
                      },
                      codeSent: (verificationId,
                          resendingToken) async {
                        setState(() {
                          loading = false;
                          this.verificationId =
                              verificationId;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                OTPScreen(
                                  verificationid: verificationId,
                                ),
                          ),
                        );
                      },
                      codeAutoRetrievalTimeout:
                          (verificationId) async {});
                }
                // _firestore.collection('not_subscribed_users').doc(phone_number).set({
                //   'name':name,
                //   'phone_number':phone_number,
                //   'subscribed_date':DateFormat('yyyy-MM-dd').format(_dateTime),
                //   'car_number':car_number,
                //   'car_name':car_name,
                //   'wallet':0,
                //   'time':FieldValue.serverTimestamp(),
                // });
                // Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.green,
                  ),
                  height: 55.0,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Register",
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
