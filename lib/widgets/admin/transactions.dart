import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:railway_system/database/database_services.dart';
import 'package:railway_system/models/bookingModel.dart';

class Transactions extends StatelessWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              "All Transactions", 
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
              child: FutureBuilder(
            initialData: [],
            future: DatabaseService().getAllBookings(),
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
              return const Center(
                child: const CircularProgressIndicator(),
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
  TextStyle _style = const TextStyle(fontSize: 20);

  bool cnl = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 35),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(25)),
      height: 260, 
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.booking.train,
            style: _style,
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            'Booking id:${widget.booking.id}', 
            style: _style,
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'From: ${widget.booking.source}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text('To: ${widget.booking.dest}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Passengers: ${widget.booking.passengers}',
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text('Booking amount: ₹${widget.booking.amount}',
                  style: const TextStyle(
                    fontSize: 20,
                  )),
            ],
          ), 
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Travel date: ${widget.booking.date}',
                style: const TextStyle(fontSize: 15),
              ),
              Text('Booking date: ${widget.booking.bookdate}',
                  style: const TextStyle(
                    fontSize: 15,
                  ))
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}