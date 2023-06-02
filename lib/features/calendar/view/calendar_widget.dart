import 'package:biti_test/common/shared/theme/color_palette.dart';
import 'package:biti_test/features/calendar/calendar.dart';
import 'package:biti_test/features/calendar/models/timeframe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarWidget extends StatelessWidget {
  final double availableWidth;
  const CalendarWidget({super.key, required this.availableWidth});

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
                padding: const EdgeInsets.only(top: 32.0, right: 25),
                child: _TimeColumn(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceEvenly, // Adjust the spacing based on your preference

                children: List.generate(
                  7,
                  // state.columns.length,
                  (index) => _DayColumn(
                    state: state,
                    index: index,
                    availableWidth: availableWidth,
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
    required this.availableWidth,
  }) : super(key: key);
  final CalendarState state;
  final int index;
  final double availableWidth;
  @override
  Widget build(BuildContext context) {
    final column = state.columns[index];
    const double timeslotHeight = 30;
    const double scheduleWidthPercentage = 0.8;
    const double bottomPadding = 5;

    final timeslotWidth = availableWidth / 7; // 6% of the screen width
    final scheduleWidth = timeslotWidth * scheduleWidthPercentage;
    print(availableWidth);
    return Padding(
      padding: EdgeInsets.only(right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            column.day,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            // width: timeslotWidth,
            child: SizedBox(
              width: timeslotWidth,
              child: Stack(
                children: [
                  SizedBox(
                    width: timeslotWidth,
                    child: ListView.builder(
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
                  ),
                  ...state.columns[index].timeframes
                      .asMap()
                      .entries
                      .map((entry) {
                    final int timeframeIndex = entry.key;
                    final Timeframe timeframe = entry.value;

                    final startTime = double.parse(timeframe.startTime);
                    final endTime = double.parse(timeframe.endTime);
                    final position =
                        startTime * (timeslotHeight + bottomPadding);
                    final height = ((endTime - startTime) *
                            (timeslotHeight + bottomPadding)) +
                        timeslotHeight;

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
  late double currentPosition;
  final double snapIncrement = 35.0; //timeframeHeight (1h)
  late double endPosition;
  late ValueNotifier<Rect> draggableArea;
  late TextEditingController startTimeController;
  late TextEditingController endTimeController;

  @override
  void initState() {
    super.initState();

    startTimeController = TextEditingController();
    endTimeController = TextEditingController();
    currentPosition = widget.position;
  }

  ValueNotifier<Rect> _getDraggableArea(int timeframeIndex) {
    final Rect initialRect = Rect.fromLTWH(
      (widget.timeslotWidth - widget.scheduleWidth) / 2,
      widget.position,
      widget.scheduleWidth,
      widget.height,
    );

    final ValueNotifier<Rect> draggableArea = ValueNotifier(initialRect);

    return draggableArea;
  }

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Rect> draggableArea =
        _getDraggableArea(widget.timeFrameIndex);

    return ValueListenableBuilder<Rect>(
      valueListenable: draggableArea,
      builder: (context, value, _) {
        return Positioned.fromRect(
          rect: value,
          child: MouseRegion(
            cursor: SystemMouseCursors.grab,
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
                              controller: startTimeController,
                              decoration: const InputDecoration(
                                  hintText: "Start (e.g. 0,1,2,..24)"),
                            ),
                            TextField(
                              controller: endTimeController,
                              decoration: const InputDecoration(
                                  hintText: "End (e.g. 0,1,2,..24)"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              widget.calendarCubit.updateSchedule(
                                widget.timeframe.copyWith(
                                  startTime: startTimeController.text,
                                  endTime: endTimeController.text,
                                ),
                                widget.columnIndex,
                                widget.timeFrameIndex,
                              );
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: const Duration(seconds: 1),
                                  content: Text('Schedule updated'),
                                ),
                              );
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              onPanEnd: (details) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text('Schedule updated'),
                  ),
                );
              },
              onPanUpdate: (details) {
                currentPosition += details.delta.dy;
                final snappedPosition =
                    (currentPosition / snapIncrement).round() * snapIncrement;
                endPosition = snappedPosition;
                final newRect = Rect.fromLTWH(
                  (widget.timeslotWidth - widget.scheduleWidth) / 2,
                  snappedPosition,
                  widget.scheduleWidth,
                  widget.height,
                );
                draggableArea.value = newRect;
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorPalette.purple,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'BP',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
