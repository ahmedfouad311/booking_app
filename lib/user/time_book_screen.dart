// ignore_for_file: must_be_immutable, constant_identifier_names


import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:booking_app/user/booking_item.dart';
import 'package:booking_app/user/time_list_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TimeBookScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Time Book Screen';

  const TimeBookScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeBookScreen> createState() => _TimeBookScreenState();
}

class _TimeBookScreenState extends State<TimeBookScreen> {
  List<UserBookingData> filteredUserBookingData = [];
  late BookingItem arguments;
  @override
  void didChangeDependencies() {
    arguments = ModalRoute.of(context)!.settings.arguments as BookingItem;
    filteredUserBookingData = arguments.userBookingData
        .where((element) => element.userDate == arguments.userDate)
        .toList();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThemeData.PRIMARY_COLOR,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.time_book_screen),
      ),
      body: StreamBuilder<QuerySnapshot<BookingData>>(
        stream: getBookingCollectionWithConverter()
            .where('id', isEqualTo: arguments.bookingData.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<BookingData> items =
                snapshot.data!.docs.map((e) => e.data()).toList();

            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                // log(items[index].timeRange[0].toString());
                return TimeListScreen(
                  bookingData: items[index],
                  userDate: arguments.userDate,
                  userBookingData: filteredUserBookingData,
                );
              },
              itemCount: items.length,
            );
          }
        },
      ),
    );
  }
}
