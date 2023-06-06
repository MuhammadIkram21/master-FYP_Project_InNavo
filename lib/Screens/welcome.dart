import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Screens/login.dart';
import 'package:flutter_project/ReusedCode/reusable_widget.dart';
import 'package:flutter_project/Screens/GuestRoomSearchPg.dart';
import 'package:flutter_project/Suppot/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _interstitialLoadAttempts = 0;
  late String _name;

  late BannerAd _bottomBannerAd;
  InterstitialAd? _interstitialAd;

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

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialLoadAttempts += 1;
          _interstitialAd = null;
          if (_interstitialLoadAttempts <= maxFailedLoadAttempts) {
            _createInterstitialAd();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
    _createInterstitialAd();
  }
  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
    _interstitialAd?.dispose();
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
                              _showInterstitialAd();
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
                              _showInterstitialAd();
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
                                          _showInterstitialAd();
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