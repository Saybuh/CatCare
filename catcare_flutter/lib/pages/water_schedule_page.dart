import 'package:flutter/material.dart';

class WaterSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Water Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Watering Times',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('8:00 AM'),
                    subtitle: Text('Morning watering'),
                  ),
                  ListTile(
                    title: Text('1:00 PM'),
                    subtitle: Text('Afternoon watering'),
                  ),
                  ListTile(
                    title: Text('7:00 PM'),
                    subtitle: Text('Evening watering'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add watering time logic
              },
              child: Text('Add Watering Time'),
            ),
          ],
        ),
      ),
    );
  }
}
