import 'package:flutter/material.dart';

import '../datas/sqflite/db_helper.dart';
import 'login.dart'; // Import the login screen
import 'menu.dart'; // Import the menu screen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  // Load the username from SQLite database
  Future<void> _loadUser() async {
    String? username = await DatabaseHelper().getUser();
    setState(() {
      _username = username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Text
              Text(
                _username != null ? 'Welcome back, $_username' : 'WELCOME TO ELAST',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              SizedBox(height: 20),

              // Owl Image
              Image.asset(
                'assets/images/owl.png', // Ensure owl.png is in the assets folder
                height: 200,
              ),
              SizedBox(height: 40),

              // Show "START" button if user is logged in, otherwise show "LOGIN" button
              _username != null
                  ? ElevatedButton(
                onPressed: () {
                  // Navigate to the MenuScreen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'START',
                  style: TextStyle(fontSize: 18),
                ),
              )
                  : ElevatedButton(
                onPressed: () {
                  // Navigate to Login screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  ).then((value) => _loadUser()); // Reload user after login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'LOGIN',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
