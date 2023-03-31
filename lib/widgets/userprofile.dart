// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_final_fields
import 'package:flutter/material.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/models/userModel.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
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
                    SizedBox(width: 200,),
                    SizedBox(
                      width: 300,
                      child: Text('Account balance: ₹${account.text}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),), 
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
                                  final res = await DatabaseService()
                                      .updateUser(
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
