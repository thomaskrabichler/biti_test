import 'package:biti_test/common/shared/theme/color_palette.dart';
import 'package:biti_test/features/calendar/calendar.dart';
import 'package:biti_test/features/calendar/models/timeframe.dart';
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
              Padding(
                padding: const EdgeInsets.only(top: 25.0, right: 25),
                child: _TimeColumn(),
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
  @override
  Widget build(BuildContext context) {
    const double timeslotHeight = 30;
    const double bottomPadding = 5;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(25, (index) {
        final hour = index == 24 ? '00' : index.toString().padLeft(2, '0');
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
                            color: ColorPalette.lightGrey,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                ...state.columns[index].timeframes.asMap().entries.map((entry) {
                  final int timeframeIndex = entry.key;
                  final Timeframe timeframe = entry.value;

                  final startTime = double.parse(timeframe.startTime);
                  final endTime = double.parse(timeframe.endTime);
                  final position = startTime * (timeslotHeight + bottomPadding);
                  final height = (endTime - startTime) * timeslotHeight;

                  return _ScheduleItem(
                    calendarCubit: context.read<CalendarCubit>(),
                    timeFrameIndex: timeframeIndex,
                    columnIndex: index,
                    timeframe: timeframe,
                    position: position,
                    height: height,
                    timeslotWidth: timeslotWidth,
                    scheduleWidth: scheduleWidth,
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

class _ScheduleItem extends StatefulWidget {
  _ScheduleItem({
    required this.position,
    required this.height,
    required this.timeslotWidth,
    required this.scheduleWidth,
    required this.timeframe,
    required this.columnIndex,
    required this.timeFrameIndex,
    required this.calendarCubit,
  });

  double position;
  final double height;
  final double timeslotWidth;
  final double scheduleWidth;
  final Timeframe timeframe;
  final int columnIndex;
  final int timeFrameIndex;
  final CalendarCubit calendarCubit;

  @override
  State<_ScheduleItem> createState() => _ScheduleItemState();
}

class _ScheduleItemState extends State<_ScheduleItem> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController startController = TextEditingController();
    final TextEditingController endController = TextEditingController();
    return Positioned(
      top: widget.position,
      height: widget.height,
      left: (widget.timeslotWidth - widget.scheduleWidth) / 2,
      width: widget.scheduleWidth,
      child: MouseRegion(
        cursor: SystemMouseCursors.grab,
        child: Draggable(
          onDragStarted: () {},
          onDragUpdate: (details) {
            widget.position += details.delta.dy;
          },
          feedback: Container(),
          child: GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return BlocProvider.value(
                      value: widget.calendarCubit,
                      child: AlertDialog(
                        title: const Text('Update Schedule'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: startController,
                              decoration:
                                  const InputDecoration(hintText: "Start Time"),
                            ),
                            TextField(
                              controller: endController,
                              decoration:
                                  const InputDecoration(hintText: "End Time"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                widget.calendarCubit.updateSchedule(
                                  widget.timeframe.copyWith(
                                    startTime: startController.text,
                                    endTime: endController.text,
                                  ),
                                  widget.columnIndex,
                                  widget.timeFrameIndex,
                                );
                                Navigator.pop(context);
                              },
                              child: const Text('Submit'))
                        ],
                      ),
                    );
                  });
            },
            child: Container(
              decoration: const BoxDecoration(
                color: ColorPalette.purple,
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
          ),
        ),
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
