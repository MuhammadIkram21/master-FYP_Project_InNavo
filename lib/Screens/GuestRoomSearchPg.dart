import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'login.dart';


class GuestRoomSearch extends StatefulWidget {
  const GuestRoomSearch({Key? key}) : super(key: key);

  @override
  _GuestRoomSearchState createState() => _GuestRoomSearchState();
}

class _GuestRoomSearchState extends State<GuestRoomSearch> {
  String? _currentAddress;
  Position? _currentPosition;
  CollectionReference rooms = FirebaseFirestore.instance.collection('rooms');
  String entries = '';

  String name = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  getData() async {
    await rooms.get();
  }

  @override
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Rooms Details"),
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
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/vlogotb.png'),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
              ),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                        FirebaseFirestore.instance
                            .collection('rooms')
                            .where('name', isEqualTo: val)
                            .snapshots() // Use snapshots() to listen for real-time updates
                            .listen((QuerySnapshot querySnapshot) {
                          setState(() {
                            entries = querySnapshot.docs.isNotEmpty
                                ? querySnapshot.docs
                                .map((doc) => doc['address'])
                                .toList()
                                .join(', ')
                                : '';
                          });
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        hintText: "Where You want to go",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: const BorderSide(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    entries != ''
                        ? SizedBox(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(width: 1.0, color: Colors.black),
                        ),
                        child: ListTile(
                          title: Text(entries),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    insetPadding: EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 300.0,),
                                  title: Text('Room Details'),
                                  content: Column(
                                    children: [
                                      Text('Name: $name'),
                                      Text('Address: $entries'),
                                      // Image('image: $image')
                                    ],
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigate to camera page
                                      },
                                      child: Text('Navigate to Camera Page'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Close'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                        : // Rest of the code
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('LAT: ${_currentPosition?.latitude ?? ""}'),
                          Text('LNG: ${_currentPosition?.longitude ?? ""}'),
                          Text('ADDRESS: ${_currentAddress ?? ""}'),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: _getCurrentPosition,
                            child: const Text("Get Current Location"),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'NOTE: To use all the features of our app please login as a member *',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            )));
  }
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


