import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq_generator/bloc/timer_bloc/timer_bloc.dart';
import 'package:mcq_generator/core/ticker.dart';
import 'package:mcq_generator/models/mcq/option_model.dart';
import 'package:mcq_generator/models/mcq/question_model.dart';
import 'package:mcq_generator/pages/mcq_answering_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MCQ> mcqs = [
      MCQ(
        question: "What is the capital of France?",
        options: [
          McqOptionModel(key: 'A', value: 'Paris'),
          McqOptionModel(key: 'B', value: 'London'),
          McqOptionModel(key: 'C', value: 'Berlin'),
          McqOptionModel(key: 'D', value: 'Rome'),
        ],
        answer: 'A',
      ),
      MCQ(
        question: "What is 5 + 3?",
        options: [
          McqOptionModel(key: 'A', value: '5'),
          McqOptionModel(key: 'B', value: '8'),
          McqOptionModel(key: 'C', value: '10'),
          McqOptionModel(key: 'D', value: '7'),
        ],
        answer: 'B',
      ),
    ];
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TimerBloc(ticker: const Ticker())),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: MCQAnsweringPage(mcqs: mcqs)));
  }
}
