import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:testing/screens/home_page.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
class UserInformation extends StatefulWidget {
  const UserInformation({Key? key}) : super(key: key);

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  String dropdownValue = 'Round';
  String cabtypevalue = 'Suv-Ac';
  DateTime _dateTime = DateTime.now();
  String name ='';
  String phone_number='';
  String address='';
  String car_number = '';
  String car_name = '';
  String? getcurrentuser() {
    return _auth.currentUser!.phoneNumber!.substring(3);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green[400],
        title: Text(
          "New Driver",
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
            // Row(
            //   children: [
            //     Padding(
            //       padding:
            //       const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
            //       child: Text(
            //         "Mobile Number",
            //         style: GoogleFonts.ubuntu(
            //             fontSize: 18.0,
            //             color: Colors.green,
            //             fontWeight: FontWeight.w600),
            //       ),
            //     ),
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //   child: TextField(
            //     onChanged: (value){
            //       phone_number=value;
            //     },
            //     style: GoogleFonts.ubuntu(),
            //     cursorColor: Colors.green,
            //     decoration: InputDecoration(
            //       enabledBorder: const OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.transparent)),
            //       focusedBorder: const OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.transparent),
            //       ),
            //       border: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(8.0),
            //         borderSide: const BorderSide(color: Colors.green),
            //       ),
            //       hintText: "Enter Mobile Number ",
            //       filled: true,
            //       hintStyle: const TextStyle(color: Colors.grey),
            //       fillColor: Colors.green[100],
            //       // labelText: "Phone.No",
            //       // labelStyle: GoogleFonts.ubuntu(color: Colors.green),
            //     ),
            //   ),
            // ),

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

            // Row(
            //   //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     const SizedBox(width: 25.0,),
            //     Text("TripType",style: GoogleFonts.ubuntu(fontSize: 19.0),),
            //     const SizedBox(width: 175.0,),
            //     Text("CabType",style: GoogleFonts.ubuntu(fontSize: 19.0),),
            //   ],),
            // Row(
            //   //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //   children: [
            //     const SizedBox(width: 25.0,),
            //     DropdownButton<String>(
            //       borderRadius: BorderRadius.circular(8.0),
            //       value: dropdownValue,
            //       icon: const Icon(Icons.arrow_drop_down_rounded),
            //       iconSize: 30,
            //       elevation: 16,
            //       style: const TextStyle(color: Colors.green),
            //       underline: Container(
            //         height: 2,
            //         color: Colors.green,
            //       ),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           dropdownValue = newValue!;
            //         });
            //
            //       },
            //       items: <String>[
            //         'Round',
            //         'Drop',
            //       ].map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(
            //             value,
            //             style: GoogleFonts.ubuntu(fontSize: 20.0),
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //     const SizedBox(width: 160.0,),
            //     DropdownButton<String>(
            //       borderRadius: BorderRadius.circular(8.0),
            //       value: cabtypevalue,
            //       icon: const Icon(Icons.arrow_drop_down_rounded),
            //       iconSize: 30,
            //       elevation: 16,
            //       style: const TextStyle(color: Colors.green),
            //       underline: Container(
            //         height: 2,
            //         color: Colors.green,
            //       ),
            //       onChanged: (String? newValue) {
            //         setState(() {
            //           cabtypevalue = newValue!;
            //         });
            //       },
            //       items: <String>['Suv-Ac', 'Xuv-Ac', 'Tuv-Ac']
            //           .map<DropdownMenuItem<String>>((String value) {
            //         return DropdownMenuItem<String>(
            //           value: value,
            //           child: Text(
            //             value,
            //             style: GoogleFonts.ubuntu(fontSize: 20.0),
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 20.0,),


            //button
            InkWell(
              onTap: ()async{
                await _firestore.collection('subscribed_users').doc(getcurrentuser()).set({
                  'name':name,
                  'phone_number':getcurrentuser(),
                  'subscribed_date':DateFormat('yyyy-MM-dd').format(_dateTime),
                  'car_number':car_number,
                  'car_name':car_name,
                  'wallet':0,
                  'time':FieldValue.serverTimestamp(),
                });
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>
                        HomePage()), (Route<dynamic> route) => false);
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
