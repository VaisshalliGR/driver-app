import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key, required this.final_fare}) : super(key: key);
  final String final_fare;

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(),backgroundColor: Colors.green,title: Text("Final Bill"),centerTitle: true,),
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Material(
            elevation: 20.0,
            borderRadius: BorderRadius.circular(20.0),
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              child:  Column(
                children: [
                  SizedBox(height: 30.0,),
                  Text("Collect",style: GoogleFonts.rubik(fontSize: 40.0,color: Colors.green,fontWeight: FontWeight.bold),),
                  SizedBox(height: 40.0,),
                  Text("Rs.${widget.final_fare}",style: GoogleFonts.rubik(fontSize: 50.0,color: Colors.black,fontWeight: FontWeight.bold),),
                  SizedBox(height: 30.0,),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Go back"),style: ElevatedButton.styleFrom(primary: Colors.green),)
                ],
              ),
            ),
          ),
        )
        //Text("Collect",style: GoogleFonts.rubik(fontSize: ),)
      ],
    ));
  }
}
