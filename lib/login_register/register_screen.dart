// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:developer';

import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Register Screen';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name = '';
  String email = '';
  String password = '';
  bool passwordVisible = false;
  String smsCode = '';

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.create_account_button,
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
                      name = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Your name';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'User Name',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    onChanged: (text) {
                      email = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter Your Email';
                      }
                      if (!isValidEmail(email) && !isPhone(email)) {
                        return 'Please Enter a vaild email address or phone number';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    obscureText: !passwordVisible,
                    onChanged: (text) {
                      password = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return 'Please Enter a password';
                      }
                      if (text.length < 6) {
                        return 'Password is too short';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              passwordVisible = true;
                            });
                          },
                          child: const Icon(Icons.remove_red_eye)),
                      labelText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        CreateAccountWithFireBaseAuth();
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

  void CreateAccountWithFireBaseAuth() async {
    try {
      showLoading(context);
      if (isValidEmail(email)) {
        var result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // to register the user to FireStore
        hideLoading(context);
        if (result.user != null) {
          var myUser = UserData(
              id: result.user!.uid,
              // ha7ot nafs el id el ma3molo save fe el auth
              name: name,
              email: email,
              password: password);
          addUserTOFireStore(myUser).then((value) {
            // provider.updateUser(myUser);
            showMessage('User Registered Successfully!', context);
            Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
          }).onError((error, stackTrace) {
            showMessage(error.toString(), context);
          });
        }
      } else if (isPhone(email)) {
        var auth = FirebaseAuth.instance;
        await auth.verifyPhoneNumber(
          phoneNumber: email,
          codeAutoRetrievalTimeout: (String verificationId) {},
          codeSent: (String verificationId, int? forceResendingToken) async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Enter SMS code'),
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
                        child: const Text('Done'),
                      )
                    ],
                  );
                });
          },
          timeout: const Duration(seconds: 60),
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
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
      }
    } catch (error) {
      hideLoading(context);
      showMessage(error.toString(), context);
    }
  }
}
