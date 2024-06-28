import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Settings', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            ListTile(
              title: Text('Notification Preferences'),
              onTap: () {
                // Navigate to notification settings
              },
            ),
            ListTile(
              title: Text('Theme Settings'),
              onTap: () {
                // Navigate to theme settings
              },
            ),
            ListTile(
              title: Text('Account Management'),
              onTap: () {
                // Navigate to account management
              },
            ),
          ],
        ),
      ),
    );
  }
}
