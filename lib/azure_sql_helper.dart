import 'dart:convert';
import 'package:http/http.dart' as http;

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
      final reqBody = {
        'Email': email,
        'Password': password,
        'Taboos': taboos,
        'UserName': userName,
        'Language': language,
      };

      // Debugging: Print the reqBody map and its JSON-encoded form
      print('reqBody (as Dart Map): $reqBody');
      print('reqBody (as JSON): ${jsonEncode(reqBody)}');

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Ensure API can process JSON
        },
        body: jsonEncode(reqBody), // Encode reqBody as JSON
      );
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        // Parse JSON response to check for "register ok"
        final responseData = jsonDecode(response.body);
        if (responseData['message'] == 'User registered successfully.') {
          print('User registered successfully.');
          return 'User registered successfully.';
        } else {
          print('Registration failed: ${responseData['message']}');
          return '${responseData['message']}';
        }
      } else {
        print('Failed to register user. Status code: ${response.statusCode}');
        return '${response.statusCode}';
      }
    } catch (e) {
      print('Error registering user: $e');
      return 'Error: $e';
    }
  }
}
