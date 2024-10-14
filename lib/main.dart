import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'entrance_page.dart';
import 'registration_page.dart';
import 'photo_taking.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userInfo = await readUserInfo();
  runApp(MyApp(userInfo: userInfo));
}

Future<Map<String, String>?> readUserInfo() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/user_info.csv');
    if (await file.exists()) {
      final contents = await file.readAsString();
      final lines = contents.split('\n');
      if (lines.length > 1) {
        final headerLine = lines[0].split(',');
        final dataLine = lines[1].split(',');
        if (headerLine.length == dataLine.length && dataLine.length >= 3) {
          return {
            'name': dataLine[0],
            'telephone': dataLine[1],
            'email': dataLine[2],
          };
        }
      }
    }
  } catch (e) {
    print('Error reading user info: $e');
  }
  return null;
}

class MyApp extends StatefulWidget {
  final Map<String, String>? userInfo;

  const MyApp({Key? key, this.userInfo}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) => context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    title: 'teampro4',
    theme: ThemeData(
        primarySwatch: Colors.blue,
    ),
    locale: _locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: EntrancePage(userInfo:widget.userInfo),
    );
  }
}
