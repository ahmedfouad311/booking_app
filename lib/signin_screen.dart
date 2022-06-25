// ignore_for_file: must_be_immutable, constant_identifier_names

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/login_register/admin/login_admin_screen.dart';
import 'package:booking_app/login_register/admin/register_admin_screen.dart';
import 'package:booking_app/login_register/user/register_user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SigninScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Sign In Screen';

  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  String userInput = '';
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyThemeData.PRIMARY_COLOR,
          title: Text(
            AppLocalizations.of(context)!.getting_started,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.20,
                  ),
                  TextFormField(
                    cursorColor: MyThemeData.PRIMARY_COLOR,
                    onChanged: (text) {
                      userInput = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!
                            .please_enter_your_email;
                      }
                      if (!isValidEmail(userInput) && !isPhone(userInput)) {
                        return AppLocalizations.of(context)!
                            .please_enter_a_vaild_email_address_or_phone_number;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email_or_phone,
                      labelStyle: const TextStyle(color: MyThemeData.PRIMARY_COLOR),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: MyThemeData.PRIMARY_COLOR),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            MyThemeData.PRIMARY_COLOR),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        checkUserOrAdmin();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(
                            AppLocalizations.of(context)!.sign_in_button,
                          ),
                          const Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkUserOrAdmin() async {
    if (isValidEmail(userInput)) {
      try {
        showLoading(context);
        var result =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(userInput);
        hideLoading(context);
        if (result.isNotEmpty) {
          showMessage(
              AppLocalizations.of(context)!.admin_logged_in_successfully,
              context);
          Navigator.pushNamed(context, LoginAdminScreen.ROUTE_NAME,
              arguments: userInput);
        } else {
          Navigator.pushNamed(context, RegisterAdminScreen.ROUTE_NAME);
        }
      } catch (error) {
        hideLoading(context);
        showMessage(
            AppLocalizations.of(context)!.invaild_email_or_password, context);
      }
    } else if (isPhone(userInput)) {
      Navigator.pushNamed(context, RegisterUserScreen.ROUTE_NAME,
          arguments: userInput);
    }
  }
}
