import 'package:flutter/material.dart';
import 'package:railway_system/screens/login.dart';
import 'package:railway_system/screens/signup.dart';
import 'package:railway_system/screens/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  final pref = await SharedPreferences.getInstance();
  final token = pref.getString('token');
  final scr = token==null?0:1;
  runApp(MyApp(scr));
}

class MyApp extends StatelessWidget{
  MyApp(this.screen) : super();
  int screen;
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Railway Reservation System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: screen==1?UserPage():LoginPage(), 
    );
  }
}
