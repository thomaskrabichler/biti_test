import 'package:biti_test/features/calendar/models/day_column.dart';
import 'package:biti_test/features/calendar/models/timeframe.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calendar_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(const CalendarState());

  void initCalendar() {
    final mockTimeframes = [
      const Timeframe(startTime: '7', endTime: '8'),
      const Timeframe(startTime: '14', endTime: '16.5'),
    ];
    final mockTimeframesSunday = [
      const Timeframe(startTime: '7', endTime: '8'),
      const Timeframe(startTime: '14', endTime: '16.5'),
      const Timeframe(startTime: '18', endTime: '22.5'),
      const Timeframe(startTime: '5', endTime: '6'),
    ];
   DayColumn monday = DayColumn(day: 'Monday', timeframes: mockTimeframes);
   DayColumn tuesday = DayColumn(day: 'Tuesday', timeframes: mockTimeframes);
   DayColumn wednesday =
       DayColumn(day: 'Wednesday', timeframes: mockTimeframes);
   DayColumn thursday = DayColumn(day: 'Thursday', timeframes: mockTimeframes);
   DayColumn friday = DayColumn(day: 'Friday', timeframes: mockTimeframes);
   DayColumn saturday = DayColumn(day: 'Saturday', timeframes: mockTimeframes);
    DayColumn sunday =
        DayColumn(day: 'Sunday', timeframes: mockTimeframesSunday);

    emit(state.copyWith(columns: [
      monday,
      tuesday,
      wednesday,
      thursday,
      friday,
      saturday,
      sunday
    ]));
  }
}
