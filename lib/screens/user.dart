// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/screens/login.dart';
import 'package:railway_system/widgets/bookings.dart';
import 'package:railway_system/widgets/reservations.dart';
import 'package:railway_system/widgets/userprofile.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextStyle _style = TextStyle(fontSize: 30);
  int cur_idx = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Row(
            children: [
              Flexible(
                  flex: 2,
                  child: Container(
                    width: double.infinity,
                    color: Color.fromARGB(255, 122, 246, 235),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            cur_idx = 0;
                          }),
                          child: Text(
                            'User Profile',
                            style: _style,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            cur_idx = 1;
                          }),
                          child: Text(
                            'Reserve a seat',
                            style: _style,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            cur_idx = 2;
                          }),
                          child: Text(
                            'All bookings',
                            style: _style,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            DatabaseService().userLogout();
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: ((context) => LoginPage())));
                          },
                          child: Text(
                            'Logout',
                            style: _style,
                          ),
                        ),
                      ],
                    ),
                  )),
              Flexible(
                  flex: 7,
                  child: Container(
                    width: double.infinity,
                    color: cur_idx == 0
                        ? Color.fromARGB(255, 118, 89, 0)
                        : (cur_idx == 1
                            ? Color.fromARGB(255, 27, 114, 1)
                            : (cur_idx == 2 ? Colors.green : Colors.yellow)),
                    child: cur_idx == 0
                        ? UserProfile()
                        : (cur_idx == 1 ? bookings() : Reservation()),
                  ))
            ],
          )),
    );
  }
}
