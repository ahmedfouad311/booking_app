// ignore_for_file: constant_identifier_names, must_be_immutable

import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/user/booking_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserBooking extends StatefulWidget {
  static const String ROUTE_NAME = 'User Booking Screen';

  late BookingData bookingData;
  late DateTime userDate = DateTime.now();
  UserBooking({
    Key? key,
  }) : super(key: key);

  @override
  State<UserBooking> createState() => _UserBookingState();
}

class _UserBookingState extends State<UserBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.user_booking),
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.edit_calendar,
        //       color: Colors.white,
        //     ),
        //     onPressed: () {
        //       showDateDialog();
        //     },
        //   )
        // ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot<BookingData>>(
          // for real time changes stream more efficient than future builder
          stream: getBookingCollectionWithConverter().snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData == false) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<BookingData> items =
                  snapshot.data!.docs.map((e) => e.data()).toList();
              return ListView.builder(
                itemBuilder: (context, index) {
                  return BookingItem(items[index]);
                },
                itemCount: items.length,
              );
            }
          },
        ),
      ),
    );
  }

  void showDateDialog() async {
    var newSelectedDate = await showDatePicker(
      context: context,
      initialDate: widget.userDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newSelectedDate != null) {
      widget.userDate = newSelectedDate;
      setState(() {});
    }
  }
}
