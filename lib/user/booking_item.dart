// ignore_for_file: must_be_immutable

import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BookingItem extends StatefulWidget {
  BookingData bookingData;
  DateTime userStartDate = DateTime.now();
  DateTime userEndDate = DateTime.now().add(const Duration(days: 7));
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
        child: Column(
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
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.available_date,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.from + fromFormatDate(),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      AppLocalizations.of(context)!.to + toFormatDate(),
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
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
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              AppLocalizations.of(context)!.booked_date,
              style: Theme.of(context).textTheme.subtitle1!.copyWith(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            InkWell(
              onTap: () {
                showDateDialog();
              },
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(context)!.from + userFromFormatDate(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    AppLocalizations.of(context)!.to + userToFormatDate(),
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
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
        userFromDate: widget.userStartDate,
        userToDate: widget.userEndDate);
    return userBookingData;
  }

  void addBooking(BookingData bookingData) {
    addUserBookingToFirebase(userData(bookingData)).then((value) {
      showMessage(
          AppLocalizations.of(context)!.booking_added_successfully, context);
    }).onError((error, stackTrace) {
      showMessage(AppLocalizations.of(context)!.error_adding_booking, context);
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      showMessage(
          AppLocalizations.of(context)!.cant_connect_to_the_server, context);
    });
  }

  void showDateDialog() async {
    var newSelectedDate = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newSelectedDate != null) {
      widget.userStartDate = newSelectedDate.start;
      widget.userEndDate = newSelectedDate.end;

      setState(() {});
    }
  }

  String fromFormatDate() {
    return DateFormat.yMMMEd().format(widget.bookingData.fromDate);
  }

  String toFormatDate() {
    return DateFormat.yMMMEd().format(widget.bookingData.toDate);
  }

  String userFromFormatDate() {
    return DateFormat.yMMMEd().format(widget.userStartDate);
  }

  String userToFormatDate() {
    return DateFormat.yMMMEd().format(widget.userEndDate);
  }
}
