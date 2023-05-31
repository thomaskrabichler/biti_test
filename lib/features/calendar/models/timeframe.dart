import 'package:flutter/material.dart';

@immutable
class Timeframe { // (row)
  final String startTime;
  final String endTime;


  // height/duration = 30 (height of 1 hour of time) * (endTime - startTime)

  const Timeframe({
    this.startTime = '',
    this.endTime = '',
  });

  Timeframe copyWith({
    String? startTime,
    String? endTime,
  }) {
    return Timeframe(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
