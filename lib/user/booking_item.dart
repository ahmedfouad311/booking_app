// ignore_for_file: must_be_immutable

import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BookingItem extends StatefulWidget {
  BookingData bookingData;
  BookingItem(this.bookingData, {Key? key}) : super(key: key);

  @override
  State<BookingItem> createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.bookingData.stadium,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      addBooking(widget.bookingData);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.book,
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  UserBookingData userData(BookingData bookingData) {
    var user = FirebaseAuth.instance.currentUser;
    UserBookingData userBookingData = UserBookingData(
      id: bookingData.id,
      userId: user!.uid,
      stadium: bookingData.stadium,
    );
    return userBookingData;
  }

  void addBooking(BookingData bookingData) {
    addUserBookingToFirebase(userData(bookingData)).then((value) {
      showMessage('Booking added Successfully', context);
    }).onError((error, stackTrace) {
      showMessage('Error adding booking', context);
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      showMessage('Cant connect to the server', context);
    });
  }
}
