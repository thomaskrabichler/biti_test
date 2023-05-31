part of 'calendar_cubit.dart';

@immutable
class CalendarState extends Equatable {
  const CalendarState({
    this.columns = const [],
  });

  final List<DayColumn> columns;

  CalendarState copyWith({
    List<DayColumn>? columns,
  }) {
    return CalendarState(
      columns: columns ?? this.columns,
    );
  }

  @override
  List<Object> get props => [columns];
}
