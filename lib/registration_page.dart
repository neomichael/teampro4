import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'api_helper.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isSaved = false;
  final ApiHelper apiHelper = ApiHelper();

  Future<void> _saveInfo() async {
    final String name = _nameController.text;
    final String telephone = _telephoneController.text;
    final String email = _emailController.text;

    if (name.isNotEmpty && telephone.isNotEmpty && email.isNotEmpty) {
      try {
        // Save to CSV
        final Directory directory = await getApplicationDocumentsDirectory();
        final String path = '${directory.path}/info.csv';
        final File file = File(path);

        final bool fileExists = await file.exists();
        if (!fileExists) {
          await file.writeAsString('Name,Telephone,Email\n');
        }

        await file.writeAsString('$name,$telephone,$email\n', mode: FileMode.append);

        // Attempt to save to API
        try {
          await apiHelper.insertCustomer(name, telephone, email);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data saved successfully to CSV and API!')),
          );
        } catch (e) {
          print('API save failed: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data saved to CSV. API save failed: ${e.toString()}')),
          );
        }

        setState(() {
          _isSaved = true;
        });

        // Return to entrance page after a short delay
        Future.delayed(Duration(seconds: 2), () {
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
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.enterName,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _telephoneController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.enterTelephone,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.enterEmail,
                border: OutlineInputBorder(),
              ),
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