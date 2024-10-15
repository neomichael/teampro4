import 'package:http/http.dart' as http;
import 'dart:convert';

class AzureSqlHelper {
  // Singleton instance
  static final AzureSqlHelper _instance = AzureSqlHelper._privateConstructor();
  factory AzureSqlHelper() => _instance;
  AzureSqlHelper._privateConstructor();

  // API endpoint
  final String _apiUrl = 'https://gai243aifoodie20241014-d0dtgyfcajabccc7.southindia-01.azurewebsites.net/api/User/register';

  // Register a new user
  Future<bool> registerUser({
    required String email,
    required String password,
    required String taboos,
    String? userName,
    String language = 'zh-TW',
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Email': email,
          'Password': password,
          'Taboos': taboos,
          if (userName != null) 'UserName': userName,
          'Language': language,
        }),
      );

      if (response.statusCode == 200) {
        print('User registered successfully');
        return true;
      } else {
        print('Failed to register user. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error registering user: $e');
      return false;
    }
  }

