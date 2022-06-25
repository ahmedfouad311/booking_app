// ignore_for_file: non_constant_identifier_names, avoid_print, constant_identifier_names


import 'package:booking_app/Theme/theme_data.dart';
import 'package:booking_app/admin/admin_home.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:booking_app/data/firestore_utils.dart';
import 'package:booking_app/data/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterAdminScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Register Admin Screen';

  const RegisterAdminScreen({Key? key}) : super(key: key);

  @override
  State<RegisterAdminScreen> createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  String email = '';
  String password = '';
  bool passwordVisible = false;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyThemeData.PRIMARY_COLOR,
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
                    cursorColor: MyThemeData.PRIMARY_COLOR,
                    onChanged: (text) {
                      email = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!
                            .please_enter_your_email;
                      }
                      if (!isValidEmail(email) && !isPhone(email)) {
                        return AppLocalizations.of(context)!
                            .please_enter_a_vaild_email_address_or_phone_number;
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.the_email,
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
                  TextFormField(
                    cursorColor: MyThemeData.PRIMARY_COLOR,
                    obscureText: !passwordVisible,
                    onChanged: (text) {
                      password = text;
                    },
                    validator: (text) {
                      if (text == null || text.trim().isEmpty) {
                        return AppLocalizations.of(context)!
                            .please_enter_a_password;
                      }
                      if (text.length < 6) {
                        return AppLocalizations.of(context)!
                            .password_is_too_short;
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
                      labelText: AppLocalizations.of(context)!.the_password,
                      labelStyle: const TextStyle(color: MyThemeData.PRIMARY_COLOR),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: MyThemeData.PRIMARY_COLOR),
                      ),
                      suffixIconColor: MyThemeData.PRIMARY_COLOR
                    ),
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
                        createAccountWithFirebaseAuthEmailAndPass();
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

  void createAccountWithFirebaseAuthEmailAndPass() async {
    try {
      var result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // to register the user to FireStore
        hideLoading(context);
        if (result.user != null) {
          var myUser = UserData(
              id: result.user!.uid,
              // ha7ot nafs el id el ma3molo save fe el auth
              userInput: email,);
          addUserTOFireStore(myUser).then((value) {
            // provider.updateUser(myUser);
            showMessage(
                AppLocalizations.of(context)!.user_registered_successfully,
                context);
            Navigator.pushReplacementNamed(context, AdminHome.ROUTE_NAME);
          }).onError((error, stackTrace) {
            showMessage(error.toString(), context);
          });
        }
    } catch (error) {
      hideLoading(context);
      showMessage(error.toString(), context);
    }
  }
}
