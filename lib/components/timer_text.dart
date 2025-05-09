import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mcq_generator/bloc/timer_bloc/timer_bloc.dart';

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final hoursStr = (duration / 3600).floor().toString().padLeft(2, '0');
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      '$hoursStr:$minutesStr:$secondsStr',
      style: TextStyle(
          fontSize: 16,
          color: (duration % 2 == 0 && duration < 60)
              ? Colors.white
              : Colors.black),
    );
  }
}
