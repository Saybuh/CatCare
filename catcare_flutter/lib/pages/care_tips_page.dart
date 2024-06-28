import 'package:flutter/material.dart';

class CareTipsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Care Tips'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Care Tips', style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Nutrition'),
                    subtitle: Text('Ensure a balanced diet for your cat.'),
                  ),
                  ListTile(
                    title: Text('Grooming'),
                    subtitle: Text(
                        'Regularly groom your cat to keep its fur clean and healthy.'),
                  ),
                  ListTile(
                    title: Text('Behavior'),
                    subtitle: Text(
                        'Observe your cat\'s behavior to detect any changes.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
