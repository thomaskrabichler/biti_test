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

    DateTime currentDate = DateTime.now();

DayColumn monday = DayColumn(
  day:'Mandag ${_getDayName(currentDate)}',
  timeframes: mockTimeframes,
);

DayColumn tuesday = DayColumn(
  day: 'Tisdag ${_getDayName(currentDate.add(Duration(days: 1)))}',
  timeframes: mockTimeframes,
);

DayColumn wednesday = DayColumn(
  day: 'Onsdag ${_getDayName(currentDate.add(const Duration(days: 2)))}',
  timeframes: mockTimeframes,
);
DayColumn thursday = DayColumn(
  day: 'Törsdag ${_getDayName(currentDate.add(const Duration(days: 3)))}',
  timeframes: mockTimeframes,
);
DayColumn friday = DayColumn(
  day: 'Fredag ${_getDayName(currentDate.add(const Duration(days: 4)))}',
  timeframes: mockTimeframes,
);
DayColumn saturday = DayColumn(
  day: 'Lördag ${_getDayName(currentDate.add(const Duration(days: 5)))}',
  timeframes: mockTimeframes,
);
DayColumn sunday = DayColumn(
  day: 'Söndag ${_getDayName(currentDate.add(const Duration(days: 6)))}',
  timeframes: mockTimeframesSunday,
);


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
String _getDayName(DateTime date) {
  return '${date.day}/${date.month}';
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

    emit(
      state.copyWith(
        columns: updatedColumns,
      ),
    );
  }
}
