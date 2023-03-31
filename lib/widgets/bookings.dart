// ignore_for_file: prefer_const_constructors, must_be_immutable, avoid_unnecessary_containers, sized_box_for_whitespace
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/models/trainModel.dart';
import 'package:railway_system/widgets/state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class bookings extends StatefulWidget {
  bookings({Key? key}) : super(key: key);
  String sc = '', dst = '';

  @override
  State<bookings> createState() => _bookingsState();
}

class _bookingsState extends State<bookings> {
  late String _dateCount;
  late String _range;

  String date = 'Select Date';
  @override
  void initState() {
    _dateCount = '';
    _range = '';

    super.initState();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} - ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    BookState state = BookState();
    TextEditingController src = TextEditingController(),
        dest = TextEditingController(),
        dt = TextEditingController();
    src.text = state.src;
    dest.text = state.dst;
    date = state.dt;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: src,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Source Station',
                  ),
                ),
              ),
              SizedBox(
                width: 100,
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: dest,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Destination Station',
                  ),
                ),
              ),
              SizedBox(
                width: 100,
              ),
              SizedBox(
                width: 200,
                child: GestureDetector(
                  onTap: () async {
                    DateTime? picked = await showDatePicker(
                        context: context,
                        textDirection: ui.TextDirection.ltr,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2024));

                    if (picked != null) {
                      setState(() {
                        date = picked.toString().split(' ')[0];
                        state.src = src.text;
                        state.dst = dest.text;
                        state.dt = date;
                      });
                    }
                  },
                  child: Row(
                    children: [
                      Text(
                        date,
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(Icons.calendar_month)
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          state.src = src.text;
                          state.dst = dest.text;
                          state.dt = date;
                        });
                      },
                      child: Text('Search')))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
                initialData: [],
                future: state.src == ''
                    ? null
                    : DatabaseService().getTrains(
                        state.src.trim().toLowerCase(), state.dst.trim().toLowerCase(), state.dt),
                builder: (BuildContext context, AsyncSnapshot snap) {
                  if (snap.hasData) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: ListView.builder(
                          itemCount: snap.data.length,
                          itemBuilder: (context, index) {
                            return TrainCard(snap.data[index]);
                          }),
                    );
                  }
                  return Container(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }),
          )
        ],
      ),
    );
  }
}

class TrainCard extends StatefulWidget {
  TrainCard(this.train, {Key? key}) : super(key: key);
  TrainModel train;

  @override
  State<TrainCard> createState() => _TrainCardState();
}

class _TrainCardState extends State<TrainCard> {
  final tkcounter = TextEditingController();

  bool cnf = false;

  BookState state = BookState();

  final _style = TextStyle(fontSize: 20);

  final _tstyle = TextStyle(fontSize: 25, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    tkcounter.text='1'; 
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(25)),
      height: 200,
      width: 300,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Train No.${widget.train.number}',
                style: _style,
              ),
              Text(
                widget.train.name,
                style: _style,
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.train.source.capitalize(),
                style: _tstyle,
              ),
              Text(
                'Date: ${widget.train.date}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                widget.train.destination.capitalize(), 
                style: _tstyle,
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Departure: ${widget.train.sdt}',
                style: _style,
              ),
              Text(
                'Arrival: ${widget.train.dat}',
                style: _style,
              )
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tickets available: ${widget.train.tickets}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                width: 100,
                height: 35,
                child: OutlinedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext builderContext) {
                            return AlertDialog(
                              content: Row(
                                // crossAxisAlignment: CrossAxisAlignment.baseline
                                children: [
                                  Text('Enter no. of tickets: '),
                                  SizedBox(
                                    // height: 30,
                                    width: 20,
                                    child: TextField(
                                      controller: tkcounter,
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder()),
                                    ),
                                  )
                                ],
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    state.tikcount = 1;
                                    state.conf = false;
                                    tkcounter.text = '1';
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Confirm'),
                                  onPressed: () {
                                    state.tikcount = int.parse(tkcounter.text);

                                    state.conf = true;

                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                      // sleep(const Duration(seconds: 2));

                      if (state.conf) {
                        state.conf = false;
                        await showDialog(
                            context: context,
                            builder: (BuildContext builderContext) {
                              return AlertDialog(
                                content: Text('Confirm booking?'),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: Text(
                                        'Pay ${state.tikcount * widget.train.amount}'),
                                    onPressed: () {
                                      DatabaseService().bookTicket(context,
                                          widget.train, state.tikcount);
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                        tkcounter.text = '1';
                        state.tikcount = 1;
                      }
                    },
                    child: Text('Book ₹${widget.train.amount}')),
              )
            ],
          )
        ],
      ),
    );
  }
}

extension StringExtension on String {
    String capitalize() {
      return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
    }
}