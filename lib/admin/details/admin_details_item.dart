import 'package:booking_app/data/user_booking_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdminDetailsItem extends StatelessWidget {
  UserBookingData userBookingData;
  AdminDetailsItem({Key? key, required this.userBookingData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        children: [
          Text(
            userBookingData.stadium
          ),
          Row(
            children: [
              Text(userFromFormatDate()),
              Text('from: ${userBookingData.timeRange['start']} to: ${userBookingData.timeRange['end']}'),
            ],
          ),
        ],
      );
  }

  String userFromFormatDate() {
    return DateFormat.yMMMEd().format(userBookingData.userDate);
  }
}
