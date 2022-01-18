import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/screens/home_page.dart';
import 'package:testing/screens/login_screen.dart';
import 'package:testing/screens/user_info_screen.dart';

class OTPScreen extends StatefulWidget {
  final String verificationid;
  const OTPScreen({Key? key,required this.verificationid,}) : super(key: key);


  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _auth= FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool loading =false;
  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.0)));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  void signinwithcredential(PhoneAuthCredential phoneAuthCredential) async{
    bool subscribed_user_checker = false ;
    setState(() {
      loading=true;
    });
    try{
      final authcredential= await _auth.signInWithCredential(phoneAuthCredential);
      await _firestore.collection('subscribed_users').doc((_auth.currentUser!.phoneNumber!.substring(3))).get().then((value) {
        subscribed_user_checker = value.exists;
        print(value.id);
      });

      // final String user_id = await _firestore.collection('subscribed_users').doc(_auth.currentUser!.phoneNumber.toString()).get().then((value) => value.exists);
      print(_auth.currentUser);
      print(subscribed_user_checker);

      if(subscribed_user_checker){
        if (authcredential.user != null) {
          // setState(() {
          //   loading = false;
          // });
          final token = await FirebaseMessaging.instance.getToken();
          await _firestore.collection('subscribed_users').doc(
              _auth.currentUser!.phoneNumber!.substring(3)).set(
              {'token': token}, SetOptions(merge: true));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>
                  HomePage()), (Route<dynamic> route) => false);
          // Navigator.push(context,
          //     MaterialPageRoute(builder: (context) => const HomePage()));
        }
      }

      else{
        //await _auth.signOut();
        //showSnackBar("You Are Not A Subscribed User");
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UserInformation()));
      }
    }on FirebaseAuthException catch(e){
      setState(() {
        loading=false;
      });
      showSnackBar(e.code.toString());
    }

  }
  final otpcontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading?const Center(
          child: CircularProgressIndicator(),
        ):SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 200.0,
                ),
                const Image(
                  image: AssetImage("images/logo.jpg"),
                  height: 150.0,
                  width: 200.0,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Enter The OTP",
                  style: GoogleFonts.rubik(
                      color: Colors.green,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                TextField(
                  controller: otpcontroller,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(color: Colors.transparent),
                      ),
                      filled: true,
                      hintStyle: GoogleFonts.rubik(color: Colors.grey),
                      fillColor: Colors.grey[300],

                      labelText: "OTP"),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 17.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: InkWell(
                    onTap: () async{
                      setState(() {
                        loading=true;
                      });
                      PhoneAuthCredential phoneAuthCredential=PhoneAuthProvider.credential(verificationId: widget.verificationid, smsCode: otpcontroller.text);
                      print('0000000000000000000000000');
                      signinwithcredential(phoneAuthCredential);

                    },
                    child: Container(
                      height: 55.0,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color: Colors.green),
                      child: Center(
                          child: Text(
                        "SUBMIT",
                        style: GoogleFonts.rubik(color: Colors.white, fontSize: 20.0),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


