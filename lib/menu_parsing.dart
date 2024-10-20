import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'api_key.dart'; // Import the API key from a separate file

class MenuParsingPage extends StatefulWidget {
  @override
  _MenuParsingPageState createState() => _MenuParsingPageState(); // Correct method name
}

class _MenuParsingPageState extends State<MenuParsingPage> {
  File? _image;
  String? _webImageUrl;
  List<Map<String, String>> menuItems = [];

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        // For web, show image URL
        setState(() {
          _webImageUrl = pickedFile.path;
        });
      } else {
        // For mobile, show the file
        setState(() {
          _image = File(pickedFile.path);
        });
      }
      _extractTextFromImage(); // Process the image to get menu details
    }
  }

  // Function to extract text from image using GPT
  Future<void> _extractTextFromImage() async {
    // Assuming some kind of API processing with GPT
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/completions'),
      headers: {
        'Authorization': 'Bearer $apiKey',   // Replace with your API key
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "prompt": "Extract food names and prices from this menu image",
        "max_tokens": 150,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final gptResponse = data['choices'][0]['text'];

      // Parse GPT response into food name and price
      List<String> lines = gptResponse.split('\n');
      List<Map<String, String>> parsedItems = [];
      for (var line in lines) {
        if (line.contains('\$')) {
          var parts = line.split(' \$');
          parsedItems.add({"name": parts[0].trim(), "price": '\$${parts[1].trim()}'});
        }
      }

      setState(() {
        menuItems = parsedItems;
      });
    } else {
      print("Failed to process menu: ${response.body}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth * 0.45; // 45% width for image and list

    return Scaffold(
      appBar: AppBar(
        title: Text('解析菜單'),
      ),
      body: Center(
        child: Container(
          width: 800, // Fixed container width similar to the HTML design
          height: 600,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.green, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('原始菜單 (Real Image)', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('辨識結果 (Menu Selection)', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              // Main content
              Expanded(
                child: Row(
                  children: [
                    if (_image != null || _webImageUrl != null)
                    FractionallySizedBox(
                      widthFactor: 1 / 3, // Resize the image to 1/3 of the screen width
                      child: kIsWeb
                        ? Image.network(_webImageUrl!) // For web, display the image URL
                        : Image.file(_image!), // For mobile, display the file image
                    ),
                    // Image display on the left
                    // Container(
                    //   width: containerWidth, // 45% width for image
                    //   child: _image != null
                    //       ? Image.file(_image!, fit: BoxFit.contain)
                    //       : Placeholder(), // Placeholder until image is uploaded
                    // ),
                    SizedBox(width: 20), // Space between image and menu list
                    // Menu list on the right
                    Container(
                      width: containerWidth, // 45% width for list
                      child: ListView.builder(
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          return CheckboxListTile(
                            title: Text(menuItems[index]['name'] ?? ''),
                            value: false, // Placeholder for checkbox value
                            onChanged: (bool? value) {
                              // Handle checkbox state
                            },
                            secondary: Text(menuItems[index]['price'] ?? ''),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              // Buttons section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('菜單拍照上傳 (Upload Photo)'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle details checking
                    },
                    child: Text('檢視餐點詳細 (Check Details)'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  // Add the functionality for adding menu to user list
                },
                child: Text('加入我的菜單 (Add to My Menu)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(150, 40),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
