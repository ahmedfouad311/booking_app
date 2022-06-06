// ignore_for_file: must_be_immutable

import 'package:booking_app/data/user_booking_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeBookingItem extends StatefulWidget {
  UserBookingData userBookingData;
  HomeBookingItem(this.userBookingData, {Key? key}) : super(key: key);

  @override
  State<HomeBookingItem> createState() => _HomeBookingItemState();
}

class _HomeBookingItemState extends State<HomeBookingItem> {
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
              widget.userBookingData.stadium,
              style: Theme.of(context)
                  .textTheme
                  .headline4!
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
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
          ],
        ),
      ),
    );
  }

  String fromFormatDate() {
    return DateFormat.yMMMEd().format(widget.userBookingData.userFromDate);
  }

  String toFormatDate() {
    return DateFormat.yMMMEd().format(widget.userBookingData.userToDate);
  }
}
