import 'package:catcare_flutter2/firebase_options.dart';
import 'package:catcare_flutter2/pages/login/login.dart';
import 'package:catcare_flutter2/pages/signup/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // ignore: empty_constructor_bodies
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CatCare',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}
