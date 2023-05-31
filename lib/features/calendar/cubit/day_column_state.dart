part of 'day_column_cubit.dart';

@immutable
class DayColumnState extends Equatable {
  const DayColumnState({
    this.timeframes = const [],
  });

  final List<Timeframe> timeframes;

  DayColumnState copyWith({
    List<Timeframe> Function()? timeframes,
  }) {
    return DayColumnState(
      timeframes: timeframes != null ? timeframes() : this.timeframes,
    );
  }

  @override
  List<Object> get props => [timeframes];
}
