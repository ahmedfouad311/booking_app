// ignore_for_file: constant_identifier_names, must_be_immutable

import 'package:booking_app/admin/drop_down_admin.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/login_register/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddBookingAdmin extends StatefulWidget {
  static const String ROUTE_NAME = 'Add Booking Admin';

  const AddBookingAdmin({Key? key}) : super(key: key);

  @override
  State<AddBookingAdmin> createState() => _AddBookingAdminState();
}

class _AddBookingAdminState extends State<AddBookingAdmin> {
  String stadium = '';

  String match = '';

  String initialDropDownValue = '9AM to 11AM';

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.add_booking_admin,
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
                  Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
                }),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.switch_to_user,
                      style: const TextStyle(
                        fontSize: 18
                      ),
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
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Container(
            color: Colors.white,
            margin: const EdgeInsets.all(35),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.add_new_booking_admin,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: AppLocalizations.of(context)!.match,
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!
                                .error_message_match;
                          }
                          return null;
                        },
                        onChanged: (text) {
                          match = text;
                        },
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        onChanged: (text) {
                          stadium = text;
                        },
                        decoration: InputDecoration(
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          labelText: AppLocalizations.of(context)!.stadium,
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return AppLocalizations.of(context)!
                                .error_message_stadium;
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                DropDownButtonAdmin(
                  onChanged: (value) {
                    setState(() {
                      initialDropDownValue = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                  onPressed: () {
                    addBooking();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Text(
                      AppLocalizations.of(context)!.add_booking_button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addBooking() {
    if (!formKey.currentState!.validate()) {
      return;
    }
    addBookingToFirestore(match, stadium, initialDropDownValue).then((value) {
      showMessage('Booking added Successfully', context);
    }).onError((error, stackTrace) {
      showMessage('Error adding booking', context);
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      showMessage('Cant connect to the server', context);
    });
  }
}
