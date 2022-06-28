// ignore_for_file: must_be_immutable

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminDetailsItem extends StatelessWidget {
  UserBookingData userBookingData;
  AdminDetailsItem({Key? key, required this.userBookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
      child: Container(
        padding: const EdgeInsets.all(15),
        color: MyThemeData.PRIMARY_COLOR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userBookingData.stadium,
                textAlign: TextAlign.start,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(userFromFormatDate(), style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),),
              const SizedBox(
                height: 5,
              ),
              Text('${AppLocalizations.of(context)!.from} ${userBookingData.timeRange['start']}:00  -  ${AppLocalizations.of(context)!.to} ${userBookingData.timeRange['end']}:00',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold
                ),),
            ],
          ),
      ),
    );
  }

  String userFromFormatDate() {
    return DateFormat.yMMMEd().format(userBookingData.userDate);
  }
}
