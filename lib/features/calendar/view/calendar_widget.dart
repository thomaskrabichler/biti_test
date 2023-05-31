import 'package:biti_test/features/calendar/calendar.dart';
import 'package:biti_test/features/profile/profile.dart';
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
          return Container(
            width: double.infinity,
            height: 900,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: state.columns.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: _DayColumn(
                    state: state,
                    index: index,
                  ),
                );
              },
            ),
          );
        },
      ),
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
    const double greyItemHeight = 30;
    const double greyItemWidth = 140;
    const double scheduleWidth = greyItemWidth * 0.8;
    const double bottomPadding = 5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(column.day),
        SizedBox(
          width: greyItemWidth,
          child: Stack(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: 24,
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
                          height: greyItemHeight,
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
                    (greyItemHeight + bottomPadding);

                final height = (endTime - startTime) * greyItemHeight;
                return Positioned(
                  top: position,
                  height: height,
                  left: (greyItemWidth - scheduleWidth) / 2,
                  width: scheduleWidth,
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.purpleAccent,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: const Center(child: Text('BP')),
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
