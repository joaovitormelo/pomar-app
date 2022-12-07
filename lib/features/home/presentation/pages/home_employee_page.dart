import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/templates/authorized_template.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/auth/presentation/bloc/bloc.dart';
import 'package:pomar_app/features/employee/data/models/employee_model.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/employee/presentation/bloc/employee_bloc.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_events/read_events_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_events/read_events_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_today_tasks/read_today_tasks_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_today_tasks/read_today_tasks_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/read_today_tasks/read_today_tasks_states.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/switch_complete_bloc/switch_complete_states.dart';
import 'package:pomar_app/features/schedule/presentation/pages/schedule_admin_page.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_detail_modal.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_display.dart';

class HomeEmployeePage extends StatelessWidget {
  const HomeEmployeePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => Globals.sl<AuthBloc>()),
        BlocProvider(create: (context) => Globals.sl<ReadTodayTasksBloc>()),
        BlocProvider(create: (context) => Globals.sl<SwitchCompleteBloc>()),
        BlocProvider(create: (context) => Globals.sl<EmployeesBloc>()),
      ],
      child: HomeEmployeeBody(),
    );
  }
}

class HomeEmployeeBody extends StatefulWidget {
  const HomeEmployeeBody({Key? key}) : super(key: key);

  @override
  State<HomeEmployeeBody> createState() => _HomeEmployeeBodyState();
}

class _HomeEmployeeBodyState extends State<HomeEmployeeBody> {
  late List<EventData> taskList;
  late List<Employee> employeeList;
  late SwitchCompleteData switchCompleteData;

  @override
  initState() {
    super.initState();
    int idPerson =
        (BlocProvider.of<AuthBloc>(context).state as AuthorizedEmployee)
            .session
            .user
            .person
            .idPerson;
    BlocProvider.of<ReadTodayTasksBloc>(context)
        .add(LoadTodayTasks(idPerson: idPerson));
    BlocProvider.of<EmployeesBloc>(context).add(LoadEmployees());
  }

  onLogoutButtonPressed() {
    BlocProvider.of<LogoutBloc>(context).add(LogoutButtonPressed());
  }

  _buildTaskListItem(EventData eventD, bool isRisked) {
    return EventDisplay(
      eventD: eventD,
      day: DateTime.now(),
      onEventPressed: () =>
          _onEventPressed(DateTime.now(), eventD, employeeList),
      userIsEmployee: true,
      isRisked: isRisked,
      onRiskTask: _onRiskTask,
    );
  }

  _onEventPressed(DateTime day, EventData eventD, List<Employee> employeeList) {
    showBarModalBottomSheet(
      context: context,
      expand: false,
      topControl: Container(),
      builder: (context) => EventDetailModal(
        eventD: eventD,
        employeeList: employeeList,
        onEditButtonPressed: (e) {},
        onDelete: (
          day,
          event,
          allRoutine,
        ) {},
        day: day,
        showOptions: false,
      ),
    );
  }

  _getUserAssignmentIndex(EventData eventData) {
    int idPersonEmployee =
        (BlocProvider.of<AuthBloc>(context).state as AuthorizedEmployee)
            .session
            .user
            .person
            .idPerson;
    int idEmployee = employeeList
        .firstWhere((e) => e.person.idPerson == idPersonEmployee)
        .idEmployee;
    return eventData.assignments
        .indexWhere((assignment) => assignment.idEmployee == idEmployee);
  }

  _onRiskTask(bool isCompleted, int idEvent) {
    setState(() {
      switchCompleteData =
          SwitchCompleteData(idEvent: idEvent, isCompleted: isCompleted);
    });
    int eventIndex =
        taskList.indexWhere((eventD) => eventD.event.idEvent == idEvent);
    EventData eventData = taskList[eventIndex];
    int index = _getUserAssignmentIndex(eventData);
    AssignmentModel assignment = eventData.assignments[index];
    BlocProvider.of<SwitchCompleteBloc>(context).add(
      SwitchComplete(
        idAssignment: assignment.idAssignment,
        isCompleted: isCompleted,
      ),
    );
  }

  _updateEventList() {
    int eventIndex = taskList.indexWhere(
        (eventD) => eventD.event.idEvent == switchCompleteData.idEvent);
    EventData eventData = taskList[eventIndex];
    int index = _getUserAssignmentIndex(eventData);
    AssignmentModel assignment = eventData.assignments[index];
    eventData.assignments[index] = AssignmentModel(
      idAssignment: assignment.idAssignment,
      idEvent: switchCompleteData.idEvent,
      idEmployee: assignment.idEmployee,
      isCompleted: switchCompleteData.isCompleted,
    );
    BlocProvider.of<ReadTodayTasksBloc>(context).add(
      UpdateTodayTasks(todayTasks: taskList),
    );
  }

  @override
  Widget build(BuildContext context) {
    AuthorizedEmployee authState =
        BlocProvider.of<AuthBloc>(context).state as AuthorizedEmployee;
    return MultiBlocListener(
      listeners: [
        BlocListener<ReadTodayTasksBloc, ReadTodayTasksStates>(
          listener: (context, state) {
            if (state is ReadTodayTasksHasData) {
              setState(() {
                taskList = state.eventDList;
              });
            } else if (state is ReadTodayTasksError) {
              Utils.showSnackBar(context, state.msg);
            }
          },
        ),
        BlocListener<EmployeesBloc, EmployeesState>(
          listener: (context, state) {
            if (state is EmployeesHasData) {
              setState(() {
                employeeList = state.employees;
              });
            } else if (state is EmployeesError) {
              Utils.showSnackBar(context, state.msg);
            }
          },
        ),
        BlocListener<SwitchCompleteBloc, SwitchCompleteState>(
          listener: (context, state) {
            if (state is SwitchCompleteFinished) {
              _updateEventList();
            } else if (state is SwitchCompleteError) {
              Utils.showSnackBar(context, state.msg);
            }
          },
        ),
      ],
      child: AuthorizedTemplate(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "Tarefas de Hoje",
                style: TextStyle(
                  fontSize: 28,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child: BlocBuilder<EmployeesBloc, EmployeesState>(
                  builder: (context, stateEmployees) =>
                      BlocBuilder<ReadTodayTasksBloc, ReadTodayTasksStates>(
                    builder: (context, state) {
                      if (state is ReadTodayTasksLoading ||
                          stateEmployees is EmployeesLoading) {
                        return Container(
                          width: double.infinity,
                          height: 300,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else if (state is ReadTodayTasksError ||
                          stateEmployees is EmployeesError ||
                          stateEmployees is EmployeesNoData) {
                        return Container(
                          width: double.infinity,
                          height: 300,
                          child: const Center(
                            child: Icon(
                              Icons.warning,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        );
                      } else if (state is ReadTodayTasksNoData) {
                        return Container(
                          width: double.infinity,
                          height: 300,
                          child: const Center(
                            child: Text("Sem tarefas"),
                          ),
                        );
                      } else {
                        List<EventData> eventDList =
                            (state as ReadTodayTasksHasData).eventDList;
                        eventDList.sort((eventA, eventB) {
                          if (eventA.event.allDay) return -1;
                          if (eventB.event.allDay) return 1;
                          String eventAInit = eventA.event.initTime as String;
                          String eventBInit = eventB.event.initTime as String;
                          return eventAInit.compareTo(eventBInit);
                        });
                        List<Employee> employees =
                            (stateEmployees as EmployeesHasData).employees;
                        int idPerson = (BlocProvider.of<AuthBloc>(context).state
                                as AuthorizedEmployee)
                            .session
                            .user
                            .person
                            .idPerson;
                        int idEmployee = employees
                            .where((emp) => emp.person.idPerson == idPerson)
                            .toList()[0]
                            .idEmployee;
                        List<EventData> completedTasks = [];
                        List<EventData> toDoTasks = eventDList.where((eventD) {
                          bool isCompleted = false;
                          eventD.assignments.map((ass) {
                            if (ass.idEmployee == idEmployee &&
                                ass.isCompleted == true) {
                              isCompleted = true;
                            }
                          }).toList();
                          if (isCompleted) {
                            completedTasks.add(eventD);
                          }
                          return !isCompleted;
                        }).toList();
                        return Column(
                          children: [
                            const Text(
                              "A Fazer",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3,
                              child: ListView.separated(
                                itemCount: toDoTasks.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemBuilder: (context, index) =>
                                    _buildTaskListItem(toDoTasks[index], false),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "Completas",
                              style: TextStyle(
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.left,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height / 3,
                              child: ListView.separated(
                                itemCount: completedTasks.length,
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                  height: 10,
                                ),
                                itemBuilder: (context, index) =>
                                    _buildTaskListItem(
                                        completedTasks[index], true),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
