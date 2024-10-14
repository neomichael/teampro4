import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'entrance_page.dart';
import 'registration_page.dart';
import 'photo_taking.dart';
import 'dart:io';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
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
      home: EntrancePage(),
      routes: {
        '/registration': (context) => RegistrationPage(),
        '/photo_taking': (context) => PhotoTakingScreen(
          onImageSaved: (File image) {
            // Navigate to the next page after the image is saved
            Navigator.pushNamed(context, '/next_page');           // Handle saved image
          },
        ),
      },
    );
  }    

//     return MaterialApp(
//       locale: _locale,
//       localizationsDelegates: AppLocalizations.localizationsDelegates,
//       supportedLocales: AppLocalizations.supportedLocales,      
//       home: EntrancePage(),
//     );
//   }
}