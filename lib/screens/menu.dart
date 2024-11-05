import 'package:flutter/material.dart';
import '../datas/sqflite/db_helper.dart';
import 'listening_test_menu.dart';


class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
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
    return Scaffold(
      backgroundColor: Color(0xFFB3C7E6), // Light blue background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/profile.jpg'), // Add user profile image here
              radius: 20,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _username ?? 'Student', // Display username if available, otherwise default to 'Student'
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Main Test Card
            buildTestCard(
              icon: Icons.settings,
              title: 'Tests',
              score: '26/30',
              scoreColor: Colors.redAccent,
            ),
            SizedBox(height: 10),

            // Reading Test Card with Navigation to ListeningTestScreen
            buildTestCard(
              icon: Icons.menu_book,
              title: 'Reading test',
              score: '20/30',
              scoreColor: Colors.amber,
              onTap: () {
                // Navigate to ListeningTestScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ListeningTestScreen()),
                );
              },
            ),
            SizedBox(height: 10),

            // Listening Test Card
            buildTestCard(
              icon: Icons.hearing,
              title: 'Listening Test',
              score: '25/30',
              scoreColor: Colors.lightBlue,
            ),
            SizedBox(height: 10),

            // Vocabulary Test Card
            buildTestCard(
              icon: Icons.language,
              title: 'Vocabulary',
              score: '27/30',
              scoreColor: Colors.blueAccent,
            ),
            Spacer(),
            Text('History', style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget buildTestCard({
    required IconData icon,
    required String title,
    required String score,
    required Color scoreColor,
    VoidCallback? onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: scoreColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            score,
            style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: onTap, // Use onTap callback to handle navigation
      ),
    );
  }
}