// ignore_for_file: constant_identifier_names

import 'dart:developer';

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
  String phone = '';
  String smsCode = '';
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'create user account',
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
                    onChanged: (text) {
                      phone = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!
                            .please_enter_your_email;
                      }
                      if (!isPhone(phone)) {
                        return AppLocalizations.of(context)!
                            .please_enter_a_vaild_email_address_or_phone_number;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.the_email,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
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
                          Text(
                            AppLocalizations.of(context)!.create_account_button,
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

  // void verifyOTP() async {
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: verificationID, smsCode: otpController.text);

  //   await auth.signInWithCredential(credential).then(
  //     (value) {
  //       setState(() {
  //         user = FirebaseAuth.instance.currentUser;
  //       });
  //     },
  //   ).whenComplete(
  //     () {
  //       if (user != null) {
  //         Fluttertoast.showToast(
  //           msg: "You are logged in successfully",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => Home(),
  //           ),
  //         );
  //       } else {
  //         Fluttertoast.showToast(
  //           msg: "your login is failed",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0,
  //         );
  //       }
  //     },
  //   );
  // }

  void createAccountWithFireBaseAuth() async {
    try {
      showLoading(context);
      var auth = FirebaseAuth.instance;
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        codeAutoRetrievalTimeout: (String verificationId) {},
        codeSent: (String verificationId, int? forceResendingToken) async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.enter_SMS_code),
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
                      onPressed: () {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        var credential = PhoneAuthProvider.credential(
                            verificationId: verificationId, smsCode: smsCode);
                        auth.signInWithCredential(credential).then((value) =>
                            Navigator.pushReplacementNamed(
                                    context, HomeScreen.ROUTE_NAME)
                                .catchError((e) {
                              print('Errorrrrrrrrrr');
                            }));
                      },
                      child: Text(AppLocalizations.of(context)!.done),
                    )
                  ],
                );
              });
        },
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          log(phoneAuthCredential.providerId);
          await auth
              .signInWithCredential(phoneAuthCredential)
              .then((value) => Navigator.pushReplacementNamed(
                  context, HomeScreen.ROUTE_NAME))
              .catchError((e) {
            print('Errorrrrrrrrrrrrr 2');
          });
        },
        verificationFailed: (FirebaseAuthException error) {
          if (error.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
      );
      hideLoading(context);
      // if (true) {
      //   var myUser = UserData(
      //     id: auth.currentUser!.uid,
      //     // ha7ot nafs el id el ma3molo save fe el auth
      //     name: name,
      //     email: email,
      //     password: password,
      //   );
      //   addUserTOFireStore(myUser).then((value) {
      //     // provider.updateUser(myUser);
      //     showMessage('User Registered Successfully!', context);
      //     Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_NAME);
      //   }).onError((error, stackTrace) {
      //     showMessage(error.toString(), context);
      //   });
      // }

    } catch (error) {
      hideLoading(context);
      showMessage(error.toString(), context);
    }
  }
}
