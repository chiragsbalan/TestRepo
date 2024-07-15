import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
        child: Text(
          'Here are your notifications.',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
