import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About & Terms')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'About BookPath',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 12),
            Text(
              'BookPath is your personal book journal app...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 24),
            Text(
              'Terms & Conditions',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: 12),
            Text(
              'By using BookPath, you agree to the following terms...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
