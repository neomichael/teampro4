import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'photo_taking.dart';
import 'main.dart';
import 'registration_page.dart';
import 'user_info_page.dart'; // Add this import

class EntrancePage extends StatefulWidget {
  final Map<String, String>? userInfo;

  const EntrancePage({Key? key, this.userInfo}) : super(key: key);

  @override
  _EntrancePageState createState() => _EntrancePageState();
}

class _EntrancePageState extends State<EntrancePage> {
  String _selectedLanguage = 'zh_TW';
  late TextEditingController _nameController;
  List<String> _notPreferred = [];
  List<String> _ingredients = ['onion', 'garlic', 'beer', 'peanut', 'shellfish'];
  bool _isLoginEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userInfo?['name'] ?? '');
    _isLoginEnabled = widget.userInfo != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
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
        case 'zh':
            newLocale = Locale('zh');
            break;
        default:
            newLocale = Locale('zh', 'TW');  // Default to Traditional Chinese
    }
    final myAppState = MyApp.of(context);
    if (myAppState != null) {
    myAppState.setLocale(newLocale);
  }
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
    case 'en':
        return 'English';
    case 'zh_TW':
        return '繁體中文';
    case 'zh':
        return '简体中文';
    default:
        return languageCode;  // This ensures a non-null return
    }    // ... (keep your existing _getLanguageName method)
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.4;

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
                        _updateLocale(newValue);
                      });
                    }
                  },
                  items: <String>['en', 'zh_TW', 'zh']
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
                  controller: _nameController,
                  readOnly: true,
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
                      onPressed: _isLoginEnabled
                          ? () {
                              print('Login as existing user');
                            }
                          : null,
                      child: Text(AppLocalizations.of(context)!.login),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegistrationPage()),
                        );
                        if (result != null && result is String) {
                          setState(() {
                            _nameController.text = result;
                            _isLoginEnabled = true;
                          });
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.register),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(buttonWidth, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhotoTakingScreen(
                              onImageSaved: (dynamic image) {
                                // Handle saved image
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.next),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(buttonWidth, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserInfoPage(userInfo: widget.userInfo),
                          ),
                        );
                      },
                      child: Text('USRINFO', style: TextStyle(fontSize: 14)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(buttonWidth, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}