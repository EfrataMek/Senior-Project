import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'kcal_utils.dart';

class Event {
  final String title;
  final Color? color;
  const Event(this.title, this.color);
}

class Kcalendar extends StatefulWidget {
  const Kcalendar({super.key});

  @override
  State<Kcalendar> createState() => _KcalendarState();
}

class _KcalendarState extends State<Kcalendar> {
  /// Create [EventsController], this is used to add and remove events.
  final eventsController = DefaultEventsController<Event>();

  /// Create [CalendarController],
  final calendarController = CalendarController<Event>();

  final now = DateTime.now();

  /// Decide on a range you want to display.
  late final displayRange = DateTimeRange(
    start: now.subtractDays(363),
    end: now.addDays(365),
  );

  /// Set the initial view configuration.
  late ViewConfiguration viewConfiguration = viewConfigurations[0];

  /// Create a list of view configurations to choose from.
  late final viewConfigurations = <ViewConfiguration>[
    MultiDayViewConfiguration.week(
      displayRange: displayRange,
      firstDayOfWeek: 1,
    ),
    MultiDayViewConfiguration.singleDay(displayRange: displayRange),
    MultiDayViewConfiguration.workWeek(displayRange: displayRange),
    MultiDayViewConfiguration.custom(
      numberOfDays: 3,
      displayRange: displayRange,
    ),
    MonthViewConfiguration.singleMonth(),
    MultiDayViewConfiguration.freeScroll(
      displayRange: displayRange,
      numberOfDays: 4,
      name: "Free Scroll (WIP)",
    ),
  ];

  @override
  void initState() {
    super.initState();
    eventsController.addEvents([
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(const Duration(hours: 1)),
        ),
        data: const Event('My Event', Colors.green),
      ),
      CalendarEvent(
        dateTimeRange: DateTimeRange(
          start: now,
          end: now.add(const Duration(hours: 1)),
        ),
        data: const Event('My Event', Colors.blue),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('My log: Started building the calendar');

    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: Text("mepw"),
            ),
          ),
          Expanded(
            child: CalendarView<Event>(
              eventsController: eventsController,
              calendarController: calendarController,
              viewConfiguration: viewConfiguration,
              // Handle the callbacks made by the calendar.
              callbacks: CalendarCallbacks<Event>(
                onEventTapped: (event, renderBox) =>
                    calendarController.selectEvent(event),
                onEventCreate: (event) => event,
                onEventCreated: (event) => eventsController.addEvent(event),
              ),
              // Customize the components.
              components: CalendarComponents<Event>(
                multiDayComponents: MultiDayComponents(),
                multiDayComponentStyles: MultiDayComponentStyles(),
                monthComponents: MonthComponents(),
                monthComponentStyles: MonthComponentStyles(),
                scheduleComponents: ScheduleComponents(),
                scheduleComponentStyles: const ScheduleComponentStyles(),
              ),
              // Style the header with a martial widget.
              header: Material(
                color: Theme.of(context).colorScheme.surface,
                surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
                elevation: 2,
                child: Column(
                  children: [
                    // Add some useful controls.
                    /* KcalUtils.calendarToolbar(
                          calendarController: calendarController,
                          viewConfiguration: viewConfiguration,
                          viewConfigurations: viewConfigurations,
                          callbackViewConfiguration: (value) {
                            setState(() => viewConfiguration = value);
                          },
                        ), */
                    IconButton.filledTonal(
                      onPressed: () =>
                          calendarController.animateToDate(DateTime.now()),
                      icon: const Icon(Icons.today),
                    ),
                    // Ad display the default header.
                    CalendarHeader<Event>(
                      multiDayTileComponents: KcalUtils.tileComponents(
                        body: false,
                      ),
                    ),
                  ],
                ),
              ),
              body: CalendarBody<Event>(
                multiDayTileComponents: KcalUtils.tileComponents(),
                monthTileComponents: KcalUtils.tileComponents(body: false),
                scheduleTileComponents: KcalUtils.scheduleTileComponents(
                  context,
                ),
                multiDayBodyConfiguration: MultiDayBodyConfiguration(
                  showMultiDayEvents: false,
                ),
                monthBodyConfiguration: MultiDayHeaderConfiguration(),
                scheduleBodyConfiguration: ScheduleBodyConfiguration(),
                snapping: ValueNotifier(
                  CalendarSnapping(
                    snapIntervalMinutes: 1,
                    snapToTimeIndicator: true,
                    snapToOtherEvents: true,
                    snapRange: Duration(minutes: 5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    
    );
    
  }
}
