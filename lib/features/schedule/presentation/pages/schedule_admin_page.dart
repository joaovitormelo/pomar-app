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
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_delete_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_states.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/custom_calendar.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_detail_modal.dart';
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
        BlocProvider(
          create: (context) => Globals.sl<DeleteEventBloc>(),
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

  _onEventPressed(DateTime day, EventData eventD, List<Employee> employeeList) {
    showBarModalBottomSheet(
      context: context,
      expand: false,
      topControl: Container(),
      builder: (context) => EventDetailModal(
        eventD: eventD,
        employeeList: employeeList,
        onEditButtonPressed: _onEditButtonPressed,
        onDelete: _onDelete,
        day: day,
      ),
    );
  }

  _onDelete(
    DateTime day,
    EventModel event,
    bool allRoutine,
  ) {
    String excludeDate = DateFormat("yyyy-MM-dd").format(day);
    List<String> excludeDates = [];
    if (!allRoutine) {
      excludeDates.add(excludeDate);
    }
    BlocProvider.of<DeleteEventBloc>(context).add(
      DeleteEventButtonPressed(
        params: DeleteEventParams(
          idEvent: event.idEvent,
          excludeDates: excludeDates,
        ),
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
        if (wasEdited != null) {
          BlocProvider.of<ReadEventsBloc>(context).add(LoadEvents());
          Navigator.pop(context);
        }
      },
    );
  }

  _buildBody() {
    return MultiBlocListener(
      listeners: [
        BlocListener<DeleteEventBloc, DeleteEventState>(
            listener: (context, state) {
          if (state is DeleteEventLoading) {
            Utils.showLoadingEntirePage(context);
          } else if (state is DeleteEventSuccess) {
            Navigator.pop(context);
            Navigator.pop(context);
            BlocProvider.of<ReadEventsBloc>(context).add(LoadEvents());
          } else if (state is DeleteEventError) {
            Navigator.pop(context);
            Navigator.pop(context);
            Utils.showSnackBar(context, state.msg);
          }
        }),
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
                (value) =>
                    BlocProvider.of<ReadEventsBloc>(context).add(LoadEvents()),
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
