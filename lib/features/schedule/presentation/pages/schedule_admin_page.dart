import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/presentation/widgets/error_display.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/schedule/presentation/helpers/event_data_source.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/custom_calendar.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_detail_modal.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_display.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

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
  var _calendarView = CalendarView.month;
  final _calendarController = CalendarController();
  List<Employee> employeeList = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ReadEventsBloc>(context).add(LoadEvents());
    BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
  }

  _onEventPressed(EventData eventD, List<Employee> employeeList) {
    showBarModalBottomSheet(
      context: context,
      expand: false,
      topControl: Container(),
      builder: (context) => EventDetailModal(
        eventD: eventD,
        employeeList: employeeList,
        onEditButtonPressed: _onEditButtonPressed,
      ),
    );
  }

  _onEditButtonPressed(EventData eventD) {
    Navigator.pushNamed(
      context,
      FluroRoutes.editEventRoute,
      arguments: [
        employeeList,
        eventD,
      ],
    ).then(
      (wasEdited) {
        BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
        if (wasEdited != null) {
          Navigator.pop(context);
        }
      },
    );
  }

  _changeCalendarView(CalendarView newView) {
    _calendarController.view = newView;
    setState(() {
      _calendarView = newView;
    });
  }

  _getAppBarActions(CalendarView calendarView) {
    if (calendarView == CalendarView.month) {
      return [
        IconButton(
          onPressed: () => _changeCalendarView(CalendarView.timelineDay),
          icon: const Icon(Icons.calendar_today),
        ),
      ];
    }
    return [
      IconButton(
        onPressed: () => _changeCalendarView(CalendarView.month),
        icon: const Icon(Icons.calendar_month),
      ),
    ];
  }

  _buildBody() {
    return MultiBlocListener(
      listeners: [
        BlocListener<ReadEventsBloc, ReadEventsState>(
          listenWhen: (_, state) => state is ReadEventsError,
          listener: (context, state) {
            Utils.showSnackBar(context, (state as ReadEventsError).msg);
          },
        ),
        BlocListener<EmployeesBloc, EmployeesState>(
          listenWhen: (_, state) => state is EmployeesError,
          listener: (context, state) {
            Utils.showSnackBar(context, (state as EmployeesError).msg);
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final readEventsState = context.watch<ReadEventsBloc>().state;
          final employeesState = context.watch<EmployeesBloc>().state;

          if (readEventsState is ReadEventsError) {
            return const ErrorDisplay(msg: textScheduleLoadError);
          } else if (employeesState is EmployeesError) {
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
            LinkedHashMap<DateTime, List<EventData>> eventsPerDay =
                LinkedHashMap<DateTime, List<EventData>>(
              equals: isSameDay,
            );
            if (employeesState is EmployeesHasData) {
              employeeList = employeesState.employees;
            }
            return Column(
              children: [
                CustomCalendarPage(
                  eventDataList: eventDataList,
                  employeeList: employeeList,
                  onEventPressed: _onEventPressed,
                ),
              ],
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(textScheduleAdminTitle),
        actions: _getAppBarActions(_calendarView),
      ),
      floatingActionButton: Builder(builder: (context) {
        final readEventsState = context.watch<ReadEventsBloc>().state;
        final employeesState = context.watch<EmployeesBloc>().state;

        if (readEventsState is ReadEventsHasData &&
            employeesState is EmployeesHasData) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                FluroRoutes.addEventRoute,
                arguments: employeesState.employees,
              ).then(
                (value) => BlocProvider.of<EmployeesBloc>(context).add(
                  LoadEmployees(),
                ),
              );
            },
            child: const Icon(Icons.add),
          );
        } else {
          return Container();
        }
      }),
      body: _buildBody(),
    );
  }
}
