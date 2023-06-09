// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:passwordfield/passwordfield.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/models/userModel.dart';
import 'package:railway_system/screens/login.dart';
import 'package:railway_system/screens/user.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);
  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      uname = TextEditingController(),
      pass = TextEditingController(),
      cpass = TextEditingController();
  final _key = GlobalKey<FormState>();
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color.fromARGB(255, 199, 225, 246)),
        width: double.infinity,
        padding: EdgeInsets.only(top: 150, bottom: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Form(
              key: _key,
              autovalidateMode: _autovalidate,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: TextFormField(
                        controller: name,
                        validator: (value) {
                          if (value == "") {
                            return 'name cannot be empty';
                          }
                          if (value.toString().length < 3) {
                            return 'name too short!';
                          }
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Name',
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: TextFormField(
                        controller: email,
                        validator: (value) {
                          if (value == "") {
                            return 'email cannot be empty';
                          }
                          if (!value.toString().isValidEmail()) {
                            return 'email address not valid';
                          }
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  SizedBox(
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: TextFormField(
                        controller: uname,
                        validator: (value) {
                          if (value == "") {
                            return 'username cannot be empty';
                          }
                          if (value.toString().length < 3) {
                            return 'username too short!';
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
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: TextFormField(
                        obscureText: true,
                        controller: pass,
                        validator: (value) {
                          if (value == "") {
                            return 'password cannot be empty';
                          }
                          if (value.toString().length < 6) {
                            return 'Password too short!';
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
                    width: 200,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      child: TextFormField(
                        obscureText: true,
                        controller: cpass,
                        validator: (value) {
                          if (value != pass.text) {
                            return 'passwords do not match';
                          }
                        },
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'confirm password',
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
                          final res = await DatabaseService().userSignUp(
                              context,
                              UserModel(
                                  email: email.text.toString(),
                                  name: name.text.toString(),
                                  username: uname.text.toString()),
                              pass.text.toString());
                          if (res) {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => UserPage()));
                          }
                        } else {
                          _autovalidate = AutovalidateMode.always;
                        }
                      },
                      child: Text('Sign up')),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Existing User?'),
                      TextButton(
                        onPressed: () => {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()))
                        },
                        child: Text('Login'),
                      ),
                    ],
                  )
                ],
              ),
            ),
            InkWell(
                onTap: () {
                  launch('https://github.com/dhairyajoshi');
                },
                child: Text(
                  'Copyright ©Dhairya Joshi',
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
