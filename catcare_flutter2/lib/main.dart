import 'package:catcare_flutter2/firebase_options.dart';
import 'package:catcare_flutter2/pages/care_tips/care_tips.dart';
import 'package:catcare_flutter2/pages/cats/cats.dart';
import 'package:catcare_flutter2/pages/food_schedule/food_schedule.dart';
import 'package:catcare_flutter2/pages/home/home.dart';
import 'package:catcare_flutter2/pages/illness_identification/illness_identification.dart';
import 'package:catcare_flutter2/pages/login/login.dart';
import 'package:catcare_flutter2/pages/profile/profile.dart';
import 'package:catcare_flutter2/pages/signup/signup.dart';
import 'package:catcare_flutter2/pages/water_schedule/water_schedule.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthCheck(),
      routes: {
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(),
        '/care_tips': (context) => CareTips(),
        '/cats': (context) => Cats(),
        '/food_schedule': (context) => FoodSchedule(),
        '/illness_identification': (context) => IllnessIdentification(),
        '/profile': (context) => Profile(),
        '/water_schedule': (context) => WaterSchedule(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return Home();
        }
        return Login();
      },
    );
  }
}
