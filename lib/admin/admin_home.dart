// ignore_for_file: constant_identifier_names

import 'package:booking_app/admin/add_booking_admin.dart';
import 'package:booking_app/admin/admin_booking_item.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/login_register/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdminHome extends StatefulWidget {
  static const String ROUTE_NAME = 'Amin Home';
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Home',
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              padding: const EdgeInsets.symmetric(vertical: 35),
              width: double.infinity,
              child: Text(
                AppLocalizations.of(context)!.app_title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: (() {
                  Navigator.pushReplacementNamed(
                      context, LoginScreen.ROUTE_NAME);
                }),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.switch_to_user,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.person)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot<BookingData>>(
          // for real time changes stream more efficient than future builder
          stream: getBookingCollectionWithConverter().snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData == false) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<BookingData> items =
                  snapshot.data!.docs.map((e) => e.data()).toList();
              return ListView.builder(
                itemBuilder: (context, index) {
                  return AdminBookingItem(
                    bookingData: items[index],
                  );
                },
                itemCount: items.length,
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, AddBookingAdmin.ROUTE_NAME);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
