// ignore_for_file: constant_identifier_names

import 'dart:developer';

import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterUserScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Register User Screen';

  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  late String verification;
  late String smsCode;
  String name = '';
  late String arguments;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as String;
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyThemeData.PRIMARY_COLOR,
          title: Text(
            AppLocalizations.of(context)!.register,
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
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    cursorColor: MyThemeData.PRIMARY_COLOR,
                    onChanged: (text) {
                      name = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!.please_enter_a_name;
                      }
                      return null;
                    },
                    decoration:  InputDecoration(
                      labelText: AppLocalizations.of(context)!.name,
                      labelStyle: const TextStyle(color: MyThemeData.PRIMARY_COLOR),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: MyThemeData.PRIMARY_COLOR),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.06,
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            MyThemeData.PRIMARY_COLOR),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        createAccountWithFireBaseAuth();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text(AppLocalizations.of(context)!.verfiy),
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

  void createAccountWithFireBaseAuth() async {
    try {
      showLoading(context);
      FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+20' + arguments,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          log(phoneAuthCredential.providerId);
          await FirebaseAuth.instance
              .signInWithCredential(phoneAuthCredential)
              .then((value) => Navigator.pushReplacementNamed(
                  context, HomeScreen.ROUTE_NAME))
              .catchError((e) {
            log('Errorrrrrrrrrrrrr 2');
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          if (error.code == 'invalid-phone-number') {
            log('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.enter_SMS_code, style: const TextStyle(color: MyThemeData.PRIMARY_COLOR),),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        onChanged: (text) {
                          smsCode = text;
                        },
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            MyThemeData.PRIMARY_COLOR),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)))),
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        var credential = PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);
                        auth.signInWithCredential(credential).then((value) =>
                            Navigator.pushReplacementNamed(
                                    context, HomeScreen.ROUTE_NAME)
                                .catchError((e) {
                              log('Errorrrrrrrrrr');
                            }));
                      },
                      child: Text(AppLocalizations.of(context)!.done),
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (error) {
      hideLoading(context);
      showMessage(AppLocalizations.of(context)!.invalid_email_or_phone, context);
    }
  }
}
