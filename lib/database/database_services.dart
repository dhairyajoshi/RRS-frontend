// ignore_for_file: prefer_const_constructors,

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:railway_system/models/bookingModel.dart';
import 'package:railway_system/models/trainModel.dart';
import 'package:railway_system/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {
  final baseUrl = "https://railway-reservation-system-nf2h.onrender.com/"; 
  // final baseUrl = "http://localhost:3000/";   
  Future<bool> userLogin(
      BuildContext context, String uname, String pass) async {
    final response = await http.post(Uri.parse('${baseUrl}user/login'),
        body: {'username': uname, 'password': pass});
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      if (data['msg'] != 'logged in successfully') return false;
      final token = data['token'];
      final pref = await SharedPreferences.getInstance();
      await pref.setString('token', token);
      return true;
    }
    Timer _timer = Timer(Duration(seconds: 5), () {});
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });

          return AlertDialog(content: Text(data['msg']));
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
    return false;
  }

  void userLogout() async {
    final pref = await SharedPreferences.getInstance();
    await pref.remove('token');
  }

  Future<bool> userSignUp(
      BuildContext context, UserModel user, String pass) async {
    final jsonBody = user.toJson();
    jsonBody['password'] = pass;
    final response =
        await http.post(Uri.parse('${baseUrl}user/signup'), body: jsonBody);
    final data = json.decode(response.body);
    if (response.statusCode == 201) {
      if (data['msg'] != 'user created successfully') return false;
      final token = data['token'];
      final pref = await SharedPreferences.getInstance();
      await pref.setString('token', token);
      return true;
    }
    Timer _timer = Timer(Duration(seconds: 5), () {});
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(content: Text(data['msg']));
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
    return false;
  }

  Future<UserModel?> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('${baseUrl}user/info'),
        headers: {'Authorization': 'Bearer $token'});
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    }

    return null;
  }

  Future<List<UserModel>> getAllUsers() async {
    List<UserModel> list = [];
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse('${baseUrl}user/all'),
        headers: {'Authorization': 'Bearer $token'});
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      for(int i=0;i<data.length;i++){
        list.add(UserModel.fromJson(data[i]));
      }
    }
  
    return list;
  }

  Future<bool> updateUser(BuildContext context, UserModel user) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.post(Uri.parse('${baseUrl}user/update'),
        headers: {'Authorization': 'Bearer $token'}, body: user.toJson());
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      Timer _timer = Timer(Duration(seconds: 5), () {});
      showDialog(
          context: context,
          builder: (BuildContext builderContext) {
            _timer = Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
            return AlertDialog(content: Text(data['msg']));
          }).then((val) {
        if (_timer.isActive) {
          _timer.cancel();
        }
      });
      return true;
    }
    Timer _timer = Timer(Duration(seconds: 5), () {});
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(content: Text(data['msg']));
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
    return false;
  }

  Future<List<TrainModel>> getTrains(
      String source, String dest, String date) async {
    List<TrainModel> trainList = <TrainModel>[];

    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(
        Uri.parse('${baseUrl}train/getall?s=$source&d=${dest}&dt=${date}'),
        headers: {'Authorization': 'Bearer $token'});
    final data = json.decode(response.body);

    if (response.statusCode == 200) {
      for (int i = 0; i < data.length; i++) {
        trainList.add(TrainModel.fromJson(data[i]));
      }
    }
    return trainList;
  }

  Future<bool> bookTicket(
      BuildContext context, TrainModel train, int no) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.post(
        Uri.parse(
            '${baseUrl}train/book?tn=${train.number}&dt=${train.date}&no=${no}'),
        headers: {'Authorization': 'Bearer $token'});
    final data = json.decode(response.body);
    if (response.statusCode == 200) {
      Timer _timer = Timer(Duration(seconds: 5), () {});
      showDialog(
          context: context,
          builder: (BuildContext builderContext) {
            _timer = Timer(Duration(seconds: 3), () {
              Navigator.of(context).pop();
            });
            return AlertDialog(content: Text('Booking confirmed'));
          }).then((val) {
        if (_timer.isActive) {
          _timer.cancel();
        }
      });
      return true;
    }
    Timer _timer = Timer(Duration(seconds: 5), () {});
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(content: Text(data['msg']));
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    });
    return false;
  }

  Future<List<BookingModel>> getBookings() async {
    List<BookingModel> bookings = <BookingModel>[];
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.get(Uri.parse(baseUrl + 'book'),
        headers: {'Authorization': 'Bearer $token'});

    // print(response.body);
    final data = json.decode(response.body);

    for (int i = 0; i < data.length; i++) {
      bookings.add(BookingModel.fromJson(data[i]));
    }

    return bookings;
  }

  Future<bool> cancelBooking(BuildContext context, String id,String tid) async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString('token');
    final response = await http.post(Uri.parse(baseUrl + 'book?id=${id}&tid=${tid}'), 
        headers: {'Authorization': 'Bearer $token'},body: {}); 
    // print(response.body); 
    // final data = json.decode(response.body);
    if (response.statusCode == 204) {
      return true;
    } 
    Timer _timer = Timer(Duration(seconds: 5), () {});
    showDialog(
        context: context,
        builder: (BuildContext builderContext) {
          _timer = Timer(Duration(seconds: 3), () {
            Navigator.of(context).pop();
          });
          return AlertDialog(content: Text('Couldn\'t cancel booking'));
        }).then((val) {
      if (_timer.isActive) {
        _timer.cancel(); 
      }
    });
    return false;
  }
}
