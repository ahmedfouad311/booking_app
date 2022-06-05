// ignore_for_file: must_be_immutable

import 'package:booking_app/data/booking_data.dart';
import 'package:flutter/material.dart';

class AdminBookingItem extends StatelessWidget {
  BookingData bookingData;
  AdminBookingItem({Key? key, required this.bookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                bookingData.date.toString(),
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
