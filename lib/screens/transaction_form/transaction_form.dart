import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_bitebank/core/database_service.dart';
import 'package:flutter_application_bitebank/core/user_state.dart';
import 'package:provider/provider.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedFilePath;
  bool _isUploading = false;
  DateTime? _selectedDate;
  String? _selectedType;

  final List<String> _transactionTypes = [
    'Food',
    'Transportation',
    'Health',
    'Leisure',
  ];

  late final DatabaseService _databaseService;

  final CurrencyTextInputFormatter _currencyFormatter =
      CurrencyTextInputFormatter.currency(
        locale: 'pt_BR',
        decimalDigits: 2,
        symbol: 'R\$',
      );

  @override
  void initState() {
    super.initState();
    final userState = Provider.of<UserState>(context, listen: false);
    _databaseService = DatabaseService(userId: userState.uid!);
  }

  void _saveTransaction() async {
    final String title = _titleController.text.trim();
    final String formattedAmount = _amountController.text.trim();
    final double? amount = _currencyFormatter.getUnformattedValue().toDouble();
    final String date = _dateController.text.trim();

    // Validate title (should be text)
    if (title.isEmpty || !RegExp(r'^[a-zA-Z\s]+$').hasMatch(title)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title should only contain letters and spaces'),
        ),
      );
      return;
    }

    // Validate amount (should be a number)
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount should be greater than 0')),
      );
      return;
    }

    // Validate other fields
    if (date.isEmpty || _selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      String? fileUrl;
      if (_selectedFilePath != null) {
        setState(() {
          _isUploading = true;
        });
        fileUrl = await _databaseService.uploadFile(_selectedFilePath!);
        setState(() {
          _isUploading = false;
        });
      }

      await _databaseService.saveTransaction(
        title: title,
        amount: amount,
        date: date,
        type: _selectedType!,
        fileUrl: fileUrl,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction saved successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save transaction: $e')));
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File selected: ${result.files.single.name}')),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
            _selectedDate!.toLocal().toString().split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              inputFormatters: [
                _currencyFormatter,
              ], // Apply the currency formatter
              decoration: const InputDecoration(
                labelText: 'Amount',
                hintText: 'R\$0,00',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
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
                labelText: 'Type',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: const Text('Pick File'),
            ),
            if (_selectedFilePath != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Selected File: ${_selectedFilePath!.split('/').last}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            if (_isUploading)
              const Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: CircularProgressIndicator(),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTransaction,
              child: const Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
