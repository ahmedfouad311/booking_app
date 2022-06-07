// ignore_for_file: constant_identifier_names, must_be_immutable, unused_local_variable, avoid_print

import 'package:booking_app/admin/drop_down_admin.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddBookingAdmin extends StatefulWidget {
  static const String ROUTE_NAME = 'Add Booking Admin';

  const AddBookingAdmin({Key? key}) : super(key: key);

  @override
  State<AddBookingAdmin> createState() => _AddBookingAdminState();
}

class _AddBookingAdminState extends State<AddBookingAdmin> {
  String initialDropDownValue = 'Cairo International Stadium';
  String initialDropDownValueHours = '1 Hour';
  DateTime startSelectedDate = DateTime.now();
  DateTime endSelectedDate = DateTime.now().add(const Duration(days: 7));
  TimeOfDay startSelectedTime = TimeOfDay.now();
  TimeOfDay endSelectedTime =
      TimeOfDay(hour: TimeOfDay.now().hour + 3, minute: TimeOfDay.now().minute);

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
                  dropDownList: const [
                    'Cairo International Stadium',
                    'Borg El Arab Stadium',
                    'Suez Stadium',
                    'Mokhtar El Tetsh Stadium'
                  ],
                  onChanged: (value) {
                    setState(() {
                      initialDropDownValue = value!;
                    });
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                InkWell(
                  onTap: () {
                    showDateDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.from} ${startSelectedDate.day}/${startSelectedDate.month}/${startSelectedDate.year} - ',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.to} ${endSelectedDate.day}/${endSelectedDate.month}/${endSelectedDate.year}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    showTimeDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.from} ${startSelectedTime.hour}:${startSelectedTime.minute} - ",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      // Text(
                      //   "${AppLocalizations.of(context)!.to} ${endSelectedTime.hour}:${endSelectedTime.minute}",
                      //   textAlign: TextAlign.center,
                      //   style: const TextStyle(
                      //     fontSize: 16,
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DropDownButtonAdmin(
                  onChanged: (value) {
                    setState(() {
                      initialDropDownValueHours = value!;
                    });
                  },
                  dropDownList: const [
                    '1 Hours',
                    '2 Hours',
                    '3 Hours',
                    '4 Hours',
                  ],
                ),
                const SizedBox(
                  height: 30,
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
    addBookingToFirestore(initialDropDownValue, startSelectedDate,
            endSelectedDate, initialDropDownValueHours)
        .then((value) {
      // print('Timeeeeeeeee ${Timestamp.fromDate(startSelectedDate).toDate()}');
      // print('Timeeeeeeeee2 ${Timestamp.fromDate(endSelectedDate).toDate()}');
      showMessage(
          AppLocalizations.of(context)!.booking_added_successfully, context);
    }).onError((error, stackTrace) {
      showMessage(AppLocalizations.of(context)!.error_adding_booking, context);
    }).timeout(const Duration(seconds: 10), onTimeout: () {
      showMessage(
          AppLocalizations.of(context)!.cant_connect_to_the_server, context);
    });
  }

  void showDateDialog() async {
    var newSelectedDate = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(const Duration(days: 7))),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (newSelectedDate != null) {
      startSelectedDate = newSelectedDate.start;
      endSelectedDate = newSelectedDate.end;

      setState(() {});
    }
  }

  void showTimeDialog() async {
    var newSelectedTime = await showTimeRangePicker(
      context: context,
      start: TimeOfDay.now(),
      onStartChange: (start) {
        print("start time " + start.toString());
        startSelectedTime = start;
        setState(() {});
      },
      onEndChange: (end) {
        print("end time " + end.toString());
        endSelectedTime = end;
        setState(() {});
      },
      interval: const Duration(hours: 1),
      minDuration: const Duration(hours: 1),
      use24HourFormat: false,
      padding: 30,
      strokeWidth: 20,
      handlerRadius: 14,
      strokeColor: Theme.of(context).primaryColor,
      handlerColor: Theme.of(context).primaryColor,
      selectedColor: Colors.white,
      backgroundColor: Colors.black.withOpacity(0.3),
      ticks: 12,
      ticksColor: Colors.white,
      snap: true,
      labels: ["6", "9", "12 ", "3 "].asMap().entries.map((e) {
        return ClockLabel.fromIndex(idx: e.key, length: 4, text: e.value);
      }).toList(),
      labelOffset: -30,
      labelStyle: const TextStyle(
          fontSize: 22, color: Colors.grey, fontWeight: FontWeight.bold),
      timeTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
      activeTimeTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 26,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold),
    );
  }
}
