import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class ListeningQuizPart1 extends StatefulWidget {
  @override
  _Part1QuizScreenState createState() => _Part1QuizScreenState();
}

class _Part1QuizScreenState extends State<ListeningQuizPart1> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final List<Map<String, dynamic>> questions = [
    {
      "image": 'assets/image1.png',
      "audio": 'assets/audio1.mp3',
      "options": ["Option 1A", "Option 1B", "Option 1C", "Option 1D"],
      "answer": "Option 1B",
    },
    {
      "image": 'assets/image2.png',
      "audio": 'assets/audio2.mp3',
      "options": ["Option 2A", "Option 2B", "Option 2C", "Option 2D"],
      "answer": "Option 2C",
    },
    {
      "image": 'assets/image3.png',
      "audio": 'assets/audio3.mp3',
      "options": ["Option 3A", "Option 3B", "Option 3C", "Option 3D"],
      "answer": "Option 3A",
    },
  ];

  final Map<int, String> selectedAnswers = {};
  bool _showResults = false;

  void _playAudio(String audioPath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(audioPath, isLocal: true);
    print("Playing audio: $audioPath");
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _showResultDialog() {
    int correctAnswers = 0;
    for (int i = 0; i < questions.length; i++) {
      if (selectedAnswers[i] == questions[i]['answer']) {
        correctAnswers++;
      }
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Result"),
        content: Text("You got $correctAnswers out of ${questions.length} correct!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close result dialog
              setState(() {
                _showResults = true; // Show results on buttons
              });
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  void _confirmSubmitAnswers() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Submit Answers"),
        content: Text("Are you sure you want to submit your answers?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation dialog
              _showResultDialog(); // Show result dialog
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
  }

  Color? _getOptionColor(int questionIndex, String option) {
    if (_showResults) {
      // In results state
      if (questions[questionIndex]["answer"] == option) {
        return Colors.green; // Correct answer
      } else if (selectedAnswers[questionIndex] == option) {
        return Colors.red[200]; // Incorrect selected answer
      }
      return Colors.grey; // Default color for unselected options
    } else {
      // Before submission: Highlight selected answer in blue
      return selectedAnswers[questionIndex] == option ? Colors.blue : Colors.grey[200];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Quiz - Part 1'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...List.generate(questions.length, (index) {
                final question = questions[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Question ${index + 1}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        height: 150,
                        child: Image.asset(
                          question["image"],
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _playAudio(question["audio"]),
                      icon: Icon(Icons.play_arrow),
                      label: Text("Play Audio"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20),
                    for (var option in question["options"])
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedAnswers[index] = option; // Store selected answer
                              print("Selected answer for question $index: $option");
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getOptionColor(index, option),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(option),
                        ),
                      ),
                    Divider(height: 40),
                  ],
                );
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_showResults) {
                    Navigator.of(context).pop(); // Return to menu if results are shown
                  } else {
                    _confirmSubmitAnswers(); // Confirm submission otherwise
                  }
                },
                child: Text(_showResults ? "Return to Menu" : "Submit Answers"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
