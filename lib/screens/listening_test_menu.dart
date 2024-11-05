import 'package:flutter/material.dart';
import 'listening_quiz_part1.dart';
import 'listening_quiz_part3.dart'; // Import the ListeningQuizPart3

class ListeningTestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Test'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            buildPartCard(context, 'Part 1', Icons.looks_one, ListeningQuizPart1()), // Navigate to ListeningQuizPart1 for Part 1
            SizedBox(height: 10),
            buildPartCard(context, 'Part 2', Icons.looks_two, null),
            SizedBox(height: 10),
            buildPartCard(context, 'Part 3', Icons.looks_3, null), // No direct navigation yet
            SizedBox(height: 10),
            buildPartCard(context, 'Part 4', Icons.looks_4, null),
          ],
        ),
      ),
    );
  }

  Widget buildPartCard(BuildContext context, String partName, IconData icon, Widget? nextScreen) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, size: 30, color: Colors.grey[700]),
        title: Text(
          partName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          if (nextScreen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextScreen),
            );
          } else if (partName == 'Part 3') {
            _showTimeInputDialog(context); // Show time input dialog for Part 3
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('This part is not yet implemented.')),
            );
          }
        },
      ),
    );
  }

  void _showTimeInputDialog(BuildContext context) {
    final TextEditingController _controller = TextEditingController(); // Controller for the TextField

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter Countdown Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Please enter the time in seconds:'),
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'e.g., 30',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String? inputText = _controller.text;
                if (inputText != null && inputText.isNotEmpty) {
                  int? inputTime = int.tryParse(inputText); // Convert to int
                  if (inputTime != null && inputTime > 0) {
                    Navigator.of(context).pop(); // Close the dialog
                    _navigateToPart3(context, inputTime); // Navigate to Part 3 with input time
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter a valid positive number.')),
                    );
                  }
                }
              },
              child: Text('Start Quiz'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPart3(BuildContext context, int selectedTime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListeningQuizPart3(duration: selectedTime), // Pass selected duration
      ),
    );
  }
}
