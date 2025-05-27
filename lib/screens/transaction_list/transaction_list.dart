import 'package:flutter/material.dart';
import 'package:flutter_application_bitebank/core/database_service.dart';
import 'package:flutter_application_bitebank/core/user_state.dart';
import 'package:provider/provider.dart';

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({super.key});

  @override
  State<TransactionListScreen> createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  late DatabaseService _databaseService;
  late Future<List<Map<String, dynamic>>> _transactionsFuture;
  String? _selectedType; // Selected transaction type for filtering

  final List<String> _transactionTypes = [
    'All',
    'Food',
    'Transportation',
    'Health',
    'Leisure',
  ];

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<UserState>(context, listen: false).uid;
    _databaseService = DatabaseService(userId: userId!);
    _fetchTransactions();
  }

  void _fetchTransactions() {
    setState(() {
      _transactionsFuture = _databaseService.getTransactions();
    });
  }

  List<Map<String, dynamic>> _filterTransactions(
    List<Map<String, dynamic>> transactions,
  ) {
    if (_selectedType == null || _selectedType == 'All') {
      return transactions; // No filtering if "All" is selected
    }
    return transactions
        .where((transaction) => transaction['type'] == _selectedType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction List')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                value: _selectedType ?? 'All',
                items:
                    _transactionTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedType = newValue;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Filter by Type',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _transactionsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  }

                  final transactions = _filterTransactions(snapshot.data!);

                  if (transactions.isEmpty) {
                    return const Center(
                      child: Text('No transactions match the filter.'),
                    );
                  }

                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.attach_money),
                          title: Text(transaction['title']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Date: ${transaction['date']}'),
                              Text('Type: ${transaction['type']}'),
                              if (transaction['fileUrl'] != null)
                                Text('File: ${transaction['fileUrl']}'),
                            ],
                          ),
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
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
