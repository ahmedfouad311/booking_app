// ignore_for_file: constant_identifier_names

import 'package:booking_app/common/selected_unselected_items/selected_item.dart';
import 'package:booking_app/common/selected_unselected_items/unselected_item.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_booking_data.dart';
import 'package:booking_app/home/home_booking_item.dart';
import 'package:booking_app/login_register/login_screen.dart';
import 'package:booking_app/provider/app_provider.dart';
import 'package:booking_app/user/user_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Home Screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    AppProvider languageProvider = Provider.of<AppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.app_title,
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
                  logout();
                }),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.sign_out,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(Icons.logout)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: StreamBuilder<QuerySnapshot<UserBookingData>>(
          // for real time changes stream more efficient than future builder
          stream: getUserBookingCollectionWithConverter()
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else if (snapshot.hasData == false) {
              return const Center(child: CircularProgressIndicator());
            } else {
              List<UserBookingData> items =
                  snapshot.data!.docs.map((e) => e.data()).toList();
              return ListView.builder(
                itemBuilder: (context, index) {
                  return HomeBookingItem(items[index]);
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
          Navigator.pushNamed(context, UserBooking.ROUTE_NAME);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }

  void logout() {
    Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
    FirebaseAuth.instance.signOut();
  }
}
