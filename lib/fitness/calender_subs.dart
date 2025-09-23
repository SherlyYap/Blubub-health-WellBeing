import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class SubscriptionCalendar extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;

  const SubscriptionCalendar({
    super.key,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: startDate,
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month', 
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible:
            false, 
      ),
      rangeStartDay: startDate,
      rangeEndDay: endDate,
      rangeSelectionMode: RangeSelectionMode.toggledOn,
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Colors.lightBlue.withOpacity(0.3),
        todayDecoration: BoxDecoration(
          color: Colors.orangeAccent,
          shape: BoxShape.circle,
        ),
        rangeStartDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
        rangeEndDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          return null;
        },
        rangeStartBuilder:
            (context, day, focusedDay) => _buildMarker(day, Colors.green),
        rangeEndBuilder:
            (context, day, focusedDay) => _buildMarker(day, Colors.red),
      ),
    );
  }

  Widget _buildMarker(DateTime date, Color color) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.black45),
      ),
      child: Text(
        '${date.day}',
        style: GoogleFonts.nunito(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
