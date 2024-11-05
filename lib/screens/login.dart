import 'package:flutter/material.dart';
import 'package:toeic_app/datas/sqflite/db_helper.dart'; // Import the DB helper

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username input
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),

            // Login button
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                if (username.isNotEmpty) {
                  // Save the username in SQLite database
                  await DatabaseHelper().insertUser(username);

                  // Navigate back to the Home screen
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
              ),
              child: Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}
