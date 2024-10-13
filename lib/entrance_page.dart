import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'photo_taking.dart';
import 'dart:io';
import 'main.dart'; // Import the MyApp class

class EntrancePage extends StatefulWidget {
  @override
  _EntrancePageState createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  String _selectedLanguage = 'zh_TW';
  String _name = '';
  List<String> _notPreferred = [];
  List<String> _ingredients = ['onion', 'garlic', 'beer', 'peanut', 'shellfish'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.menuPhotography),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _selectedLanguage,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLanguage = newValue;
                        _updateLocale(newValue);// Update locale
                      });
                    }
                  },
                  items: <String>['en', 'zh_TW', 'zh_CN', 'ja', 'ko', 'zh']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_getLanguageName(value)),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.enterName,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  hint: Text(AppLocalizations.of(context)!.notPreferred),
                  value: _notPreferred.isNotEmpty ? _notPreferred.last : null,
                  onChanged: (String? newValue) {
                    if (newValue != null && !_notPreferred.contains(newValue)) {
                      setState(() {
                        _notPreferred.add(newValue);
                      });
                    }
                  },
                  items: _ingredients
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                Wrap(
                  spacing: 8.0,
                  children: _notPreferred.map((ingredient) {
                    return Chip(
                      label: Text(ingredient),
                      onDeleted: () {
                        setState(() {
                          _notPreferred.remove(ingredient);
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print('Register as new user');
                      },
                      child: Text(AppLocalizations.of(context)!.register),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        print('Login as existing user');
                      },
                      child: Text(AppLocalizations.of(context)!.login),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotoTakingScreen(
                          onImageSaved: (File image) {
                            // Handle saved image
                          },
                        ),
                      ),
                    );
                  },
                  child: Text(AppLocalizations.of(context)!.next),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateLocale(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'en':
        newLocale = Locale('en');
        break;
      case 'zh_TW':
        newLocale = Locale('zh', 'TW');
        break;
      case 'zh_CN':
        newLocale = Locale('zh', 'CN');
        break;
      case 'ja':
        newLocale = Locale('ja');
        break;
      case 'ko':
        newLocale = Locale('ko');
        break;
      case 'zh':
        newLocale = Locale('zh');
        break;
      default:
        newLocale = Locale('en');
    }
    MyApp.setLocale(context, newLocale);
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'zh_TW':
        return '繁體中文';
      case 'zh_CN':
        return '简体中文';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      default:
        return languageCode;
    }
  }
}