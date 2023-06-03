import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Screens/roomsearch.dart';
import 'package:flutter_project/Screens/login.dart';
import 'package:flutter_project/ReusedCode/reusable_widget.dart';
import 'package:flutter_project/Screens/GuestRoomSearchPg.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late String _name;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/welcome.jpg'),
          fit: BoxFit.fill,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [Container(
            padding: EdgeInsets.only(right: 20, top: 50),
            child: Image.asset(
              'assets/vlogotb.png',
              height: 600,

            ),
          ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.5,
                    left: 50,
                    right: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(50),
                      child: Column(
                        children: [
                          firebaseUIButton(context, "SignIn As Admin", () {
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            }
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          firebaseUIButton(context, "SignIn As Member", () {
                            {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            }
                          }),
                          SizedBox(
                            height: 20,
                          ),
                          firebaseUIButton(context, "Login As Guest", () {
                            {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text("Enter your name"),
                                  content: TextField(
                                    onChanged: (String value) {
                                      setState(() {
                                        _name = value;
                                      });
                                    },
                                    decoration: InputDecoration(hintText: "Name"),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text("Save"),
                                      onPressed: () {
                                        FirebaseFirestore.instance.collection('g-user').add({
                                          "Name": _name,
                                          "Timestamp": FieldValue.serverTimestamp(),
                                        }).then((value) {
                                          print("guest added");
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (context) => GuestRoomSearch()));
                                        }).onError((error, stackTrace) {
                                          print("Error ${error.toString()}");
                                        });
                                      },
                                    ),
                                  ],
                                ),);
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => Guest()));
                            }
                          }),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}