import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:pomar_app/core/utils/Utils.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<EventData> source) {
    appointments = source;
  }

  @override
  Object? getId(int index) {
    return appointments![index].event.idEvent;
  }

  @override
  DateTime getStartTime(int index) {
    EventModel event = appointments![index].event;
    if (event.eventInfo.initTime == null) {
      return DateFormat("yyyy-MM-dd").parse(event.date);
    } else {
      return DateFormat("hh:mm:ss").parse(event.eventInfo.initTime as String);
    }
  }

  @override
  DateTime getEndTime(int index) {
    EventModel event = appointments![index].event;
    if (event.eventInfo.endTime == null) {
      return DateFormat("yyyy-MM-dd").parse(event.date);
    } else {
      return DateFormat("hh:mm:ss").parse(event.eventInfo.endTime as String);
    }
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].event.eventInfo.allDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].event.eventInfo.title;
  }

  @override
  String? getRecurrenceRule(int index) {
    EventModel event = appointments![index].event;
    if (!event.eventInfo.isRoutine) {
      return null;
    } else {
      String recurrenceRule = "";
      if (event.eventInfo.frequency == "D") {
        recurrenceRule += 'FREQ=DAILY;';
      } else if (event.eventInfo.frequency == "W") {
        recurrenceRule += 'FREQ=WEEKLY;BYDAY=FR;';
      } else if (event.eventInfo.frequency == "M") {
        recurrenceRule += 'FREQ=MONTHLY;';
      } else if (event.eventInfo.frequency == "Y") {
        recurrenceRule += 'FREQ=YEARLY;';
      }
      recurrenceRule += "INTERVAL=${event.eventInfo.interval};";
      if (event.eventInfo.times != null) {
        recurrenceRule += "COUNT=${event.eventInfo.times}";
      } else {
        String endDate = event.eventInfo.endDate as String;
        int year = int.parse(endDate.substring(0, 4));
        int month = int.parse(endDate.substring(5, 7));
        int day = int.parse(endDate.substring(8, 10));
        DateTime endDateTime = DateTime(year, month, day);
        recurrenceRule += "UNTIL=${endDateTime.toIso8601String()}";
      }
      return recurrenceRule;
    }
  }
}
