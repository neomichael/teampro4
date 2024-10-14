import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CSVDisplayPage extends StatefulWidget {
  @override
  _CSVDisplayPageState createState() => _CSVDisplayPageState();
}

class _CSVDisplayPageState extends State<CSVDisplayPage> {
  String _csvContent = '';

  @override
  void initState() {
    super.initState();
    _loadCSVContent();
  }

  Future<void> _loadCSVContent() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/info.csv';
      final file = File(path);

      if (await file.exists()) {
        final content = await file.readAsString();
        setState(() {
          _csvContent = content;
        });
      } else {
        setState(() {
          _csvContent = 'CSV file not found.';
        });
      }
    } catch (e) {
      setState(() {
        _csvContent = 'Error loading CSV: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CSV Content'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          _csvContent,
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadCSVContent,
        child: Icon(Icons.refresh),
        tooltip: 'Refresh CSV content',
      ),
    );
  }
}