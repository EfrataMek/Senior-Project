import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SYncCalendar extends StatefulWidget {
  const SYncCalendar({super.key});

  @override
  State<SYncCalendar> createState() => _SYncCalendarPageState();
}

class _SYncCalendarPageState extends State<SYncCalendar> {
  late MeetingDataSource _events;

  @override
  void initState() {
    super.initState();
    _events = MeetingDataSource([]);
  }

  void _addAppointment(DateTime startTime) {
    final newAppointment = Appointment(
      startTime: startTime,
      endTime: startTime.add(Duration(hours: 1)),
      subject: 'New Event',
      color: Colors.green,
    );

    setState(() {
      _events.appointments!.add(newAppointment);
      _events.notifyListeners(CalendarDataSourceAction.add, [newAppointment]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Week View Calendar')),
      body: SfCalendar(
        view: CalendarView.week,
        dataSource: _events,
        allowDragAndDrop: true,
        allowAppointmentResize: true,
        showDatePickerButton: true,
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.calendarCell &&
              details.date != null) {
            _addAppointment(details.date!);
          }
        },
        onAppointmentResizeEnd: (AppointmentResizeEndDetails details) {
          final Appointment resized = details.appointment;
          resized.startTime = details.startTime!;
          resized.endTime = details.endTime!;
          setState(() {
            _events.notifyListeners(
              CalendarDataSourceAction.reset,
              _events.appointments!,
            );
          });
        },
        onDragEnd: (AppointmentDragEndDetails details) {
          setState(() {
            _events.notifyListeners(
              CalendarDataSourceAction.reset,
              _events.appointments!,
            );
          });
        },
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}