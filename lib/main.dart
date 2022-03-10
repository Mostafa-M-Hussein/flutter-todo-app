import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app_v2/todo/home.dart';

import 'auth/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

   Widget homeScreen;

  final User? user =  await FirebaseAuth.instance.currentUser ;

  if (user == null) {
    homeScreen = HomeScreen();
  } else {
    homeScreen = LoginScreen();
  }

  runApp(MyApp(homeScreen));
}

class MyApp extends StatelessWidget {
  final Widget home;

   MyApp(this.home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: this.home ,
    );
  }
}
