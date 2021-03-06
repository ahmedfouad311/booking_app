
import 'package:booking_app/admin/add_booking_admin.dart';
import 'package:booking_app/admin/admin_home.dart';
import 'package:booking_app/admin/details/admin_details_screen.dart';
import 'package:booking_app/home/home_screen.dart';
import 'package:booking_app/login_register/admin/register_admin_screen.dart';
import 'package:booking_app/login_register/admin/login_admin_screen.dart';
import 'package:booking_app/login_register/user/register_user_screen.dart';
import 'package:booking_app/provider/app_provider.dart';
import 'package:booking_app/user/time_book_screen.dart';
import 'package:booking_app/user/user_booking.dart';
import 'package:booking_app/signin_screen.dart';
import 'package:booking_app/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(ChangeNotifierProvider(
      create: (context) => AppProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(appProvider.defaultLanguage),
      routes: {
        WelcomeScreen.ROUTE_NAME: (context) => const WelcomeScreen(),
        SigninScreen.ROUTE_NAME: (context) => const SigninScreen(),
        HomeScreen.ROUTE_NAME: (context) => const HomeScreen(),
        LoginAdminScreen.ROUTE_NAME: (context) => const LoginAdminScreen(),
        RegisterAdminScreen.ROUTE_NAME: (context) => const RegisterAdminScreen(),
        RegisterUserScreen.ROUTE_NAME:(context) => const RegisterUserScreen(),
        AdminHome.ROUTE_NAME: (context) => const AdminHome(),
        AddBookingAdmin.ROUTE_NAME: (context) =>  AddBookingAdmin(),
        AdminDetailsScreen.ROUTE_NAME: (context) => const AdminDetailsScreen(),
        UserBooking.ROUTE_NAME: (context) => const UserBooking(userBookingData: [],),
        TimeBookScreen.ROUTE_NAME: (context) => const TimeBookScreen(),
      },
      // initialRoute: appProvider.isLoggedIn()
      //     ? HomeScreen.ROUTE_NAME
      //     : LoginScreen.ROUTE_NAME,
      initialRoute: WelcomeScreen.ROUTE_NAME,
    );
  }
}
