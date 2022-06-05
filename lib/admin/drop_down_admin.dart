// ignore_for_file: prefer_const_constructors_in_immutables, must_be_immutable

import 'package:flutter/material.dart';

class DropDownButtonAdmin extends StatefulWidget {
  void Function(String?) onChanged;
  DropDownButtonAdmin({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<DropDownButtonAdmin> createState() => _DropDownButtonAdminState();
}

class _DropDownButtonAdminState extends State<DropDownButtonAdmin> {
  late String initialDropDownValue;
  List<String> stadiums = [
    'Cairo International Stadium',
    'Borg El Arab Stadium',
    'Suez Stadium',
    'Mokhtar El Tetsh Stadium'
  ];

  @override
  void initState() {
    initialDropDownValue = stadiums[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
      value: initialDropDownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      onChanged: widget.onChanged,
      items: stadiums.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
