import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _guestUsers = [];
  List<Map<String, dynamic>> _roomDetails = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
    fetchGuestUsers();
    fetchRoomDetails();
  }

  Future<void> fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('user').get();
      List<Map<String, dynamic>> users = [];
      querySnapshot.docs.forEach((doc) {
        users.add(doc.data() as Map<String, dynamic>);
      });
      setState(() {
        _users = users;
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> fetchGuestUsers() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('g-user').get();
      List<Map<String, dynamic>> guestUsers = [];
      querySnapshot.docs.forEach((doc) {
        guestUsers.add(doc.data() as Map<String, dynamic>);
      });
      setState(() {
        _guestUsers = guestUsers;
      });
    } catch (e) {
      print('Error fetching guest users: $e');
    }
  }

  Future<void> fetchRoomDetails() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('rooms').get();
      List<Map<String, dynamic>> roomDetails = [];
      querySnapshot.docs.forEach((doc) {
        roomDetails.add(doc.data() as Map<String, dynamic>);
      });
      setState(() {
        _roomDetails = roomDetails;
      });
    } catch (e) {
      print('Error fetching room details: $e');
    }
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _navScreens = [
      Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'All Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildUserList(),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Guest Users',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildGuestUserList(),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Room Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            _buildRoomDetailsList(),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Room',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RoomForm(),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: SingleChildScrollView(
        child: _navScreens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person,color: Colors.grey,),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline,color: Colors.grey,),
            label: 'Guests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.room_preferences,color: Colors.grey,),
            label: 'Rooms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add,color: Colors.grey,),
            label: 'Add Room',
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    if (_users.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_users[index]['name'] ?? ''),
            subtitle: Text(_users[index]['email'] ?? ''),
          );
        },
      );
    }
  }

  Widget _buildGuestUserList() {
    if (_guestUsers.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _guestUsers.length,
        itemBuilder: (context, index) {
          final timestamp = _guestUsers[index]['Timestamp'] as Timestamp;
          final dateTime = timestamp.toDate();
          final formattedTimestamp =
              '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';

          return ListTile(
            title: Text(_guestUsers[index]['Name'] ?? ''),
            subtitle: Text(formattedTimestamp),
          );
        },
      );
    }
  }

  Widget _buildRoomDetailsList() {
    if (_roomDetails.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _roomDetails.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_roomDetails[index]['name'] ?? ''),
            subtitle: Text(_roomDetails[index]['address'] ?? ''),
          );
        },
      );
    }
  }
}

class RoomForm extends StatefulWidget {
  @override
  _RoomFormState createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _addRoom() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final address = _addressController.text;

      // Store the room details in Firestore
      FirebaseFirestore.instance.collection('rooms').add({
        'name': name,
        'address': address,
      });

      // Clear the form fields
      _nameController.clear();
      _addressController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Room added successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the room name';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _addressController,
            decoration: InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the room address';
              }
              return null;
            },
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addRoom,
            child: Text('Add Room'),
          ),
        ],
      ),
    );
  }
}
