import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_bitebank/core/user_state.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instanceFor(
    app: Firebase.app(),
    databaseId: 'transactions',
  );
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String userId;

  //init database
  DatabaseService({required this.userId}) {}

  // Save a transaction to Firestore
  Future<void> saveTransaction({
    required String title,
    required double amount,
    required String date,
    required String type,
    String? fileUrl,
  }) async {
    print(
      '**************Saving transaction: $title, $amount, $date, $type, $fileUrl, $userId',
    );
    try {
      await _firestore.collection('transactions').add({
        'title': title,
        'amount': amount,
        'date': date,
        'type': type,
        'fileUrl': fileUrl,
        'createdAt': Timestamp.now(),
        'userId': userId,
      });
    } catch (e) {
      throw Exception('Failed to save transaction: $e');
    }
  }

  // Upload a file to Firebase Storage
  Future<String?> uploadFile(String filePath) async {
    try {
      final fileName = filePath.split('/').last;
      final storageRef = _storage.ref().child('uploads/$fileName');

      final uploadTask = storageRef.putFile(File(filePath));
      final snapshot = await uploadTask.whenComplete(() {});

      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Get transactions by userId from Firestore
  Future<List<Map<String, dynamic>>> getTransactions() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('transactions')
              .where('userId', isEqualTo: userId) // Filter by userId
              .get();

      return querySnapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      print('*******************Error fetching transactions: $e');
      throw Exception('Failed to fetch transactions: $e');
    }
  }
}
