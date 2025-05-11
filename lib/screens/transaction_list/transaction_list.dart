import 'package:flutter/material.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock list of transactions
    final List<Map<String, dynamic>> transactions = [
      {'title': 'Groceries', 'amount': 50.0, 'date': '2025-05-10'},
      {'title': 'Electricity Bill', 'amount': 120.0, 'date': '2025-05-09'},
      {'title': 'Internet', 'amount': 60.0, 'date': '2025-05-08'},
      {'title': 'Gym Membership', 'amount': 30.0, 'date': '2025-05-07'},
      {'title': 'Coffee', 'amount': 5.0, 'date': '2025-05-06'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Transaction List')),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return ListTile(
            leading: const Icon(Icons.attach_money),
            title: Text(transaction['title']),
            subtitle: Text('Date: ${transaction['date']}'),
            trailing: Text(
              '\$${transaction['amount'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            onTap: () {
              // Handle tap (e.g., navigate to transaction details or edit screen)
            },
          );
        },
      ),
    );
  }
}
