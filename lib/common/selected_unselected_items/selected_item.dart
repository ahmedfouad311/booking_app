// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class SelectedItem extends StatelessWidget {
  String text;
  SelectedItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              Icons.language,
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
        Icon(
          Icons.check,
          color: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
