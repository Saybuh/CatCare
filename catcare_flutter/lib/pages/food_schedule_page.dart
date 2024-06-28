import 'package:flutter/material.dart';

class FoodSchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Feeding Times',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('8:00 AM'),
                    subtitle: Text('Morning feeding'),
                  ),
                  ListTile(
                    title: Text('1:00 PM'),
                    subtitle: Text('Afternoon feeding'),
                  ),
                  ListTile(
                    title: Text('7:00 PM'),
                    subtitle: Text('Evening feeding'),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Add feeding time logic
              },
              child: Text('Add Feeding Time'),
            ),
          ],
        ),
      ),
    );
  }
}
