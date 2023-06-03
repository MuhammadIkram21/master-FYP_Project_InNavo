import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/Screens/admin.dart';
import 'package:flutter_project/Screens/forgetpassword.dart';
import 'package:flutter_project/Screens/login.dart';
import 'package:flutter_project/Screens/roomsearch.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/Screens/splashscreen.dart';
import 'package:flutter_project/Screens/welcome.dart';
import 'package:flutter_project/Screens/GuestRoomSearchPg.dart';
import 'Suppot/firebase_options.dart';
import 'package:flutter_project/Screens/opencamera.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  cameras = await availableCameras();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: Brightness.light),
    darkTheme: ThemeData(brightness: Brightness.dark),
    themeMode: ThemeMode.system,
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      'welcome': (context) => const Welcome(),
      'login': (context) =>  LoginPage(),
      'forgetpassword': (context) => const Forgetpassword(),
      'roomsearch': (context) => RoomSearchPage(),
      'opencamera': (context) => CameraScreen(),
      'GuestRoomSearchPg':(context) => GuestRoomSearch(),
      'admin':(context) => AdminPanel(),
    },
  ));
}
