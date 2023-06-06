import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/Screens/forgetpassword.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_project/Suppot/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'user.dart';
import 'admin.dart';
import 'register.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isObscure3 = true;
  bool visible = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  int _interstitialLoadAttempts = 0;
  InterstitialAd? _interstitialAd;
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }


  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }
  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

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
            bottomNavigationBar: _isBottomBannerAdLoaded
                ? Container(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
                : null,
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
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.all(12),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Login",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 40,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 500,
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Email',
                                        hintStyle: TextStyle(color: Colors.black),
                                        enabled: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0, bottom: 8.0, top: 8.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.white),
                                          borderRadius: new BorderRadius.circular(40),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.white),
                                          borderRadius: new BorderRadius.circular(20),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return "Email cannot be empty";
                                        }
                                        if (!RegExp(
                                            "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                            .hasMatch(value)) {
                                          return ("Please enter a valid email");
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        emailController.text = value!;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextFormField(
                                      style: TextStyle(color: Colors.black),
                                      controller: passwordController,
                                      obscureText: _isObscure3,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                            icon: Icon(_isObscure3
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                                color: Colors.grey),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure3 = !_isObscure3;
                                              });
                                            }),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: 'Password',
                                        hintStyle: TextStyle(color: Colors.black),
                                        enabled: true,
                                        contentPadding: const EdgeInsets.only(
                                            left: 14.0, bottom: 8.0, top: 15.0),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.white),
                                          borderRadius: new BorderRadius.circular(40),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: new BorderSide(color: Colors.white),
                                          borderRadius: new BorderRadius.circular(20),
                                        ),
                                      ),
                                      validator: (value) {
                                        RegExp regex = new RegExp(r'^.{6,}$');
                                        if (value!.isEmpty) {
                                          return "Password cannot be empty";
                                        }
                                        if (!regex.hasMatch(value)) {
                                          return ("please enter valid password min. 6 character");
                                        } else {
                                          return null;
                                        }
                                      },
                                      onSaved: (value) {
                                        passwordController.text = value!;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    forgetPassword(context),

                                    SizedBox(
                                      height: 40,
                                    ),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(20.0))),
                                      elevation: 5.0,
                                      height: 40,
                                      onPressed: () {
                                        setState(() {
                                          visible = true;
                                        });
                                        signIn(
                                            emailController.text, passwordController.text);
                                      },
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black
                                        ),
                                      ),
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    signUpOption(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Visibility(
                                        maintainSize: true,
                                        maintainAnimation: true,
                                        maintainState: true,
                                        visible: visible,
                                        child: Container(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                            ))),
                                  ],

                                ),
                              ),
                            ),

                          ),
                        ),
                      ],
                    ),
                  ),
                ])));
  }

  void route() {
    User? user = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('role') == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminPanel(),
            ),
          );
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>  RegUser(),
            ),
          );
        }
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  signIn(String email, String password) async {
    if (_formkey.currentState!.validate()) {
      try {
        UserCredential userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        route();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          return('Wrong password provided for that user.');
        }
      }
    }
  }


  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Register()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }

  Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.right,
        ),
        onPressed: () =>
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Forgetpassword())),
      ),
    );
  }
}