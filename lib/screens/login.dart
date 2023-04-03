// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/screens/admin.dart';
import 'package:railway_system/screens/signup.dart';
import 'package:railway_system/screens/user.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/userModel.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  TextEditingController uname = TextEditingController(),
      pass = TextEditingController();
  final _key = GlobalKey<FormState>();
  AutovalidateMode _autovalid = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 199, 225, 246)),
        width: double.infinity,
        padding: EdgeInsets.only(top: 200,bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              autovalidateMode: _autovalid,
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Railway Reservation System',
                    style: TextStyle(fontSize: 50),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: uname,
                        onChanged: (val) =>
                            {_autovalid = AutovalidateMode.disabled},
                        validator: (value) {
                          if (value == "") {
                            return 'username cannot be empty';
                          }
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'username',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: TextFormField(
                        obscureText: true,
                        controller: pass,
                        onChanged: (val) =>
                            {_autovalid = AutovalidateMode.disabled},
                        validator: (value) {
                          if (value == "") {
                            return 'password cannot be empty';
                          }
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'password',
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if (_key.currentState!.validate()) {
                          if (await DatabaseService()
                              .userLogin(context, uname.text, pass.text)) {
                            UserModel? user = await DatabaseService().getUser();
                            if (user != null) {
                              if (user.isAdmin) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => AdminPage()));
                              } else {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => UserPage()));
                              }
                            }
                          }
                        } else {
                          _autovalid = AutovalidateMode.always;
                        }
                      },
                      child: Text('Login')),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('New User?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => SignupPage()));
                        },
                        child: Text('Sign up'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell( 
              onTap: (){
                launch('https://github.com/dhairyajoshi');
              },
              child: Text('Copyright ©Dhairya Joshi',style: TextStyle(color: Colors.blue),)) 
          ],
        ),
      ),
    );
  }
}
