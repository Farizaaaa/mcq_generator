import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq_generator/bloc/timer_bloc/timer_bloc.dart';
import 'package:mcq_generator/components/timer_widget.dart';
import 'package:mcq_generator/models/mcq/question_model.dart';

class MCQAnsweringPage extends StatefulWidget {
  const MCQAnsweringPage({super.key, required this.mcqs});
  @override
  State<MCQAnsweringPage> createState() => _MCQAnsweringPageState();

  final List<MCQ> mcqs;
}

class _MCQAnsweringPageState extends State<MCQAnsweringPage> {
  late List<ValueNotifier<String?>> _selectedOptions;
  bool _isSubmitted = false; // State to track if answers are submitted

  @override
  void initState() {
    super.initState();
    _selectedOptions =
        List.generate(widget.mcqs.length, (_) => ValueNotifier<String?>(null));
    _startTimer();
  }

  void _startTimer() {
    context.read<TimerBloc>().add(
          const TimerStarted(
            duration: 30 * 60,
          ),
        );
  }

  void _submitAnswers() {
    try {
      int score = 0;
      int attended = 0;

      for (int i = 0; i < widget.mcqs.length; i++) {
        if (_selectedOptions[i].value != null) {
          attended++;
          if (_selectedOptions[i].value == widget.mcqs[i].answer) {
            score++;
          }
        }
      }

      int notAttended = widget.mcqs.length - attended;

      // Update state to show the answer key
      setState(() {
        _isSubmitted = true;
      });

      // Show the score in a styled dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: const Center(
              child: Text(
                'Exam Result',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Divider(thickness: 1.2),
                _buildResultRow('Attended', attended, Colors.blue),
                _buildResultRow('Not Attended', notAttended, Colors.red),
                _buildResultRow('Total Marks', widget.mcqs.length, Colors.grey),
                _buildResultRow('Marks', score, Colors.green),
                Text(
                  "You Scored $score out of ${widget.mcqs.length}",
                  style: const TextStyle(fontSize: 15),
                ),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildResultRow(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            child: widget.mcqs.isNotEmpty
                ? Padding(
                    padding:
                        const EdgeInsets.only(top: 50, right: 10, left: 30),
                    child: ListView.builder(
                      itemCount: widget.mcqs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final mcq = widget.mcqs[index];
                        final valueNotifier = _selectedOptions[index];
                        return ValueListenableBuilder<String?>(
                          valueListenable: valueNotifier,
                          builder: (context, selectedValue, _) {
                            return Card(
                              margin: const EdgeInsets.all(10),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mcq.question,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Column(
                                      children: mcq.options.map((option) {
                                        bool isCorrectAnswer =
                                            option.key == mcq.answer;
                                        bool isSelected =
                                            selectedValue == option.key;

                                        return GestureDetector(
                                          onTap: !_isSubmitted
                                              ? () {
                                                  if (selectedValue ==
                                                      option.key) {
                                                    valueNotifier.value = null;
                                                  } else {
                                                    valueNotifier.value =
                                                        option.key;
                                                  }
                                                }
                                              : null, // Disable interaction after submission
                                          child: ListTile(
                                            title: Text(
                                              option.value,
                                              style: TextStyle(
                                                color: _isSubmitted
                                                    ? isCorrectAnswer
                                                        ? Colors
                                                            .green // Green for correct answer
                                                        : isSelected
                                                            ? Colors
                                                                .blue // Blue for selected answer
                                                            : Colors.black
                                                    : Colors
                                                        .black, // Default color for others
                                              ),
                                            ),
                                            leading: Radio<String?>(
                                              value: option.key,
                                              groupValue: selectedValue,
                                              onChanged:
                                                  null, // Disable radio after submission
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    if (_isSubmitted)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          "Correct Answer: ${mcq.options.firstWhere((option) => option.key == mcq.answer).value}",
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 30.0, left: 40),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "GM",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: TimerWidget(),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: !_isSubmitted ? _submitAnswers : _navigateBackToLoka,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child:
                      !_isSubmitted ? const Text('Submit') : const Text("Back"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateBackToLoka() {
    log("Back");
  }
}
