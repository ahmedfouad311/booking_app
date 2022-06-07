// ignore_for_file: must_be_immutable

import 'package:booking_app/admin/admin_booking_details.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminBookingItem extends StatelessWidget {
  BookingData bookingData;
  AdminBookingItem({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, AdminBookingDetails.ROUTE_NAME);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          color: Theme.of(context).primaryColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookingData.stadium,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.from + fromFormatDate(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white, fontSize: 20),
              ),
              Text(
                AppLocalizations.of(context)!.to + toFormatDate(),
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: Colors.white, fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String fromFormatDate() {
    return DateFormat.yMMMEd().format(bookingData.fromDate);
  }

  String toFormatDate() {
    return DateFormat.yMMMEd().format(bookingData.toDate);
  }
}
