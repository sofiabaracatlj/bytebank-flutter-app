import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_bitebank/core/database_service.dart';
import 'package:flutter_application_bitebank/core/user_state.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late DatabaseService _databaseService;
  late Future<List<Map<String, dynamic>>> _transactionsFuture;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward(); // Start the animation

    // Initialize the database service and fetch transactions
    _transactionsFuture = Future.value(
      [],
    ); // Placeholder to avoid LateInitializationError
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<UserState>(context, listen: false).uid;
      _databaseService = DatabaseService(userId: userId!);
      _fetchTransactions();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _fetchTransactions() {
    setState(() {
      _transactionsFuture = _databaseService.getTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _transactionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }

          final transactions = snapshot.data!;
          final typeCounts = _calculateTypeCounts(transactions);

          return Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return PieChart(
                  PieChartData(
                    sections: _buildPieChartSections(typeCounts),
                    centerSpaceRadius: 40,
                    sectionsSpace: 2,
                    startDegreeOffset:
                        _animationController.value * 360, // Rotate the chart
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // Calculate the count of each transaction type
  Map<String, int> _calculateTypeCounts(
    List<Map<String, dynamic>> transactions,
  ) {
    final Map<String, int> typeCounts = {};
    for (final transaction in transactions) {
      final type = transaction['type'] as String;
      typeCounts[type] = (typeCounts[type] ?? 0) + 1;
    }
    return typeCounts;
  }

  // Build pie chart sections based on transaction type counts
  List<PieChartSectionData> _buildPieChartSections(
    Map<String, int> typeCounts,
  ) {
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.red,
    ];

    int index = 0;
    return typeCounts.entries.map((entry) {
      final type = entry.key;
      final count = entry.value;
      final color = colors[index % colors.length];
      index++;

      return PieChartSectionData(
        color: color,
        value: count.toDouble(),
        title: '$type\n$count',
        radius: 50 + (_animationController.value * 10), // Animate the radius
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}
