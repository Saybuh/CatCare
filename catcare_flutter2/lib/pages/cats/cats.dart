import 'package:flutter/material.dart';

class Cats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cats'),
      ),
      body: Center(
        child: Text('This is the My Cats page'),
      ),
    );
  }
}
