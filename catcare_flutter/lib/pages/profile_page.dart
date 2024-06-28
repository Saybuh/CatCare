import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Cat Profile',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            ListTile(
              title: Text('Name: Whiskers'),
              subtitle: Text('Age: 2 years'),
            ),
            ListTile(
              title: Text('Breed: Siamese'),
              subtitle: Text('Weight: 4.5 kg'),
            ),
            ElevatedButton(
              onPressed: () {
                // Edit profile logic
              },
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
