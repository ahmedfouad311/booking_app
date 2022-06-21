// ignore_for_file: must_be_immutable, constant_identifier_names

import 'dart:developer';

import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/login_register/admin/login_admin_screen.dart';
import 'package:booking_app/login_register/admin/register_admin_screen.dart';
import 'package:booking_app/login_register/user/login_user_screen.dart';
import 'package:booking_app/login_register/user/register_user_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Welcome Screen';

  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userInput = '';
  late String verification;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Welcome Screen',
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
                      labelText: 'email or phone',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
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
          Navigator.pushNamed(context, LoginAdminScreen.ROUTE_NAME, arguments: userInput);
          // retrieve user's data from fireBase
          // var fireStoreUser = await getUserByID(result.user!.uid);
          // if (fireStoreUser != null) {
          //   // provider.updateUser(fireStoreUser);
          //   Navigator.pushReplacementNamed(
          //       context, AddBookingAdmin.ROUTE_NAME);
          // }
        } else {
          Navigator.pushNamed(
              context, RegisterAdminScreen.ROUTE_NAME);
        }
      } catch (error) {
        hideLoading(context);
        showMessage(
            AppLocalizations.of(context)!.invaild_email_or_password, context);
      }
    } else if (isPhone(userInput)) {
      try {
        showLoading(context);
        var result =
            await FirebaseAuth.instance.signInWithPhoneNumber(userInput);
        hideLoading(context);
        if (result.verificationId.isNotEmpty) {
          showMessage(
              AppLocalizations.of(context)!.admin_logged_in_successfully,
              context);
          Navigator.pushReplacementNamed(context, LoginUserScreen.ROUTE_NAME, arguments: userInput);
          // retrieve user's data from fireBase
          // var fireStoreUser = await getUserByID(result.user!.uid);
          // if (fireStoreUser != null) {
          //   // provider.updateUser(fireStoreUser);
          //   Navigator.pushReplacementNamed(
          //       context, AddBookingAdmin.ROUTE_NAME);
          // }
        } else {
          Navigator.pushNamed(context, RegisterUserScreen.ROUTE_NAME);
        }
      } catch (error) {
        hideLoading(context);
        showMessage(
            'Invalid email or phone', context);
      }
    }
  }

  // void phoneVerify() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   var result = await FirebaseAuth.instance.verifyPhoneNumber(
  //     phoneNumber: userInput,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await auth.signInWithCredential(credential).then((value) async {
  //         if (value.user != null) {
  //           log('User Logged In');
  //         }
  //       });
  //     },
  //     verificationFailed: (FirebaseAuthException e) {
  //       log('${e.message} The provided phone number is not valid.');
  //     },
  //     codeSent: (String verificationId, int? resendToken) async {
  //       setState(() {
  //         verification = verificationId;
  //       });

  //       // // Create a PhoneAuthCredential with the code
  //       // PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       //     verificationId: verificationId, smsCode: smsCode);

  //       // // Sign the user in (or link) with the credential
  //       // await auth.signInWithCredential(credential);
  //     },
  //     timeout: const Duration(seconds: 60),
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       setState(() {
  //         verification = verificationId;
  //       });
  //     },
  //   );
  // }
}
