// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class UnselectedItem extends StatelessWidget {
  String text;
  UnselectedItem({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const Icon(
              Icons.language,
              color: Colors.black,
            )
          ],
        ),
      ],
    );
  }
}
