import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/home_page.dart';
import 'pages/food_schedule_page.dart';
import 'pages/water_schedule_page.dart';
import 'pages/care_tips_page.dart';
import 'pages/illness_identification_page.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/pets_page.dart';
import 'themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(CatCareApp());
}

class CatCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatCare',
      theme: catCareTheme,
      home: AuthenticationWrapper(),
      routes: {
        '/home': (context) => HomePage(),
        '/food_schedule': (context) => FoodSchedulePage(),
        '/water_schedule': (context) => WaterSchedulePage(),
        '/care_tips': (context) => CareTipsPage(),
        '/illness_identification': (context) => IllnessIdentificationPage(),
        '/profile': (context) => ProfilePage(),
        '/settings': (context) => SettingsPage(),
        '/sign_in': (context) => SignInPage(),
        '/sign_up': (context) => SignUpPage(),
        '/pets': (context) => PetsPage(),
      },
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return SignInPage();
          } else {
            return HomePage();
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
