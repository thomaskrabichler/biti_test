import 'package:biti_test/features/calendar/models/day_column.dart';
import 'package:biti_test/features/calendar/models/timeframe.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      const Timeframe(startTime: '14', endTime: '17'),
      const Timeframe(startTime: '18', endTime: '23'),
      const Timeframe(startTime: '5', endTime: '5.5'),
    ];
    DayColumn monday = DayColumn(day: 'Mandag', timeframes: mockTimeframes);
    DayColumn tuesday = DayColumn(day: 'Tisdag', timeframes: mockTimeframes);
    DayColumn wednesday = DayColumn(day: 'Onsdag', timeframes: mockTimeframes);
    DayColumn thursday = DayColumn(day: 'Törsdag', timeframes: mockTimeframes);
    DayColumn friday = DayColumn(day: 'Fredag', timeframes: mockTimeframes);
    DayColumn saturday = DayColumn(day: 'Lördag', timeframes: mockTimeframes);
    DayColumn sunday =
        DayColumn(day: 'Söndag', timeframes: mockTimeframesSunday);

    emit(
      state.copyWith(
        columns: [
          monday,
          tuesday,
          wednesday,
          thursday,
          friday,
          saturday,
          sunday,
        ],
      ),
    );
  }

  void updateSchedule(
    Timeframe timeframe,
    int columnIndex,
    int timeframeIndex,
  ) {
    final startTime = timeframe.startTime;
    final endTime = timeframe.endTime;
    if (startTime.isEmpty || endTime.isEmpty) return;


    final List<DayColumn> updatedColumns = List.from(state.columns);
    final DayColumn column = updatedColumns[columnIndex];

    final Timeframe updatedTimeframe =
        column.timeframes[timeframeIndex].copyWith(
      startTime: startTime,
      endTime: endTime,
    );
    final List<Timeframe> updatedTimeframes = List.from(column.timeframes);
    updatedTimeframes[timeframeIndex] = updatedTimeframe;

    final DayColumn updatedColumn = column.copyWith(
      timeframes: updatedTimeframes,
    );

    updatedColumns[columnIndex] = updatedColumn;

    emit(state.copyWith(columns: updatedColumns));
  }
}
