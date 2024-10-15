import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CSVHelper {
  static const int MAX_NON_PREFERRED_FOODS = 5;

  static Future<void> saveInfo(String name, String email, String password, List<String> nonPreferredFoods, String language) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/info.csv';
    final File file = File(path);

    final bool fileExists = await file.exists();
    if (!fileExists) {
      await file.writeAsString('Name,Email,Password,NonPreferredFoods,Language\n');
    }

    final String nonPreferredFoodsString = nonPreferredFoods.take(MAX_NON_PREFERRED_FOODS).join(';');
    await file.writeAsString('$name,$email,$password,$nonPreferredFoodsString,$language\n', mode: FileMode.append);
  }

  static Future<Map<String, dynamic>?> readInfo() async {
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = '${directory.path}/info.csv';
      final File file = File(path);

      if (await file.exists()) {
        final List<String> lines = await file.readAsLines();
        if (lines.length > 1) {
          final List<String> lastLine = lines.last.split(',');
          if (lastLine.length >= 5) {
            return {
              'name': lastLine[0],
              'email': lastLine[1],
              'password': lastLine[2],
              'nonPreferredFoods': lastLine[3].split(';'),
              'language': lastLine[4],
            };
          }
        }
      }
    } catch (e) {
      print('Error reading info: $e');
    }
    return null;
  }

  static Future<void> updateLanguage(String name, String newLanguage) async {
    try {
      final info = await readInfo();
      if (info != null && info['name'] == name) {
        await saveInfo(
          info['name'],
          info['email'],
          info['password'],
          info['nonPreferredFoods'],
          newLanguage
        );
      }
    } catch (e) {
      print('Error updating language: $e');
    }
  }

  static Future<void> updateNonPreferredFoods(String name, List<String> newNonPreferredFoods) async {
    try {
      final info = await readInfo();
      if (info != null && info['name'] == name) {
        await saveInfo(
          info['name'],
          info['email'],
          info['password'],
          newNonPreferredFoods,
          info['language']
        );
      }
    } catch (e) {
      print('Error updating non-preferred foods: $e');
    }
  }
}