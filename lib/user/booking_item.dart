// ignore_for_file: must_be_immutable


import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/common/datetime_handler.dart';
import 'package:booking_app/data/booked_data.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:booking_app/user/time_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class BookingItem extends StatefulWidget {
  BookingData bookingData;
  late BookedData bookedData;
  DateTime userDate;
  String initialDropDownValueHours = '';
  int selectedIndex = 0;
  final List<UserBookingData> userBookingData;
  BookingItem(this.bookingData, {Key? key, required this.userBookingData, required this.userDate})
      : super(key: key);

  @override
  State<BookingItem> createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
  List<String> generatedList = [];
  @override
  Future<void> didChangeDependencies() async {
    // generatedList = await generateLists(widget.bookingData);
    setState(() {});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(20),
        color: MyThemeData.PRIMARY_COLOR,
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
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                  onPressed: () {
                    showDateDialog();
                    setState(() {});
                  },
                  child: Text(
                    userFromFormatDate(),
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                        color: MyThemeData.PRIMARY_COLOR, fontSize: 18),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      checkRange();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.white),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    child: Text(
                      AppLocalizations.of(context)!.book,
                      style: const TextStyle(color: MyThemeData.PRIMARY_COLOR),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void checkRange() {
    if (widget.userDate
        .isBetween(widget.bookingData.fromDate, widget.bookingData.toDate)) {
      // addBooking(widget.bookingData);
      Navigator.pushNamed(context, TimeBookScreen.ROUTE_NAME,
          arguments: BookingItem(
            widget.bookingData,
            userBookingData: widget.userBookingData,
            userDate: widget.userDate,
          ));
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
}
