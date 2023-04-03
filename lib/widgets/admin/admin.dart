import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../database/database_services.dart';
import '../../models/userModel.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  bool _savedisabled = false, _canceldisabled = false;
  TextEditingController name = TextEditingController(),
      email = TextEditingController(),
      account = TextEditingController(),
      username = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: FutureBuilder(
        future: DatabaseService().getUser(),
        builder: (BuildContext context, AsyncSnapshot snap) {
          if (snap.hasData) {
            name.text = snap.data.name;
            email.text = snap.data.email;
            username.text = snap.data.username;
            account.text = snap.data.account.toString();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextField(
                        controller: name,
                        // onChanged: (val) {
                        //   name.text = val;
                        // },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Name',
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                    ),
                    SizedBox(
                      width: 300,
                      child: Text(
                        'Account balance: ₹${account.text}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: username,
                    // onChanged: (val) {
                    //   username.text = val;
                    // },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Username',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: email,
                    // onChanged: (val) {
                    //   email.text = val;
                    // },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: _savedisabled
                              ? null
                              : () async {
                                  final em = email.text,
                                      nm = name.text,
                                      usr = username.text;
                                  final res =
                                      await DatabaseService().updateUser(
                                          context,
                                          UserModel(
                                            email: email.text,
                                            name: name.text,
                                            username: username.text,
                                          ));
                                  if (!res) {
                                    setState(() {
                                      email.text = em;
                                      name.text = nm;
                                      username.text = usr;
                                    });
                                  }
                                },
                          child: Text('Save')),
                      ElevatedButton(
                          onPressed: _canceldisabled
                              ? null
                              : () {
                                  setState(() {});
                                },
                          child: Text('Cancel')),
                    ],
                  ),
                )
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
