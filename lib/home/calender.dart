import 'package:flutter/material.dart';
import 'package:note_app/widget/custom_text.dart';
import 'package:scrollable_clean_calendar/controllers/clean_calendar_controller.dart';
import 'package:scrollable_clean_calendar/scrollable_clean_calendar.dart';
import 'package:scrollable_clean_calendar/utils/enums.dart';

class Calender extends StatelessWidget {
  final calendarController = CleanCalendarController(
    minDate: DateTime.now(),
    maxDate: DateTime.now().add(const Duration(days: 1567)),
    onRangeSelected: (firstDate, secondDate) {},
    onDayTapped: (date) {},
    // readOnly: true,
    onPreviousMinDateTapped: (date) {},
    onAfterMaxDateTapped: (date) {},
    weekdayStart: DateTime.saturday,
    // initialFocusDate: DateTime(2023, 5),
    // initialDateSelected: DateTime(2022, 3, 15),
    // endDateSelected: DateTime(2022, 3, 20),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: CustomText(
          text: 'My  Calendar',
          color: Colors.white,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       calendarController.clearSelectedDates();
        //     },
        //     icon: const Icon(Icons.clear),
        //   )
        // ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.arrow_downward),
      //   onPressed: () {
      //     calendarController.jumpToMonth(date: DateTime(2022, 8));
      //   },
      // ),
      body: ScrollableCleanCalendar(
        calendarController: calendarController,
        layout: Layout.DEFAULT,
        calendarCrossAxisSpacing: 0,
      ),
    );
  }
}
