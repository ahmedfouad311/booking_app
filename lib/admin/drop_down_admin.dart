// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'dart:developer';

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
  // late String initialDropDownValue;
  @override
  void initState() {
    // initialDropDownValue =
    //     widget.dropDownList.isEmpty ? "" : widget.dropDownList[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // initialDropDownValue =
    //     widget.dropDownList.isEmpty ? "" : widget.dropDownList[0];
    log("Working list" + widget.dropDownList.toString());
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).primaryColor, width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      // value: initialDropDownValue == "" ? null : initialDropDownValue,
      value: null,
      icon: Icon(
        Icons.arrow_downward,
        color: Theme.of(context).primaryColor,
      ),
      elevation: 16,
      style: TextStyle(
          color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
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
