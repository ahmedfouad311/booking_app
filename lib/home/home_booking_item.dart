import 'package:booking_app/data/user_booking_data.dart';
import 'package:flutter/material.dart';

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
