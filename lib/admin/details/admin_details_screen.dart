// ignore_for_file: constant_identifier_names

import 'package:booking_app/admin/details/admin_details_item.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminDetailsScreen extends StatelessWidget {
  static const String ROUTE_NAME = 'Admin Detalis Screen';
  const AdminDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Detalis Screen'),
      ),
      body: StreamBuilder<QuerySnapshot<UserBookingData>>(
        stream: getUserBookingCollectionWithConverter().snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData == false) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<UserBookingData> items =
                snapshot.data!.docs.map((e) => e.data()).toList();

            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return AdminDetailsItem(userBookingData: items[index],);
              },
              itemCount: items.length,
            );
          }
        },
      ),
    );
  }
}
