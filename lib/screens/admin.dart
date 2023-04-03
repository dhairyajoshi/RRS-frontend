import 'package:flutter/material.dart';
import 'package:railway_system/screens/login.dart';
import 'package:railway_system/widgets/admin/admin.dart';
import 'package:railway_system/widgets/admin/transactions.dart';
import 'package:railway_system/widgets/admin/userlist.dart';

import '../database/database_services.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextStyle _style = TextStyle(fontSize: 30);
  int cur_idx = 0; 

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
                    color: Color.fromARGB(255, 224, 234, 233),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() {
                            cur_idx = 0;
                          }),
                          child: Text(
                            'Admin Profile',
                            style: _style,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            cur_idx = 1;
                          }),
                          child: Text(
                            'All Users',
                            style: _style,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() {
                            cur_idx = 2;
                          }),
                          child: Text(
                            'All Transaction', 
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
                    color: Color.fromARGB(255, 185, 209, 229),
                    // color: cur_idx == 0
                    //     ? Color.fromARGB(255, 118, 89, 0)
                    //     : (cur_idx == 1
                    //         ? Color.fromARGB(255, 27, 114, 1)
                    //         : (cur_idx == 2 ? Colors.green : Colors.yellow)),
                    child: cur_idx == 0
                        ? AdminProfile()
                        : (cur_idx == 1 ? UserList() : Transactions()), 
                  ))
            ],
          )),
    );
  }
}
