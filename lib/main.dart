import 'package:flutter/material.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/models/userModel.dart';
import 'package:railway_system/screens/admin.dart';
import 'package:railway_system/screens/login.dart';
import 'package:railway_system/screens/signup.dart';
import 'package:railway_system/screens/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  final pref = await SharedPreferences.getInstance();
  final token = pref.getString('token');
  int src=0;
  if (token != null) {
    UserModel? user = await DatabaseService().getUser();
    if (user != null) {
      if (user.isAdmin) {
        src = 2;
      } else {
        src = 1;
      }
    }
  }
  runApp(MyApp(src));
}

class MyApp extends StatelessWidget {
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
      home:
          screen == 0 ? LoginPage() : (screen == 1 ? UserPage() : AdminPage()),
    );
  }
}
 