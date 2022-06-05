// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';

class AdminBookingDetails extends StatelessWidget {
  static const String ROUTE_NAME = 'Admin Booking Details';
  const AdminBookingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Booking Details',
        ),
      ),
      body: Container(),
    );
  }
}
