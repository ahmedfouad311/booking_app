// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/booked_data.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:booking_app/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class TimeListScreen extends StatefulWidget {
  BookingData bookingData;
  DateTime userDate;
  List deletedIndex = [];
  final List<UserBookingData> userBookingData;
  TimeListScreen({
    Key? key,
    required this.bookingData,
    required this.userDate,
    required this.userBookingData,
  }) : super(key: key);

  @override
  State<TimeListScreen> createState() => _TimeListScreenState();
}

class _TimeListScreenState extends State<TimeListScreen> {
  List filteredTimeRanges = [];
  @override
  void initState() {
    filteredTimeRanges = widget.bookingData.timeRange
        .where((timeRange) => widget.userBookingData
            .where((userBookingData) =>
                userBookingData.timeRange["start"] == timeRange["start"])
            .isEmpty)
        .toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${AppLocalizations.of(context)!.from}  ${filteredTimeRanges[index]['start'].toString()}:00  -  ${AppLocalizations.of(context)!.to} ${filteredTimeRanges[index]['end'].toString()}:00 ',
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                ElevatedButton(
                    onPressed: () {
                      addBooking(widget.bookingData, index);
                      setState(() {
                        widget.bookingData.timeRange.removeAt(index);
                      });
                    },
                   style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            MyThemeData.PRIMARY_COLOR),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    child: Text(
                      AppLocalizations.of(context)!.book,
                      style: const TextStyle(color: Colors.white),
                    )),
              ],
            ),
          );
        },
        itemCount: filteredTimeRanges.length,
      ),
    );
  }

  UserBookingData userData(BookingData bookingData, int index) {
    var user = FirebaseAuth.instance.currentUser;
    UserBookingData userBookingData = UserBookingData(
      id: bookingData.id,
      userId: user!.uid,
      stadium: bookingData.stadium,
      userDate: widget.userDate,
      timeRange: bookingData.timeRange[index],
    );
    log(widget.userDate.toString());
    return userBookingData;
  }

  void addBooking(BookingData bookingData, int index) {
    widget.deletedIndex.add(index);
    deleteBookingData(bookingData, widget.deletedIndex);
    log('deleted..... ' + widget.deletedIndex.toString());
    addUserBookingToFirebase(userData(bookingData, index)).then((value) async {
      setState(() {});
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(AppLocalizations.of(context)!.booking_added_successfully),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                      context, HomeScreen.ROUTE_NAME);
                },
                child: const Text('ok'),
              ),
            ],
          );
        },
      );
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

  String userFromFormatDate() {
    return DateFormat.yMMMEd().format(widget.userDate);
  }
}
