import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'photo_taking.dart';
import 'main.dart';
import 'registration_page.dart';
import 'user_info_page.dart';
import 'csv_helper.dart';
import 'azure_sql_helper.dart';
import 'menu_parsing.dart';

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
  final AzureSqlHelper _azureSqlHelper = AzureSqlHelper();

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

  void _updateNonPreferredFoods() {
    if (_nameController.text.isNotEmpty) {
      CSVHelper.updateNonPreferredFoods(_nameController.text, _notPreferred);
    }
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
    if (_nameController.text.isNotEmpty) {
      CSVHelper.updateLanguage(_nameController.text, languageCode);
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
        return languageCode;
    }
  }

  String getIngredientTranslation(String ingredient, BuildContext context) {
    switch (ingredient) {
      case 'onion':
        return AppLocalizations.of(context)!.onion;
      case 'garlic':
        return AppLocalizations.of(context)!.garlic;
      case 'beer':
        return AppLocalizations.of(context)!.beer;
      case 'peanut':
        return AppLocalizations.of(context)!.peanut;
      case 'shellfish':
        return AppLocalizations.of(context)!.shellfish;
      default:
        return ingredient;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double buttonWidth = screenWidth * 0.4;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.menuPhotography),
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
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
                      fillColor: Colors.white.withOpacity(0.3), // Set light white transparency
                      filled: true,
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
                        _updateNonPreferredFoods();
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
                          _updateNonPreferredFoods();
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MenuParsingPage(), // New page for menu parsing
                            ),
                          );
                        },
                        child: Text('解析菜單', style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(buttonWidth, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          String dbSaveResult = await _azureSqlHelper.registerUser(
                            email: 'mikelin0502@yahoo.com.tw',
                            password: 'Password123@',
                            taboos: 'None',
                            userName: 'Michael',
                            language: 'en-US',
                          );

                          bool dbSaveSuccess = dbSaveResult == 'User registered successfully.';

                          if (dbSaveSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$dbSaveResult')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Registration failed: $dbSaveResult')));
                          }
                        },
                        child: Text('SRV', style: TextStyle(fontSize: 14)),
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
      ),
    );
  }
}
