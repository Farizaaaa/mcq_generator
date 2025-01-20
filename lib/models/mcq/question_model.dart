import 'package:mcq_generator/models/mcq/option_model.dart';

class MCQ {
  final String question;
  final List<McqOptionModel> options;
  final String answer;
  MCQ({
    required this.question,
    required this.options,
    required this.answer,
  });
  // Factory constructor to create an MCQ object from JSON
  factory MCQ.fromJson(Map<String, dynamic> json) {
    print('Parsing MCQ from JSON: \$json');
    return MCQ(
      question: json['question'],
      options: (json['options'] as Map<String, dynamic>)
          .entries
          .map((entry) => McqOptionModel(key: entry.key, value: entry.value))
          .toList(),
      answer: json['answer'],
    );
  }
  // Method to convert MCQ object to JSON
  Map<String, dynamic> toJson() {
    final json = {
      'question': question,
      'options': {for (var option in options) option.key: option.value},
      'answer': answer,
    };
    print('Converting MCQ to JSON: \$json');
    return json;
  }
}
