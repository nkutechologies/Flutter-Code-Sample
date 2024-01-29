import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final int score;

  ResultsScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Quiz Completed!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            Text(
              'Your Score: $score',
              style: TextStyle(fontSize: 18.0),
            ),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate back to the home screen
              },
              child: Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
