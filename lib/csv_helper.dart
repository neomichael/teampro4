import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CSVHelper {
  static Future<void> saveInfo(String name, String telephone) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/info.csv';
    final File file = File(path);

    final bool fileExists = await file.exists();
    if (!fileExists) {
      await file.writeAsString('Name,Telephone\n');
    }

    await file.writeAsString('$name,$telephone\n', mode: FileMode.append);
  }
}