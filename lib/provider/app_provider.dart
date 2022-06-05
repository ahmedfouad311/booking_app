import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  String defaultLanguage = 'en';

  void changeLanguage(String newLanguage) {
    if (newLanguage == defaultLanguage) {
      return;
    }
    defaultLanguage = newLanguage;
    notifyListeners();
  }

  bool isLoggedIn() {
    // de 3l4an law 2na already kont 3aml login abl keda ywadeni 3ala toll le el home screen
    // lma 2fta7 el app w dah el 2na 3amalto fe el main screen fe el initial route
    return FirebaseAuth.instance.currentUser != null;
  }
}
