import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class ListeningQuizPart3 extends StatefulWidget {
  final int duration; // Duration passed from ListeningTestScreen

  ListeningQuizPart3({Key? key, required this.duration}) : super(key: key);

  @override
  _Part3QuizScreenState createState() => _Part3QuizScreenState();
}

class _Part3QuizScreenState extends State<ListeningQuizPart3> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer; // Timer for countdown

  int _remainingTime = 0; // Set the countdown time in seconds
  bool _showResults = false; // Track if results should be shown
  int _correctAnswers = 0; // Store the number of correct answers
  int _currentPageIndex = 0; // Track current page index

  // Sample data for Part 3
  final List<Map<String, dynamic>> questions = [
    {
      'image': 'assets/images/owl.png',
      'audio': 'assets/part3_audio.mp3',
      'questions': [
        {
          'text': 'Question 1',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'correctAnswer': 'Option B',
          'selectedAnswer': null,
        },
        {
          'text': 'Question 2',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'correctAnswer': 'Option D',
          'selectedAnswer': null,
        },
        {
          'text': 'Question 3',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'correctAnswer': 'Option A',
          'selectedAnswer': null,
        },
      ],
    },
    {
      'image': 'assets/part3_image.jpg',
      'audio': 'assets/part3_audio.mp3',
      'questions': [
        {
          'text': 'Question 1',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'correctAnswer': 'Option B',
          'selectedAnswer': null,
        },
        {
          'text': 'Question 2',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'correctAnswer': 'Option D',
          'selectedAnswer': null,
        },
        {
          'text': 'Question 3',
          'options': ['Option A', 'Option B', 'Option C', 'Option D'],
          'correctAnswer': 'Option A',
          'selectedAnswer': null,
        },
      ],
    },
  ];

  // Method to play audio
  void _playAudio(String audioPath) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(audioPath, isLocal: true);
  }

  // Handle answer selection
  void _onAnswerSelected(int pageIndex, int questionIndex, String answer) {
    if (!_showResults) {
      setState(() {
        questions[pageIndex]['questions'][questionIndex]['selectedAnswer'] = answer;
      });
    }
  }

  // Submit answers and calculate results
  void _submitAnswers() {
    _correctAnswers = 0;
    for (var page in questions) {
      for (var question in page['questions']) {
        if (question['selectedAnswer'] == question['correctAnswer']) {
          _correctAnswers++;
        }
      }
    }

    // Stop the timer if it's running
    _timer?.cancel();

    // Display results in dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Quiz Completed"),
        content: Text("You got $_correctAnswers out of ${questions.length * questions[0]['questions'].length} correct!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
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

  // Start the countdown timer
  void _startTimer() {
    _remainingTime = widget.duration; // Use the duration passed from the constructor
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime <= 0) {
        _timer?.cancel();
        _submitAnswers(); // Auto submit when time is up
      } else {
        setState(() {
          _remainingTime--; // Decrement remaining time
        });
      }
    });
  }

  // Get the color for each option based on answer selection
  Color? _getOptionColor(int pageIndex, int questionIndex, String option) {
    if (_showResults) {
      if (questions[pageIndex]['questions'][questionIndex]['correctAnswer'] == option) {
        return Colors.green; // Correct answer
      } else if (questions[pageIndex]['questions'][questionIndex]['selectedAnswer'] == option) {
        return Colors.red[200]; // Incorrect selected answer
      }
      return Colors.grey; // Default color for unselected options
    } else {
      return questions[pageIndex]['questions'][questionIndex]['selectedAnswer'] == option ? Colors.blue : null;
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the timer when the screen initializes
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer if it's running
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Quiz - Part 3'),
      ),
      body: Column(
        children: [
          // Countdown Timer
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Time Remaining: $_remainingTime s',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // Page Indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(questions.length, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  width: 10,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPageIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
          Expanded(
            child: PageView.builder(
              itemCount: questions.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index; // Update current page index
                });
              },
              itemBuilder: (context, pageIndex) {
                final questionSet = questions[pageIndex];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(questionSet['image'], height: 150),
                      SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () => _playAudio(questionSet['audio']),
                        icon: Icon(Icons.play_arrow),
                        label: Text("Play Audio"),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: ListView.builder(
                          itemCount: questionSet['questions'].length,
                          itemBuilder: (context, questionIndex) {
                            final question = questionSet['questions'][questionIndex];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  question['text'],
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 10),
                                for (var option in question['options'])
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                                    child: ElevatedButton(
                                      onPressed: () => _onAnswerSelected(pageIndex, questionIndex, option),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: _getOptionColor(pageIndex, questionIndex, option),
                                      ),
                                      child: Text(option),
                                    ),
                                  ),
                                SizedBox(height: 20),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showResults ? () {
          Navigator.pop(context); // Go back to previous screen
        } : _submitAnswers,
        child: Icon(_showResults ? Icons.arrow_back : Icons.check),
        tooltip: _showResults ? 'Return to Menu' : 'Submit Answers',
      ),
    );
  }
}
