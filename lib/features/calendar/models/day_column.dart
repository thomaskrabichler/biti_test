import 'package:biti_test/features/calendar/models/timeframe.dart';
import 'package:flutter/material.dart';

@immutable
class DayColumn {
  final List<Timeframe> timeframes;
  final String day;

  const DayColumn({
    this.day = '',
    this.timeframes = const [],
  });

  DayColumn copyWith({
    List<Timeframe>? timeframes,
    String? day,
  }) {
    return DayColumn(
      timeframes: timeframes ?? this.timeframes,
      day: day ?? this.day,
    );
  }
}
