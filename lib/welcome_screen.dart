// ignore_for_file: constant_identifier_names

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/signin_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatelessWidget {
  static const String ROUTE_NAME = 'Welcome Screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15, right: 50, left: 50),
          child: SizedBox(
            width: double .infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                  AppLocalizations.of(context)!.welcome_to_football_booking_app,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MyThemeData.PRIMARY_COLOR,
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.09,
                ),
                Image.asset('assets/football_icon.png', width: 200,),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                Text(
                  AppLocalizations.of(context)!.lets_get_started,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: MyThemeData.PRIMARY_COLOR,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
                 SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(MyThemeData.PRIMARY_COLOR),
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ))),
                  onPressed: () {
                    Navigator.pushNamed(context, SigninScreen.ROUTE_NAME);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.next,
                    textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold
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
}
