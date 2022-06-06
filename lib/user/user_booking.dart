// ignore_for_file: constant_identifier_names

import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/user/booking_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserBooking extends StatelessWidget {
  static const String ROUTE_NAME = 'User Booking Screen';
  const UserBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.user_booking),
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
}
