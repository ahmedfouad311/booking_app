// ignore_for_file: constant_identifier_names, unused_local_variable, avoid_print

import 'package:booking_app/admin/admin_home.dart';
import 'package:booking_app/common/common_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../home/home_screen.dart';
import 'register_admin_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginAdminScreen extends StatefulWidget {
  static const String ROUTE_NAME = 'Login Admin Screen';

  const LoginAdminScreen({Key? key}) : super(key: key);

  @override
  State<LoginAdminScreen> createState() => _LoginAdminScreenState();
}

class _LoginAdminScreenState extends State<LoginAdminScreen> {
  String password = '';
  bool passwordVisible = false;
  bool isAdmin = false;
  String adminPass = 'admin123';
  late String arguments;

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    arguments = ModalRoute.of(context)!.settings.arguments as String;
    return Container(
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.login_screen,
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
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState?.validate() == true) {
                        loginWithFirebaseAuth();
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 30, vertical: 10),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               isAdmin = true;
                  //             });
                  //           },
                  //           child: Text(
                  //             AppLocalizations.of(context)!.admin,
                  //             style: TextStyle(
                  //                 fontSize: 18,
                  //                 decoration: TextDecoration.underline,
                  //                 color: isAdmin
                  //                     ? Colors.white
                  //                     : Theme.of(context).primaryColor),
                  //           ),
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: TextButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               isAdmin = false;
                  //             });
                  //           },
                  //           child: Text(
                  //             AppLocalizations.of(context)!.user,
                  //             style: TextStyle(
                  //                 fontSize: 18,
                  //                 decoration: TextDecoration.underline,
                  //                 color: isAdmin
                  //                     ? Theme.of(context).primaryColor
                  //                     : Colors.white),
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginWithFirebaseAuth() async {
    try {
      showLoading(context);
      var result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: arguments, password: password);
      hideLoading(context);
      if (result.user != null) {
        showMessage(AppLocalizations.of(context)!.admin_logged_in_successfully,
            context);
        Navigator.pushReplacementNamed(context, AdminHome.ROUTE_NAME);
        // retrieve user's data from fireBase
        // var fireStoreUser = await getUserByID(result.user!.uid);
        // if (fireStoreUser != null) {
        //   // provider.updateUser(fireStoreUser);
        //   Navigator.pushReplacementNamed(
        //       context, AddBookingAdmin.ROUTE_NAME);
        // }
      }
    } catch (error) {
      hideLoading(context);
      showMessage(
          AppLocalizations.of(context)!.invaild_email_or_password, context);
    }
  }

  // void loginWithFireBaseAuth() async {
  //   if (isAdmin) {
  //     if (password == adminPass) {
  //       try {
  //         showLoading(context);
  //         var result = await FirebaseAuth.instance
  //             .signInWithEmailAndPassword(email: email, password: password);
  //         hideLoading(context);
  //         if (result.user != null) {
  //           showMessage(
  //               AppLocalizations.of(context)!.admin_logged_in_successfully,
  //               context);
  //           Navigator.pushReplacementNamed(context, AdminHome.ROUTE_NAME);
  //           // retrieve user's data from fireBase
  //           // var fireStoreUser = await getUserByID(result.user!.uid);
  //           // if (fireStoreUser != null) {
  //           //   // provider.updateUser(fireStoreUser);
  //           //   Navigator.pushReplacementNamed(
  //           //       context, AddBookingAdmin.ROUTE_NAME);
  //           // }
  //         }
  //       } catch (error) {
  //         hideLoading(context);
  //         showMessage(
  //             AppLocalizations.of(context)!.invaild_email_or_password, context);
  //       }
  //     }
  //   } else {
  //     try {
  //       showLoading(context);
  //       var result = await FirebaseAuth.instance
  //           .signInWithEmailAndPassword(email: email, password: password);
  //       hideLoading(context);
  //       if (result.user != null) {
  //         showMessage(AppLocalizations.of(context)!.user_logged_in_successfully,
  //             context);
  //         Navigator.pushReplacementNamed(context, HomeScreen.ROUTE_NAME);
  //         // retrieve user's data from fireBase
  //         // var fireStoreUser = await getUserByID(result.user!.uid);
  //         // if (fireStoreUser != null) {
  //         //   // provider.updateUser(fireStoreUser);
  //         // }
  //       }
  //     } catch (error) {
  //       hideLoading(context);
  //       showMessage(
  //           AppLocalizations.of(context)!.invaild_email_or_password, context);
  //     }
  //   }
  // }
}
