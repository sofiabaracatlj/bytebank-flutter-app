import 'package:flutter/material.dart';
import 'screens/home/home.dart';
import 'screens/transaction_list/transaction_list.dart';
import 'screens/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login', // Set LoginPage as the initial route
      routes: {
        '/login': (context) => const LoginPage(),
        '/': (context) => const HomePage(),
        '/transactions': (context) => const TransactionListScreen(),
      },
    );
  }
}
