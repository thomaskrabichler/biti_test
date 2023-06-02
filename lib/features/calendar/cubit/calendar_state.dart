part of 'calendar_cubit.dart';

enum CalendarStatus { initial, updated }

@immutable
class CalendarState extends Equatable {
  const CalendarState({
    this.columns = const [],
    this.status = CalendarStatus.initial,
  });

  final List<DayColumn> columns;
  final CalendarStatus status;

  CalendarState copyWith({
    List<DayColumn>? columns,
    CalendarStatus? status,
  }) {
    return CalendarState(
      columns: columns ?? this.columns,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [columns,status];
}
