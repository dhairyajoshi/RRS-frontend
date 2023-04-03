// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/models/bookingModel.dart';

class Reservation extends StatelessWidget {
  const Reservation({Key? key}) : super(key: key);

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
              "All bookings",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
              child: FutureBuilder(
            initialData: [],
            future: DatabaseService().getBookings(),
            builder: (context, AsyncSnapshot snap) {
              if (snap.hasData) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: ListView.builder(
                      itemCount: snap.data.length,
                      itemBuilder: (context, index) {
                        return BookingCard(snap.data[index]);
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

class BookingCard extends StatefulWidget {
  BookingModel booking;
  DateTime dt, bdt;
  BookingCard(this.booking, {Key? key})
      : dt = DateTime.parse(booking.date),
        bdt = DateTime.parse(booking.bookdate);

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  TextStyle _style = TextStyle(fontSize: 20);

  bool cnl = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(25)),
      height: 210,
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.booking.train,
            style: _style,
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From: ${widget.booking.source}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('To: ${widget.booking.dest}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Passengers: ${widget.booking.passengers}',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              Text('Booking amount: ₹${widget.booking.amount}',
                  style: TextStyle(
                    fontSize: 20,
                  )),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Travel date: ${widget.booking.date}',
                style: TextStyle(fontSize: 15),
              ),
              Text('Booking date: ${widget.booking.bookdate}',
                  style: TextStyle(
                    fontSize: 15,
                  ))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.dt.compareTo(widget.bdt) > 0)
                OutlinedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext builderContext) {
                            return AlertDialog(
                              title: Text('Cancel Reservation?'),
                              content: Text(
                                  '₹${widget.booking.amount} will be refunded to your account'),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: Text('Confirm'),
                                  onPressed: () async {
                                    await DatabaseService().cancelBooking(
                                        context,
                                        widget.booking.id,
                                        widget.booking.trainid);

                                    Navigator.of(context).pop();
                                  },
                                ), 
                              ],
                            );
                          });
                      setState(() {});
                    },
                    child: Text('Cancel Reservation')),
            ],
          )
        ],
      ),
    );
  }
}
