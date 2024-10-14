// api_helper.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiHelper {
  Future<void> insertCustomer(String name, String tele, String email) async {
    final String apiUrl = 'YOUR_API_ENDPOINT_HERE'; // Replace with your actual API endpoint

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'telephone': tele,
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        print('Customer inserted successfully');
      } else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        throw Exception('Failed to insert customer. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch any errors that occur during the API call
      print('Error inserting customer: $e');
      throw Exception('Failed to insert customer: $e');
    }
  }
}