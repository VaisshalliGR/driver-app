import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Transaction History",
          style: GoogleFonts.rubik(),
        ),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('subscribed_users')
              .doc(auth.currentUser!.phoneNumber!.substring(3))
              .collection('history').orderBy('time_stamp')
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<ListTile> listelements = [];
            final info = snapshot.data!.docs.reversed;
            for (var i in info) {
              listelements.add(
                ListTile(
                  title: Text(i['title'],style: GoogleFonts.rubik(fontSize: 20.0)),
                  leading: Text(i['leading'],style: GoogleFonts.rubik(fontSize: 20.0)),
                    trailing: SizedBox(
                      width: 130.0,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(i['previous_balance'].toString()+'₹',style: GoogleFonts.rubik(fontSize: 20.0)),
                            Text(i['trailing']+'₹',style: GoogleFonts.rubik(color: i['title']=='credited'?Colors.green:Colors.red,fontSize: 19.0),),
                          ],
                        ),
                      ),
                    ),

                ),
              );
            }
            return ListView(
              children: ListTile.divideTiles(tiles:listelements,context: context,color: Colors.black).toList(),
            );
          }),
    );
  }
}
