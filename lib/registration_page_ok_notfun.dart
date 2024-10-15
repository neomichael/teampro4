import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'csv_helper.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<String> _notPreferred = [];
  List<String> _ingredients = ['onion', 'garlic', 'beer', 'peanut', 'shellfish'];
  bool _isSaved = false;
  String _selectedLanguage = 'zh_TW'; // Default language

  Future<void> _saveInfo() async {
    final String name = _nameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        // Save to CSV
        final Directory directory = await getApplicationDocumentsDirectory();
        final String path = '${directory.path}/info.csv';
        final File file = File(path);

        final bool fileExists = await file.exists();
        if (!fileExists) {
          await file.writeAsString('Name,Email,Password,NonPreferredFoods,Language\n');
        }

        final String nonPreferredFoodsString = _notPreferred.join(';');
        await file.writeAsString('$name,$email,$password,$nonPreferredFoodsString,$_selectedLanguage\n', mode: FileMode.append);

        // Also save using CSVHelper for consistency
        await CSVHelper.saveInfo(name, email, password, _notPreferred, _selectedLanguage);

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterName),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterEmail),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterPassword),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Text(AppLocalizations.of(context)!.notPreferred),
            Wrap(
              spacing: 8.0,
              children: _ingredients.map((String ingredient) {
                return FilterChip(
                  label: Text(ingredient),
                  selected: _notPreferred.contains(ingredient),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _notPreferred.add(ingredient);
                      } else {
                        _notPreferred.remove(ingredient);
                      }
                    });
                  },
                );
              }).toList(),
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