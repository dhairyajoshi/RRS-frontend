import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:railway_system/models/userModel.dart';

import '../../database/database_services.dart';

class UserList extends StatelessWidget {
  const UserList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              "All Users",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: FutureBuilder(
            initialData: [],
            future: DatabaseService().getAllUsers(),
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        return UserCard(snap.data[index]);
                      }),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ))
        ],
      ),
    );
  }
}

class UserCard extends StatelessWidget {
  UserCard(this.user, {Key? key}) : super(key: key);
  UserModel user;
  TextStyle _style = TextStyle(fontSize: 20);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(vertical: 15,horizontal: 20),  
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25) 
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('Name: ${user.name}',style: _style,),
          SizedBox(height: 5,),
          Text('Username: ${user.username}',style: _style,),
          SizedBox(height: 5,),
          Text('E-mail address: ${user.email}',style: _style,), 
          SizedBox(height: 5,)
        ],
      ),
    );
  }
}
