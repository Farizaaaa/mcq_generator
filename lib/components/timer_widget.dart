import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq_generator/bloc/timer_bloc/timer_bloc.dart';
import 'package:mcq_generator/components/timer_text.dart';
import 'package:mcq_generator/core/constants.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({
    super.key,
    this.autoStart = false,
    this.seconds = 900,
    this.isInstructionPage = false,
  });

  final bool autoStart;
  final int seconds;
  final bool isInstructionPage;

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    return Column(
      children: [
        Container(
          height: 50,
          width: 100,
          padding: const EdgeInsets.only(top: 15),
          decoration: BoxDecoration(
            color: (duration % 2 == 0 && duration < 60)
                ? Colors.black
                : Colors.transparent,
            // border: const Border(
            //   bottom: BorderSide(color: Colors.black, width: 1.0),
            //   left: BorderSide(color: Colors.black, width: 1.0),
            //   right: BorderSide(color: Colors.black, width: 1.0),
            // ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                wBox5,
                Image.asset(
                  (duration % 2 == 0 && duration < 60)
                      ? 'assets/timer_white.png'
                      : 'assets/timer.png',
                  height: 18,
                ),
                isInstructionPage
                    ? Countdown(
                        seconds: seconds,
                        build: (BuildContext context, double time) {
                          int hours = (time / 3600).floor();
                          int minutes = ((time % 3600) / 60).floor();
                          int seconds = (time % 60).floor();

                          String timeString =
                              '${hours < 10 ? '0' : ''}$hours:${minutes < 10 ? '0' : ''}$minutes:${seconds < 10 ? '0' : ''}$seconds';

                          return Text(
                            timeString,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          );
                        },
                        controller: CountdownController(
                          autoStart: autoStart,
                        ),
                        onFinished: () {
                          if (seconds <= 900) {}
                        },
                      )
                    : const TimerText(),
              ],
            ),
          ),
        ),
        hBox12,
      ],
    );
  }
}
