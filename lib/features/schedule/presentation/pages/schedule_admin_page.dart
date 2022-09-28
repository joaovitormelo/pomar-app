import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/widgets/error_display.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_detail_modal.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_display.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

const textScheduleLoadError = "Erro";
const textScheduleAdminTitle = "Agenda";

class ScheduleAdminPage extends StatelessWidget {
  const ScheduleAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReadEventsBloc>(
          create: (context) => Globals.sl<ReadEventsBloc>(),
        ),
        BlocProvider<EmployeesBloc>(
          create: (context) => Globals.sl<EmployeesBloc>(),
        ),
      ],
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
  EventData? _selectedEvent;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReadEventsBloc>(context).add(LoadEvents());
    BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
  }

  _getEventDataSource(List<EventData> source) {
    return EventDataSource(source);
  }

  _onEventPressed(EventData eventD, List<Employee> employeeList) {
    showBarModalBottomSheet(
      context: context,
      expand: false,
      topControl: Container(),
      builder: (context) => EventDetailModal(
        eventD: eventD,
        employeeList: employeeList,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textScheduleAdminTitle),
      ),
      body: Builder(builder: (context) {
        final readEventsState = context.watch<ReadEventsBloc>().state;
        final employeesState = context.watch<EmployeesBloc>().state;

        if (readEventsState is ReadEventsError) {
          Utils.showSnackBar(context, readEventsState.msg);
          return const ErrorDisplay(msg: textScheduleLoadError);
        } else if (employeesState is EmployeesError) {
          Utils.showSnackBar(context, employeesState.msg);
          return const ErrorDisplay(msg: textScheduleLoadError);
        } else if (readEventsState is ReadEventsLoading ||
            employeesState is EmployeesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (readEventsState is ReadEventsNoData) {
          return Container();
        } else {
          List<EventData> eventDataList =
              (readEventsState as ReadEventsHasData).eventList;
          List<Employee> employeeList = [];
          if (employeesState is EmployeesHasData) {
            employeeList = employeesState.employees;
          }
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
            dataSource: _getEventDataSource(eventDataList),
            initialSelectedDate: DateTime.now(),
            appointmentBuilder: (context, details) {
              late EventData eventD;
              if (details.appointments.first is EventData) {
                eventD = details.appointments.first as EventData;
              } else {
                final appointment = details.appointments.first as Appointment;
                eventDataList.map((EventData e) {
                  if (e.event.idEvent == appointment.id) {
                    eventD = e;
                  }
                }).toList();
              }
              return EventDisplay(
                eventD: eventD,
                onEventPressed: () {
                  _onEventPressed(eventD, employeeList);
                },
              );
            },
          );
        }
      }),
    );
  }
}

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
    DateTime initDateTime =
        Utils.strToDateTime("${event.date} ${event.eventInfo.initTime}");
    return initDateTime;
  }

  @override
  DateTime getEndTime(int index) {
    EventModel event = appointments![index].event;
    DateTime endDateTime;
    if (event.eventInfo.endTime != null) {
      endDateTime =
          Utils.strToDateTime("${event.date} ${event.eventInfo.endTime}");
    } else {
      endDateTime =
          Utils.strToDateTime("${event.date} ${event.eventInfo.initTime}");
    }
    return endDateTime;
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
