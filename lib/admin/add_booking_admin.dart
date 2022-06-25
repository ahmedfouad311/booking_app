// ignore_for_file: constant_identifier_names, must_be_immutable, unused_local_variable, avoid_print

import 'dart:developer';

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/admin/drop_down_admin.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddBookingAdmin extends StatefulWidget {
  static const String ROUTE_NAME = 'Add Booking Admin';
  late List<int> timeList = [1, 2, 3, 4];

  AddBookingAdmin({Key? key}) : super(key: key);

  @override
  State<AddBookingAdmin> createState() => _AddBookingAdminState();
}

class _AddBookingAdminState extends State<AddBookingAdmin> {
  String initialDropDownValue = 'Cairo International Stadium';
  int initialDropDownValueHours = 1;
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
        backgroundColor: MyThemeData.PRIMARY_COLOR,
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
                      Text(
                        "${AppLocalizations.of(context)!.to} ${endSelectedTime.hour}:${endSelectedTime.minute}",
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
                  height: 20,
                ),
                DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: MyThemeData.PRIMARY_COLOR, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: MyThemeData.PRIMARY_COLOR, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: MyThemeData.PRIMARY_COLOR, width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  dropdownColor: Colors.white,
                  value: initialDropDownValueHours == 0
                      ? null
                      : initialDropDownValueHours,
                  // value: null,
                  icon: const Icon(
                    Icons.arrow_downward,
                    color: MyThemeData.PRIMARY_COLOR,
                  ),
                  elevation: 16,
                  style: const TextStyle(
                      color: MyThemeData.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    initialDropDownValueHours = value!;
                  },
                  items:
                      widget.timeList.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(MyThemeData.PRIMARY_COLOR),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
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
            endSelectedDate, initialDropDownValueHours, generateListMaps())
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
      strokeColor: MyThemeData.PRIMARY_COLOR,
      handlerColor: MyThemeData.PRIMARY_COLOR,
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

  List<Map<dynamic, dynamic>> generateListMaps() {
    List<Map<dynamic, dynamic>> list = <Map>[];
    // int startTime = (startSelectedTime.hour > 12)
    //     ? (startSelectedTime.hour - 12)
    //     : startSelectedTime.hour;
    int startTime = startSelectedTime.hour;
    int endTime = endSelectedTime.hour;
    int tempStartTime = startSelectedTime.hour;

    if (startTime > 12 && endTime < 12) {
      startTime -= 12;
      endTime += 12;
    }
    for (int i = startTime;
        i >= startTime && i <= endTime;
        i += initialDropDownValueHours) {
      if (tempStartTime >= 24) {
        tempStartTime -= 24;
      }
      list.add({
        'start': tempStartTime,
        'end': checkvalue(
          input: tempStartTime + initialDropDownValueHours,
        ),
      });
      log("start Time:" +
          tempStartTime.toString() +
          " End time" +
          checkvalue(
            input: tempStartTime + initialDropDownValueHours,
          ).toString());
      tempStartTime += initialDropDownValueHours;
    }
    if (list.last["end"] > endSelectedTime.hour) {
      // Map mapHolder = list.last;
      //  mapHolder.update("end", (value) => endSelectedTime.hour);
      // list.last =mapHolder;
      list.removeLast();
    }
    return list.toList();
  }
}

int checkvalue({
  required int input,
}) {
  if (input >= 24) {
    return input - 24;
  } else {
    return input;
  }
}
