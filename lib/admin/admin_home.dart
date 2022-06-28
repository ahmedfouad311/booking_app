// ignore_for_file: constant_identifier_names

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/admin/add_booking_admin.dart';
import 'package:booking_app/admin/admin_booking_item.dart';
import 'package:booking_app/admin/details/admin_details_screen.dart';
import 'package:booking_app/common/selected_unselected_items/selected_item.dart';
import 'package:booking_app/common/selected_unselected_items/unselected_item.dart';
import 'package:booking_app/data/booking_data.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/provider/app_provider.dart';
import 'package:booking_app/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AdminHome extends StatefulWidget {
  static const String ROUTE_NAME = 'Amin Home';
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    AppProvider languageProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyThemeData.PRIMARY_COLOR,
        title: Text(
          AppLocalizations.of(context)!.admin_home,
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: MyThemeData.PRIMARY_COLOR,
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
                  onTap: () {
                    languageProvider.changeLanguage('en');
                  },
                  child: languageProvider.defaultLanguage == 'en'
                      ? SelectedItem(
                          text: AppLocalizations.of(context)!.language_english)
                      : UnselectedItem(
                          text: AppLocalizations.of(context)!.language_english,
                        )),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                  onTap: () {
                    languageProvider.changeLanguage('ar');
                  },
                  child: languageProvider.defaultLanguage == 'ar'
                      ? SelectedItem(
                          text: AppLocalizations.of(context)!.language_arabic)
                      : UnselectedItem(
                          text: AppLocalizations.of(context)!.language_arabic)),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: (() {
                  Navigator.pushNamed(context, AdminDetailsScreen.ROUTE_NAME);
                }),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.show_all_bookings,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.book_outlined)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: InkWell(
                onTap: (() {
                  logout();
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
        backgroundColor: MyThemeData.PRIMARY_COLOR,
        onPressed: () {
          Navigator.pushNamed(context, AddBookingAdmin.ROUTE_NAME);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void logout() {
    Navigator.pushReplacementNamed(context, WelcomeScreen.ROUTE_NAME);
    FirebaseAuth.instance.signOut();
  }
}
