// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

bool isValidEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool isPhone(String phone) {
  return RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
      .hasMatch(phone);
}

void showMessage(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('ok'),
          ),
        ],
      );
    },
  );
}

void showLoading(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Row(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            CircularProgressIndicator(),
            SizedBox(
              width: 12,
            ),
            Text('Loading...'),
          ],
        ),
      );
    },
  );
}

void hideLoading(BuildContext context) {
  Navigator.pop(context);
}
