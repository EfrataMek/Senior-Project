import 'package:calendar/kcalendar.dart';
import 'package:flutter/material.dart';
import 'package:kalender/kalender.dart';
import 'dart:io';

class KcalUtils {
  static Color get color => Colors.amber;
  static BorderRadius get radius => BorderRadius.circular(8);

  static TileComponents<Event> tileComponents({bool body = true}) {
    return TileComponents<Event>(
      tileBuilder: (event, tileRange) {
        return Container(
          decoration: BoxDecoration(
            color: event.data?.color ?? color,
            borderRadius: radius,
            border: Border.all(color: Colors.brown, width: 2),
          ),
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 1),
            color: color,
            elevation: 10,
            shadowColor: Colors.red,
            child: Text(event.data?.title ?? ""),
          ),
        );
      },
      dropTargetTile: (event) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: radius,
        ),
      ),
      feedbackTileBuilder: (event, dropTargetWidgetSize) => AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: dropTargetWidgetSize.width * 0.8,
        height: dropTargetWidgetSize.height,
        decoration: BoxDecoration(
          color: color.withAlpha(100),
          borderRadius: radius,
        ),
      ),
      tileWhenDraggingBuilder: (event) => Container(
        decoration: BoxDecoration(
          color: color.withAlpha(80),
          borderRadius: radius,
        ),
      ),
      dragAnchorStrategy: pointerDragAnchorStrategy,
    );
  }

  static ScheduleTileComponents<Event> scheduleTileComponents(
    BuildContext context,
  ) {
    return ScheduleTileComponents<Event>(
      tileBuilder: (event, tileRange) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 1),
          color: color,
          child: Text(event.data?.title ?? ""),
        );
      },
      dropTargetTile: (event) => DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
            width: 2,
          ),
          borderRadius: radius,
        ),
      ),
    );
  }

  static Widget calendarToolbar({
    required CalendarController calendarController,
    required ViewConfiguration viewConfiguration,
    required List<ViewConfiguration> viewConfigurations,
    required void Function(ViewConfiguration) callbackViewConfiguration,
  }) {
    debugPrint('My log: Enter the header toolbar');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                ValueListenableBuilder(
                  valueListenable: calendarController.visibleDateTimeRangeUtc,
                  builder: (context, value, child) {
                    final String month;
                    final int year;
                    debugPrint('My log: enter the value listener');
                    if (viewConfiguration is MonthViewConfiguration) {
                      // Since the visible DateTimeRange returned by the month view does not always start at the beginning of the month,
                      // we need to check the second week of the visibleDateTimeRange to determine the month and year.
                      final secondWeek = value.start.addDays(7);
                      year = secondWeek.year;
                      month = secondWeek.monthNameLocalized();
                    } else {
                      year = value.start.year;
                      month = value.start.monthNameLocalized();
                    }
                    return FilledButton.tonal(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(160, kMinInteractiveDimension),
                      ),
                      child: Text('$month $year'),
                    );
                  },
                ),
              ],
            ),
          ),

          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToPreviousPage(),
              icon: const Icon(Icons.chevron_left),
            ),
          if (!Platform.isAndroid && !Platform.isIOS)
            IconButton.filledTonal(
              onPressed: () => calendarController.animateToNextPage(),
              icon: const Icon(Icons.chevron_right),
            ),
          IconButton.filledTonal(
            onPressed: () => calendarController.animateToDate(DateTime.now()),
            icon: const Icon(Icons.today),
          ),
          SizedBox(
            width: 120,
            child: DropdownMenu(
              dropdownMenuEntries: viewConfigurations
                  .map((e) => DropdownMenuEntry(value: e, label: e.name))
                  .toList(),
              initialSelection: viewConfiguration,
              onSelected: (value) {
                if (value == null) return;
                callbackViewConfiguration(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
