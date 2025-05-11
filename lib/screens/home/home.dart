import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/transactions');
              },
              child: const Text('View Transactions'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/add-transaction');
              },
              child: const Text('Add Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
