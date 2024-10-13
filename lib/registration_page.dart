import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'csv_helper.dart'; // Helper class for CSV operations

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telephoneController = TextEditingController();
  bool _isSaved = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textBoxWidth = screenWidth * 0.6;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.register),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: textBoxWidth,
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enterName,
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: textBoxWidth,
                  child: TextField(
                    controller: _telephoneController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.enterTelephone,
                      border: OutlineInputBorder(),
                    ),
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveInfo,
                  child: Text(AppLocalizations.of(context)!.create),
                ),
                SizedBox(height: 20),
                if (_isSaved)
                  Text(
                    'Information is saved',
                    style: TextStyle(color: Colors.green),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveInfo() async {
    final String name = _nameController.text;
    final String telephone = _telephoneController.text;

    if (name.isNotEmpty && telephone.isNotEmpty) {
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
    }
  }
}