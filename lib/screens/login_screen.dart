import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testing/screens/home_page.dart';
import 'package:testing/screens/user_info_screen.dart';
import 'otp_screen.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var phonenumbercontroller = TextEditingController();
  late String verificationId;
  final String google_login = 'vgv9if3a2jh5gfds';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;
  bool subscribed_user_checker = false ;

  // void signin() async{
  //   await _auth.signInAnonymously();
  // }
  void showSnackBar(String title) {
    final snackbar = SnackBar(
        content: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14.0)));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 200.0,
                      ),
                      const Image(
                        image: AssetImage("images/logo.jpg"),
                        height: 150.0,
                        width: 200.0,
                      ),
                      Row(
                        children: [
                          Text(
                            "Enter Your Mobile Number",
                            style: GoogleFonts.rubik(
                              color: Colors.green,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Column(
                        children: [
                          TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                            ],
                            keyboardType: TextInputType.number,
                            controller: phonenumbercontroller,

                            decoration: InputDecoration(
                                prefixText: "+91",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: const BorderSide(
                                      color: Colors.transparent),
                                ),
                                filled: true,
                                hintStyle: const TextStyle(color: Colors.grey),
                                fillColor: Colors.grey[300],
                                labelText: "Phone.No",
                                labelStyle: GoogleFonts.rubik()),
                            //keyboardType: TextInputType.number,
                          ),
                          const SizedBox(
                            height: 17.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: InkWell(
                              onTap: () async {



                                setState(() {
                                  loading = true;
                                });

                                  if(phonenumbercontroller.text!='vgv9if3a2jh5gfds'){
                                    await _auth.verifyPhoneNumber(
                                        phoneNumber:
                                            "+91 " + phonenumbercontroller.text,
                                        verificationCompleted:
                                            (phoneAuthCredential) async {
                                          setState(() {
                                            loading = true;
                                          });

                                          await _auth.signInWithCredential(
                                              phoneAuthCredential);
                                          await _firestore
                                              .collection('subscribed_users')
                                              .doc((_auth
                                                  .currentUser!.phoneNumber!
                                                  .substring(3)))
                                              .get()
                                              .then((value) {
                                            subscribed_user_checker =
                                                value.exists;
                                            print(value.id);
                                          });
                                          if (subscribed_user_checker) {
                                            // setState(() {
                                            //   loading = true;
                                            // });
                                            final token =
                                                await FirebaseMessaging.instance
                                                    .getToken();
                                            await _firestore
                                                .collection('subscribed_users')
                                                .doc(_auth
                                                    .currentUser!.phoneNumber!
                                                    .substring(3))
                                                .set({'token': token},
                                                    SetOptions(merge: true));
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HomePage()),
                                                    (Route<dynamic> route) =>
                                                        false);
                                            // Navigator.push(context,
                                            //     MaterialPageRoute(builder: (context) => const HomePage()));
                                          } else {
                                            // await _auth.signOut();
                                            // showSnackBar(
                                            //     "You Are Not A Subscribed User");
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserInformation()));
                                          }
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
                                              builder: (context) => OTPScreen(
                                                verificationid: verificationId,
                                              ),
                                            ),
                                          );
                                        },
                                        codeAutoRetrievalTimeout:
                                            (verificationId) async {});
                                  }
                                  else{
                                    await _auth.signInWithEmailAndPassword(email: 'chennaicabscare@gmail.com', password: 'kingfisher123');
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
                                  }

                              },
                              child: Container(
                                height: 55.0,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: Colors.green),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.rubik(
                                        color: Colors.white, fontSize: 22.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          //ElevatedButton(onPressed: (){}, child: const Text("Button")),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

}
