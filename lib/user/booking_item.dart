// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:booking_app/admin/drop_down_admin.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/common/datetime_handler.dart';
import 'package:booking_app/data/booked_data.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BookingItem extends StatefulWidget {
  BookingData bookingData;
  DateTime userDate = DateTime.now();
  String initialDropDownValueHours = '';

  static List<String> oneHour = [
    '12 Pm - 1 Pm',
    '2 Pm - 3 Pm',
    '4 Pm - 5 Pm',
    '6 Pm - 7 Pm',
    '8 Pm - 9 Pm',
    '10 Pm - 11 Pm',
    '12 Am - 1 Am',
  ];
  static List<String> twoHour = [
    '12 Pm - 2 Pm',
    '3 Pm - 5 Pm',
    '6 Pm - 8 Pm',
    '9 Pm - 11 Pm',
  ];
  static List<String> threeHour = [
    '12 Pm - 3 Pm',
    '4 Pm - 7 Pm',
    '8 Pm - 11 Pm',
  ];
  static List<String> fourHour = [
    '12 Pm - 4 Pm',
    '5 Pm - 9 Pm',
    '9 Pm - 1 Am',
  ];
  BookingItem(this.bookingData, {Key? key}) : super(key: key);

  @override
  State<BookingItem> createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
  List<String> generatedList = [];
  @override
  Future<void> didChangeDependencies() async {
    generatedList = await generateLists(widget.bookingData);
    setState(() {});
    super.didChangeDependencies();
  }

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
            const SizedBox(
              height: 5,
            ),
            Text(
              '${AppLocalizations.of(context)!.from} ${fromFormatDate()}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              '${AppLocalizations.of(context)!.to} ${toFormatDate()}',
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white, fontSize: 18),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    showDateDialog();
                    setState(() {});
                  },
                  child: Text(
                    userFromFormatDate(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      checkRange();
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
            DropDownButtonAdmin(
              onChanged: (value) {
                setState(() {
                  widget.initialDropDownValueHours = value!;
                  log("selected item:$value");
                });
              },
              dropDownList: generatedList,
            )
          ],
        ),
      ),
    );
  }

  // Data Handling
  UserBookingData userData(BookingData bookingData) {
    var user = FirebaseAuth.instance.currentUser;
    UserBookingData userBookingData = UserBookingData(
      id: bookingData.id,
      userId: user!.uid,
      stadium: bookingData.stadium,
      userDate: widget.userDate,
      bookRange: widget.initialDropDownValueHours,
    );
    return userBookingData;
  }

  void addBooking(BookingData bookingData) {
    dynamic value = widget.initialDropDownValueHours;
    addBookedData(BookedData(id: '1', bookedList: getList(value)));
    addUserBookingToFirebase(userData(bookingData)).then((value) async {
      generatedList = await generateLists(bookingData);
      setState(() {});
      showMessage(
          AppLocalizations.of(context)!.booking_added_successfully, context);
    }).onError((error, stackTrace) {
      showMessage(AppLocalizations.of(context)!.error_adding_booking, context);
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      showMessage(
          AppLocalizations.of(context)!.cant_connect_to_the_server, context);
    });
  }

  addBookedData(BookedData bookedData) {
    addBookedDataToFirebase(bookedData, widget.userDate).then((value) {
      showMessage('List Created', context);
    }).onError((error, stackTrace) {
      showMessage('Error creating list', context);
    });
  }

  List<dynamic> getList(dynamic item) {
    List<dynamic> bookedList = [];
    bookedList.add(item);
    return bookedList;
  }

  // constants
  void checkRange() {
    if (widget.userDate
        .isBetween(widget.bookingData.fromDate, widget.bookingData.toDate)) {
      addBooking(widget.bookingData);
    } else {
      showMessage(
          AppLocalizations.of(context)!.this_day_is_not_available, context);
    }
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

  String fromFormatDate() {
    return DateFormat.yMMMEd().format(widget.bookingData.fromDate);
  }

  String toFormatDate() {
    return DateFormat.yMMMEd().format(widget.bookingData.toDate);
  }

  String userFromFormatDate() {
    return DateFormat.yMMMEd().format(widget.userDate);
  }

  void initLists() {
    BookingItem.oneHour = [
      '12 Pm - 1 Pm',
      '2 Pm - 3 Pm',
      '4 Pm - 5 Pm',
      '6 Pm - 7 Pm',
      '8 Pm - 9 Pm',
      '10 Pm - 11 Pm',
      '12 Am - 1 Am',
    ];
    BookingItem.twoHour = [
      '12 Pm - 2 Pm',
      '3 Pm - 5 Pm',
      '6 Pm - 8 Pm',
      '9 Pm - 11 Pm',
    ];
    BookingItem.threeHour = [
      '12 Pm - 3 Pm',
      '4 Pm - 7 Pm',
      '8 Pm - 11 Pm',
    ];
    BookingItem.fourHour = [
      '12 Pm - 4 Pm',
      '5 Pm - 9 Pm',
      '9 Pm - 1 Am',
    ];
  }

  Future<List<String>> generateLists(BookingData bookingData) async {
    // initLists();
    if (bookingData.hours == "1 Hours") {
      await getBookedDataFromFirebase(BookingItem.oneHour, widget.userDate);
      return BookingItem.oneHour;
    } else if (bookingData.hours == "2 Hours") {
      await getBookedDataFromFirebase(BookingItem.twoHour, widget.userDate);
      return BookingItem.twoHour;
    } else if (bookingData.hours == "3 Hours") {
      await getBookedDataFromFirebase(BookingItem.threeHour, widget.userDate);
      return BookingItem.threeHour;
    } else {
      await getBookedDataFromFirebase(BookingItem.fourHour, widget.userDate);
      return BookingItem.fourHour;
    }
  }
}
