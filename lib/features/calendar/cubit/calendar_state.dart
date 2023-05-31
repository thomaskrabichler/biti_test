part of 'calendar_cubit.dart';

@immutable
class CalendarState extends Equatable {
  const CalendarState({
    this.columns = const [],
    this.weeks = 6,
  });

  final List<DayColumn> columns;
  final int weeks;

  CalendarState copyWith({
    List<DayColumn>? columns,
    int? weeks,
  }) {
    return CalendarState(
      columns: columns ?? this.columns,
      weeks: weeks ?? this.weeks,
    );
  }

  @override
  List<Object> get props => [columns,weeks];
}
