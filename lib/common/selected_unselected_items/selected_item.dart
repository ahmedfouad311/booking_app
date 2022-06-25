// ignore_for_file: must_be_immutable

import 'package:booking_app/Theme/theme_data.dart';
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
              style: const TextStyle(
                fontSize: 18,
                color: MyThemeData.PRIMARY_COLOR,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.language,
              color: MyThemeData.PRIMARY_COLOR,
            ),
          ],
        ),
        const Icon(
          Icons.check,
          color: MyThemeData.PRIMARY_COLOR,
        ),
      ],
    );
  }
}
