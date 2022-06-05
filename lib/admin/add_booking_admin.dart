// ignore_for_file: constant_identifier_names, must_be_immutable

import 'package:booking_app/admin/drop_down_admin.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:time_range/time_range.dart';

class AddBookingAdmin extends StatefulWidget {
  static const String ROUTE_NAME = 'Add Booking Admin';

  const AddBookingAdmin({Key? key}) : super(key: key);

  @override
  State<AddBookingAdmin> createState() => _AddBookingAdminState();
}

class _AddBookingAdminState extends State<AddBookingAdmin> {
  String initialDropDownValue = 'Cairo International Stadium';
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.add_booking_admin,
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
                DropDownButtonAdmin(
                  onChanged: (value) {
                    setState(() {
                      initialDropDownValue = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        showDateDialog();
                      },
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showTimeDialog();
                      },
                      child: Text(
                        "${selectedTime.hour}:${selectedTime.minute}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
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
    addBookingToFirestore(
      initialDropDownValue,
      selectedDate,
    ).then((value) {
      showMessage('Booking added Successfully', context);
    }).onError((error, stackTrace) {
      showMessage('Error adding booking', context);
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      showMessage('Cant connect to the server', context);
    });
  }

  void showDateDialog() async {
    var newSelectedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newSelectedDate != null) {
      selectedDate = newSelectedDate;
      setState(() {});
    }
  }

  void showTimeDialog() async {
    var newSelectedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
      confirmText: 'Confirm',
      cancelText: 'Cancel',
      helpText: 'Booking Time',
    );
    if (newSelectedTime != null && newSelectedTime != selectedTime) {
      setState(() {
        selectedTime = newSelectedTime;
      });
    }
  }

  void showTimeRange() {
    var newSelectedTime = TimeRange(
      fromTitle: Text(
        'From',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      toTitle: Text(
        'To',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      titlePadding: 20,
      textStyle:
          TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
      activeTextStyle:
          TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      borderColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.transparent,
      activeBackgroundColor: Colors.white,
      firstTime: TimeOfDay(hour: 14, minute: 30),
      lastTime: TimeOfDay(hour: 20, minute: 00),
      timeStep: 10,
      timeBlock: 30,
      onRangeCompleted: (range) => setState(() => print(range)),
    );
  }
}
