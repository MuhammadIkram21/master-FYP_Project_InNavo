import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Screens/roomsearch.dart';

import 'login.dart';



class RegUser extends StatefulWidget {
  const RegUser({super.key});

  @override
  State<RegUser> createState() => _RegUserState();
}

class _RegUserState extends State<RegUser> {

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/welcome.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text("User"),
              actions: [
                IconButton(
                  onPressed: () {
                    logout(context);
                  },
                  icon: Icon(
                    Icons.logout,
                  ),
                )
              ],
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(50)),
                      color: Colors.white.withOpacity(0.7)),
                  child: Stack(children: [
                    Positioned(
                      top: 10,
                      left: 0,
                      child: Row(
                        children: [
                          Image.asset('assets/vlogotb.png',
                              width: 150, height: 150),
                          Text.rich(
                            TextSpan(
                              text: 'Welcome to ',
                              style: TextStyle(fontSize: 30,color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'InNavo',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 40,color: Colors.redAccent
                                    )),
                                // can add more TextSpans here...
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: height * 0.07),

                ///this container is for room search card
                ///class room card start from here///
                Container(
                  height: 230,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            height: 180.0,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: GestureDetector(
                          onTap: () {
                            // Navigation logic here, navigate to the next page
                            // when the card is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoomSearchPage()),
                            );
                          },
                          child: Card(
                            child: Container(
                              height: 170,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/classroom.png"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 45,
                        left: 180,
                        child: Container(
                          height: 150,
                          width: 230,
                          child: Column(
                            children: [
                              new GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => RoomSearchPage()));
                                },
                                child: Text(
                                  "Search about Class Rooms",
                                  style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //class room card end here

                SizedBox(
                  height: height * 0.03,
                ),

                ///this container is for office card
                ///office card start from here///
                Container(
                  height: 230,
                  child: Stack(
                    children: [
                      Positioned(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            height: 180.0,
                            width: width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(30),bottomRight: Radius.circular(30)),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        child: GestureDetector(
                          onTap: () {
                            // Navigation logic here, navigate to the next page
                            // when the card is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RoomSearchPage()),
                            );
                          },
                          child: Card(

                            child: Container(
                              height: 170,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("assets/office.png"),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 45,
                        left: 180,
                        child: Container(
                          height: 150,
                          width: 230,
                          child: Column(
                            children: [
                              new GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RoomSearchPage()));
                                  },
                                  child: Text(
                                    "Search about Offices",
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                  )
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //office card end here
              ],
            ))));
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
