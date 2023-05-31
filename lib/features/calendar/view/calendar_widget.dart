import 'package:biti_test/features/calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CalendarCubit()..initCalendar(),
      child: BlocBuilder<CalendarCubit, CalendarState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding:  EdgeInsets.only(top: 25.0, right: 25),
                child:  _TimeColumn(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      state.columns.length,
                      (index) => _DayColumn(state: state, index: index),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  const _TimeColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
      const double timeslotHeight = 30;
      const double bottomPadding = 5;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(25, (index) {
        final hour =
            index == 24 ? '00' : index.toString().padLeft(2, '0');
        return SizedBox(
          height: timeslotHeight + bottomPadding,
          child: Text('$hour:00'),
        );
      }),
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    Key? key,
    required this.state,
    required this.index,
  }) : super(key: key);
  final CalendarState state;
  final index;

  @override
  Widget build(BuildContext context) {
    final column = state.columns[index];
    const double timeslotHeight = 30;
    const double timeslotWidth = 140;
    const double scheduleWidth = timeslotWidth * 0.8;
    const double bottomPadding = 5;

    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DayTitle(title: column.day),
          SizedBox(
            width: timeslotWidth,
            child: Stack(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    return MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: bottomPadding,
                          ),
                          child: Container(
                            height: timeslotHeight,
                            color: Colors.grey[200],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ...state.columns[index].timeframes.map((timeframe) {
                  final startTime = double.parse(timeframe.startTime);
                  final endTime = double.parse(timeframe.endTime);
                  final position = double.parse(timeframe.startTime) *
                      (timeslotHeight + bottomPadding);
// RECALCULATE 7 - 8 SHOULD FILL OUT 8 ASWELL
                  final height = (endTime - startTime) * timeslotHeight;
                  return Positioned(
                    top: position,
                    height: height,
                    left: (timeslotWidth - scheduleWidth) / 2,
                    width: scheduleWidth,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'BP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DayTitle extends StatelessWidget {
  const DayTitle({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}
