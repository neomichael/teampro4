import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  final Map<String, String>? userInfo;

  const UserInfoPage({Key? key, this.userInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userInfo?['name'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Telephone: ${userInfo?['telephone'] ?? 'N/A'}'),
            SizedBox(height: 10),
            Text('Email: ${userInfo?['email'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}