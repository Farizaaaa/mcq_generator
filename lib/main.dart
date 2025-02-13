import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mcq_generator/bloc/timer_bloc/timer_bloc.dart';
import 'package:mcq_generator/core/ticker.dart';
import 'package:mcq_generator/models/mcq/option_model.dart';
import 'package:mcq_generator/models/mcq/question_model.dart';
import 'package:mcq_generator/pages/mcq_answering_page.dart';
import 'package:mcq_generator/pages/test.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => TimerBloc(ticker: const Ticker())),
        ],
        child: const MaterialApp(
            debugShowCheckedModeBanner: false, home: DeepLinkHandler()));
  }
}

class DeepLinkHandler extends StatefulWidget {
  const DeepLinkHandler({super.key});

  @override
  State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  late final AppLinks _appLinks;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _listenForLinks();
  }

  Future<void> _listenForLinks() async {
    try {
      //handling initial link
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _processDeepLink(initialLink);

        //listening for subsequent links
        _appLinks.uriLinkStream.listen((uri) {
          _processDeepLink(uri);
        });
      }
    } catch (e) {
      debugPrint("Error Handling deep link:$e");
    }
  }

//

  void _processDeepLink(Uri uri) async {
    debugPrint("Deep link received:$uri");

    if (uri.host == "mcq") {
      final topic = uri.queryParameters['topic'];
      debugPrint("topic:$topic");

      if (topic != null) {
        try {
          if (topic == "GM") {
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

            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MCQAnsweringPage(
                  mcqs: mcqs,
                ),
              ),
            );
          } else {
            debugPrint("Unknown Topic");
            Fluttertoast.showToast(msg: "Invalid Topic!");
          }
        } catch (e) {
          debugPrint("Error Processing Deeplink!");
          Fluttertoast.showToast(msg: "Error processing deep link: $e");
        }
      } else {
        debugPrint("Topic not found!!");
        Fluttertoast.showToast(msg: " Topic not Found.");
      }
    } else {
      debugPrint("Unhandled Deeplink host:${uri.host}");
      Fluttertoast.showToast(msg: "Unhandled Deeplink host:${uri.host}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Test();
  }
}
