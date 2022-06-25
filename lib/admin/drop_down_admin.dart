// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:booking_app/Theme/theme_data.dart';
import 'package:flutter/material.dart';

class DropDownButtonAdmin extends StatefulWidget {
  void Function(String?) onChanged;
  List<String> dropDownList;
  DropDownButtonAdmin(
      {Key? key, required this.onChanged, required this.dropDownList})
      : super(key: key);

  @override
  State<DropDownButtonAdmin> createState() => _DropDownButtonAdminState();
}

class _DropDownButtonAdminState extends State<DropDownButtonAdmin> {
  late String initialDropDownValue;
  @override
  void initState() {
    initialDropDownValue =
        widget.dropDownList.isEmpty ? "" : widget.dropDownList[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    initialDropDownValue =
        widget.dropDownList.isEmpty ? "" : widget.dropDownList[0];
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: MyThemeData.PRIMARY_COLOR, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: MyThemeData.PRIMARY_COLOR, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide:
              const BorderSide(color: MyThemeData.PRIMARY_COLOR, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      value: initialDropDownValue == "" ? null : initialDropDownValue,
      // value: null,
      icon: const Icon(
        Icons.arrow_downward,
        color: MyThemeData.PRIMARY_COLOR,
      ),
      elevation: 16,
      style: const TextStyle(
          color: MyThemeData.PRIMARY_COLOR, fontWeight: FontWeight.bold),
      onChanged: widget.onChanged,
      items: widget.dropDownList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
