import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_project/Screens/arTestPage.dart';
import 'package:image_picker/image_picker.dart';

class RoomSearchPage extends StatefulWidget {
  @override
  _RoomSearchPageState createState() => _RoomSearchPageState();
}

class _RoomSearchPageState extends State<RoomSearchPage> {
  final _database = FirebaseFirestore.instance.collection('rooms');
  final ImagePicker _picker = ImagePicker();

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
          future: _openCamera(),
          builder: (context, AsyncSnapshot<void> snapshot) {
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
                    Text('Address: ${room['address']}'),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () async {

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => LocalAndWebObjectsView()));

                      // final XFile? photo =
                      // await _picker.pickImage(source: ImageSource.camera);
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
    return LayoutBuilder(
      builder: (context, constraints) {
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
                      _rooms = _rooms.where((room) {
                        final roomName = room['name'].toLowerCase();
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
                    final room = _rooms[index];
                    return ListTile(
                      title: Text(room['name']),
                      subtitle: Text(room['address']),
                      onTap: () {
                        _showRoomDetails(context, room);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
