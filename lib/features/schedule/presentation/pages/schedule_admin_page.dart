import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/bloc.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

const textScheduleAdminTitle = "Agenda";

getDateTime(String dateTime) {
  int year = int.parse(dateTime.substring(0, 4));
  int month = int.parse(dateTime.substring(5, 7));
  int day = int.parse(dateTime.substring(8, 10));
  int hour = int.parse(dateTime.substring(11, 13));
  int minutes = int.parse(dateTime.substring(14, 16));
  return DateTime(year, month, day, hour, minutes);
}

class ScheduleAdminPage extends StatelessWidget {
  const ScheduleAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReadEventsBloc>(
      create: (context) => Globals.sl<ReadEventsBloc>(),
      child: const ScheduleAdminBody(),
    );
  }
}

class ScheduleAdminBody extends StatefulWidget {
  const ScheduleAdminBody({Key? key}) : super(key: key);

  @override
  State<ScheduleAdminBody> createState() => _ScheduleAdminBodyState();
}

class _ScheduleAdminBodyState extends State<ScheduleAdminBody> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReadEventsBloc>(context).add(LoadEvents());
  }

  _getEventDataSource(List<EventModel> source) {
    return EventDataSource(source);
  }

  Widget _getEventView(EventModel event) {
    String textTime = '';
    if (event.eventInfo.endTime != null) {
      String endTime = event.eventInfo.endTime as String;
      textTime =
          '${event.eventInfo.initTime.substring(0, 5)} - ${endTime.substring(0, 5)}';
    } else {
      textTime = event.eventInfo.initTime.substring(0, 5);
    }
    late Color color;
    if (event.eventInfo.isTask) {
      color = Colors.green;
    } else {
      color = Colors.blue;
    }
    List<Widget> eventColumnComposition = [
      event.eventInfo.isRoutine
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  event.eventInfo.title,
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      decoration:
                          TextDecoration.none), //TextDecoration.lineThrough
                ),
                const Icon(
                  FontAwesomeIcons.arrowsRotate,
                  color: Colors.white,
                  size: 13,
                ),
              ],
            )
          : Text(
              event.eventInfo.title,
              textAlign: TextAlign.left,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
    ];
    if (!event.eventInfo.allDay) {
      eventColumnComposition.add(Text(
        textTime,
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ));
    }
    List<Widget> eventRowComposition = [];
    if (event.eventInfo.isTask) {
      eventRowComposition.add(
        Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: const Icon(
                  Icons.check_box_outlined,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              const Text(
                "(1/2)",
                style: TextStyle(fontSize: 10, color: Colors.white),
              )
            ],
          ),
        ),
      );
    }
    eventRowComposition.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: eventColumnComposition,
        ),
      ),
    ));
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.rectangle,
        borderRadius: const BorderRadius.all(Radius.circular(4.0)),
      ),
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: eventRowComposition,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textScheduleAdminTitle),
      ),
      body: BlocBuilder<ReadEventsBloc, ReadEventsState>(
        builder: (context, state) {
          if (state is ReadEventsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ReadEventsHasData) {
            return SfCalendar(
              view: CalendarView.month,
              allowedViews: const [
                CalendarView.month,
                CalendarView.schedule,
              ],
              showNavigationArrow: true,
              monthViewSettings: const MonthViewSettings(
                showAgenda: true,
              ),
              dataSource: _getEventDataSource(state.eventList),
              initialSelectedDate: DateTime.now(),
              appointmentBuilder: (context, details) {
                late EventModel event;
                if (details.appointments.first is EventModel) {
                  event = details.appointments.first as EventModel;
                } else {
                  final appointment = details.appointments.first as Appointment;
                  state.eventList.map((EventModel e) {
                    if (e.idEvent == appointment.id) {
                      event = e;
                    }
                  }).toList();
                }
                return _getEventView(event);
              },
            );
          } else if (state is ReadEventsError) {
            return Container();
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(source) {
    appointments = source;
  }

  @override
  Object? getId(int index) {
    return appointments![index].idEvent;
  }

  @override
  DateTime getStartTime(int index) {
    EventModel event = appointments![index];
    DateTime initDateTime =
        getDateTime("${event.date} ${event.eventInfo.initTime}");
    return initDateTime;
  }

  @override
  DateTime getEndTime(int index) {
    EventModel event = appointments![index];
    DateTime endDateTime;
    if (event.eventInfo.endTime != null) {
      endDateTime = getDateTime("${event.date} ${event.eventInfo.endTime}");
    } else {
      endDateTime = getDateTime("${event.date} ${event.eventInfo.initTime}");
    }
    return endDateTime;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].eventInfo.allDay;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventInfo.title;
  }

  @override
  String? getRecurrenceRule(int index) {
    EventModel event = appointments![index];
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
