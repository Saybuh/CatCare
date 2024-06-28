import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  void _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/sign_in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CatCare Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: ListTile(
                title: Text('Food Schedule'),
                leading: Icon(Icons.food_bank),
                onTap: () {
                  Navigator.pushNamed(context, '/food_schedule');
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Water Schedule'),
                leading: Icon(Icons.water),
                onTap: () {
                  Navigator.pushNamed(context, '/water_schedule');
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Care Tips'),
                leading: Icon(Icons.tips_and_updates),
                onTap: () {
                  Navigator.pushNamed(context, '/care_tips');
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Identify Illnesses'),
                leading: Icon(Icons.medical_services),
                onTap: () {
                  Navigator.pushNamed(context, '/illness_identification');
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('My Cats'),
                leading: Icon(Icons.pets),
                onTap: () {
                  Navigator.pushNamed(context, '/pets');
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Profile'),
                leading: Icon(Icons.person),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            ),
            Card(
              child: ListTile(
                title: Text('Settings'),
                leading: Icon(Icons.settings),
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
