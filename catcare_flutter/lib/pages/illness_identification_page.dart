import 'package:flutter/material.dart';

class IllnessIdentificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Identify Illnesses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Illness Identification',
                style: Theme.of(context).textTheme.headlineLarge),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text('Common Cold'),
                    subtitle: Text('Symptoms: Sneezing, runny nose, coughing.'),
                  ),
                  ListTile(
                    title: Text('Feline Diabetes'),
                    subtitle: Text(
                        'Symptoms: Increased thirst and urination, weight loss.'),
                  ),
                  ListTile(
                    title: Text('Fleas and Ticks'),
                    subtitle: Text(
                        'Symptoms: Scratching, hair loss, visible insects.'),
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
