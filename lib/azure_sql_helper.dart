import 'package:http/http.dart' as http;
import 'dart:convert';

class AzureSqlHelper {
  // Singleton instance
  static final AzureSqlHelper _instance = AzureSqlHelper._privateConstructor();
  factory AzureSqlHelper() => _instance;
  AzureSqlHelper._privateConstructor();

  // API endpoint
  final String _apiUrl =
      'https://gai243aifoodie20241014-d0dtgyfcajabccc7.southindia-01.azurewebsites.net/api/User/register';

  // Register a new user and test connection
  Future<String> registerUser({
    required String email,
    required String password,
    required String taboos,
    required String userName,
    required String language,
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
        // Parse JSON response to check for "register ok"
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'register ok') {
          print('User registered successfully: register ok');
          return 'register ok';
        } else {
          print('Registration failed: ${responseData['message']}');
          return 'Registration failed: ${responseData['message']}';
        }
      } else {
        print('Failed to register user. Status code: ${response.statusCode}');
        return 'Failed with status: ${response.statusCode}';
      }
    } catch (e) {
      print('Error registering user: $e');
      return 'Error: $e';
    }
  }
}
