// ignore_for_file: constant_identifier_names, must_be_immutable

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:booking_app/user/booking_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserBooking extends StatefulWidget {
  static const String ROUTE_NAME = 'User Booking Screen';
  final List<UserBookingData> userBookingData;
  const UserBooking({
    Key? key, required this.userBookingData,
  }) : super(key: key);

  @override
  State<UserBooking> createState() => _UserBookingState();
}

class _UserBookingState extends State<UserBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThemeData.PRIMARY_COLOR,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.user_booking),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot<BookingData>>(
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
                  return BookingItem(items[index], userBookingData: widget.userBookingData,userDate: DateTime.now(),);
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
