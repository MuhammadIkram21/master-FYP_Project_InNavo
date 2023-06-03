import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_project/Screens/opencamera.dart';

class RoomSearchPage extends StatefulWidget {
  @override
  _RoomSearchPageState createState() => _RoomSearchPageState();
}

class _RoomSearchPageState extends State<RoomSearchPage> {
  final _database = FirebaseFirestore.instance.collection('rooms');
  // final _storage = FirebaseStorage.instance.ref();

  List<DocumentSnapshot> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  void _loadRooms() {
    _database.get().then((snapshot) {
      setState(() {
        _rooms = snapshot.docs;
      });
    });
  }

  void _showRoomDetails(BuildContext context, DocumentSnapshot room) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder(
          future: Future.wait([
            // _storage.child(room['image']).getDownloadURL(),
            _openCamera(),
          ]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return AlertDialog(
                title: Text(room['name']),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.network(
                    //   snapshot.data[0],
                    //   width: 100,
                    //   height: 100,
                    // ),
                    Text('Address: ${room['address']}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CameraScreen()));
                    },
                    child: Text('Open Camera'),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }

  Future<void> _openCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    // code to open camera goes here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _rooms = _rooms.where((rooms) {
                    final roomName = rooms['name'].toLowerCase();
                    final query = value.toLowerCase();

                    return roomName.contains(query);
                  }).toList();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search for rooms',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                final rooms = _rooms[index];

                return ListTile(
                  title: Text(rooms['name']),
                  subtitle: Text(rooms['address']),
                  onTap: () {
                    _showRoomDetails(context, rooms);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
