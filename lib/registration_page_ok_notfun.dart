import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  bool _isSaved = false;

  Future<void> _saveInfo() async {
    final String name = _nameController.text;
    final String telephone = _telephoneController.text;

    if (name.isNotEmpty && telephone.isNotEmpty) {
      try {
        // Save to CSV
        final Directory directory = await getApplicationDocumentsDirectory();
        final String path = '${directory.path}/info.csv';
        final File file = File(path);

        final bool fileExists = await file.exists();
        if (!fileExists) {
          await file.writeAsString('Name,Telephone\n');
        }

        await file.writeAsString('$name,$telephone\n', mode: FileMode.append);

        setState(() {
          _isSaved = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data saved successfully to CSV!')),
        );

        // Return to entrance page after a short delay
        Future.delayed(Duration(seconds: 1), () {
          Navigator.pop(context, name);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving to CSV: ${e.toString()}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterName),
            ),
            TextField(
              controller: _telephoneController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterTelephone),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveInfo,
              child: Text(AppLocalizations.of(context)!.create),
            ),
            if (_isSaved)
              Text(
                'Information is saved',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }
}