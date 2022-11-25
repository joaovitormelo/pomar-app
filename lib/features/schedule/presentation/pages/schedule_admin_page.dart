import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/routes/fluro_routes.dart';
import 'package:pomar_app/core/presentation/widgets/error_display.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/auth/domain/entities/person.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_delete_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/delete_event/delete_event_states.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_states.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/custom_calendar.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_detail_modal.dart';

const textScheduleLoadError = "Erro";
const textScheduleAdminTitle = "Agenda";

class ScheduleAdminPage extends StatelessWidget {
  const ScheduleAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => Globals.sl<AuthBloc>(),
        ),
        BlocProvider<ReadEventsBloc>(
          create: (context) => Globals.sl<ReadEventsBloc>(),
        ),
        BlocProvider<EmployeesBloc>(
          create: (context) => Globals.sl<EmployeesBloc>(),
        ),
        BlocProvider<DeleteEventBloc>(
          create: (context) => Globals.sl<DeleteEventBloc>(),
        ),
        BlocProvider<SwitchCompleteBloc>(
          create: (context) => Globals.sl<SwitchCompleteBloc>(),
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
  List<Employee> employeeList = [];
  List<EventData> eventDList = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
    BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
  }

  _loadEvents() {
    if (BlocProvider.of<AuthBloc>(context).state is AuthorizedAdmin) {
      BlocProvider.of<ReadEventsBloc>(context).add(LoadEvents());
    } else {
      AuthorizedEmployee state =
          BlocProvider.of<AuthBloc>(context).state as AuthorizedEmployee;
      BlocProvider.of<ReadEventsBloc>(context).add(
          LoadEventsByEmployee(idPerson: state.session.user.person.idPerson));
    }
  }

  _shouldShowOptions(bool isTask) {
    if (BlocProvider.of<AuthBloc>(context).state is AuthorizedAdmin) {
      return true;
    } else {
      return !isTask;
    }
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
        showOptions: _shouldShowOptions(eventD.event.isTask),
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
          _loadEvents();
          Navigator.pop(context);
        }
      },
    );
  }

  _onRiskTask(bool isCompleted, int idEvent) {
    int eventIndex =
        eventDList.indexWhere((eventD) => eventD.event.idEvent == idEvent);
    EventData eventData = eventDList[eventIndex];
    int idPersonEmployee =
        (BlocProvider.of<AuthBloc>(context).state as AuthorizedEmployee)
            .session
            .user
            .person
            .idPerson;
    int idEmployee = employeeList
        .firstWhere((e) => e.person.idPerson == idPersonEmployee)
        .idEmployee;
    int index = eventData.assignments
        .indexWhere((assignment) => assignment.idEmployee == idEmployee);
    AssignmentModel assignment = eventData.assignments[index];
    eventData.assignments[index] = AssignmentModel(
        idAssignment: assignment.idAssignment,
        idEvent: idEvent,
        idEmployee: assignment.idEmployee,
        isCompleted: isCompleted);
    setState(() {
      eventDList[eventIndex] = eventData;
      eventDList = eventDList;
    });
    BlocProvider.of<SwitchCompleteBloc>(context).add(
      SwitchComplete(
        idAssignment: assignment.idAssignment,
        isCompleted: isCompleted,
      ),
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
            _loadEvents();
          } else if (state is DeleteEventError) {
            Navigator.pop(context);
            Navigator.pop(context);
            Utils.showSnackBar(context, state.msg);
          }
        }),
        BlocListener<ReadEventsBloc, ReadEventsState>(
          listener: (context, state) {
            if (state is ReadEventsError) {
              Utils.showSnackBar(context, (state as ReadEventsError).msg);
            } else if (state is ReadEventsHasData) {
              setState(() {
                eventDList = state.eventList;
              });
            }
          },
        ),
        BlocListener<EmployeesBloc, EmployeesState>(
          listenWhen: (_, state) => state is EmployeesError,
          listener: (context, state) {
            Utils.showSnackBar(context, (state as EmployeesError).msg);
          },
        ),
        BlocListener<SwitchCompleteBloc, SwitchCompleteState>(
          listener: (context, state) {
            if (state is SwitchCompleteFinished) {
              BlocProvider.of<ReadEventsBloc>(context).add(
                UpdateEventList(eventDList: eventDList),
              );
            } else if (state is SwitchCompleteError) {
              Utils.showSnackBar(context, state.msg);
            }
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
            AuthState authState = BlocProvider.of<AuthBloc>(context).state;
            Person person;
            if (authState is AuthorizedEmployee) {
              person = authState.session.user.person;
            } else {
              person = (authState as AuthorizedAdmin).session.user.person;
            }
            return Column(
              children: [
                CustomCalendarPage(
                  eventDataList: eventDataList,
                  employeeList: employeeList,
                  userPerson: person,
                  userIsEmployee: authState is AuthorizedEmployee,
                  onEventPressed: _onEventPressed,
                  onRiskTask: _onRiskTask,
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
                (value) => _loadEvents(),
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
