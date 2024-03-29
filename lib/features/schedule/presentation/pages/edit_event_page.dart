import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:pomar_app/features/auth/presentation/bloc/auth/auth_states.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_edit_event.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/edit_event/edit_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/edit_event/edit_event_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/edit_event/edit_event_states.dart';
import 'package:pomar_app/features/schedule/presentation/pages/add_event_page.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/custom_calendar.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_form.dart';

class EditEventPage extends StatelessWidget {
  final List<Employee> employeeList;
  final EventData eventD;
  const EditEventPage(
      {Key? key, required this.employeeList, required this.eventD})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EditEventBloc>(
      create: (context) => Globals.sl<EditEventBloc>(),
      child: EditEventBody(
        employeeList: employeeList,
        eventD: eventD,
      ),
    );
  }
}

class EditEventBody extends StatefulWidget {
  final List<Employee> employeeList;
  final EventData eventD;
  const EditEventBody(
      {Key? key, required this.employeeList, required this.eventD})
      : super(key: key);

  @override
  State<EditEventBody> createState() => _EditEventBodyState();
}

class _EditEventBodyState extends State<EditEventBody> {
  final _formKey = GlobalKey<FormBuilderState>();
  final EventFieldsControllers _controllers = EventFieldsControllers(
    title: TextEditingController(),
    initTime: TextEditingController(),
    endTime: TextEditingController(),
    date: TextEditingController(),
    interval: TextEditingController(text: "1"),
    times: TextEditingController(text: "10"),
    endDate: TextEditingController(),
    description: TextEditingController(text: ""),
  );
  bool allDay = false;
  bool endTimeIsEnabled = false;
  bool isRoutineIsEnabled = false;
  bool isRoutine = false;
  String? frequency;
  String? weekDays;
  bool undefinedEnd = true;
  EndMode endMode = EndMode.endDate;
  bool isTask = false;
  bool isCollective = false;
  List<Employee> employeeList = [];
  List<Employee> assignedEmployees = [];
  late BuildContext loadingModalContext;

  @override
  void initState() {
    super.initState();

    employeeList = widget.employeeList;
    EventModel event = widget.eventD.event;
    List<AssignmentModel> assignmentList = widget.eventD.assignments;

    _controllers.title.text = event.title;

    allDay = event.allDay;
    if (event.initTime != null) {
      _controllers.initTime.text = Utils.convertDateStrPattern(
          event.initTime as String, "HH:mm:ss", "HH:mm");
      endTimeIsEnabled = true;
    }
    if (event.endTime != null) {
      _controllers.endTime.text = Utils.convertDateStrPattern(
          event.endTime as String, "HH:mm:ss", "HH:mm");
    }
    _controllers.date.text =
        Utils.convertDateStrPattern(event.date, "yyyy-MM-dd", "dd/MM/yyyy");
    isRoutineIsEnabled = true;
    isRoutine = event.isRoutine;
    if (isRoutine) {
      weekDays = event.weekDays as String;
      if (event.frequency != null) {
        frequency = event.frequency as String;
      }
      if (event.interval != null) {
        _controllers.interval.text = event.interval.toString();
      }
      undefinedEnd = event.undefinedEnd as bool;
      if (!undefinedEnd) {
        if (event.endDate != null) {
          endMode = EndMode.endDate;
          _controllers.endDate.text = Utils.convertDateStrPattern(
              event.endDate as String, "yyyy-MM-dd", "dd/MM/yyyy");
        } else {
          endMode = EndMode.times;
          _controllers.times.text = event.times.toString();
        }
      }
    }

    isTask = event.isTask;
    if (event.isCollective != null) {
      isCollective = event.isCollective as bool;
    }
    employeeList = employeeList.where((employee) {
      bool isAssigned = false;
      assignmentList.map((assignment) {
        if (assignment.idEmployee == employee.idEmployee) {
          isAssigned = true;
          assignedEmployees.add(employee);
        }
      }).toList();
      return !isAssigned;
    }).toList();

    _controllers.description.text = event.description;
  }

  setAllDay(value) {
    setState(() {
      allDay = value;
    });
  }

  setEndTimeIsEnabled(value) {
    setState(() {
      endTimeIsEnabled = value;
    });
  }

  setIsRoutineIsEnabled(value) {
    setState(() {
      isRoutineIsEnabled = value;
    });
  }

  setIsRoutine(value) {
    setState(() {
      isRoutine = value;
    });
  }

  setUndefinedEnd(value) {
    setState(() {
      undefinedEnd = value;
    });
  }

  setEndMode(value) {
    setState(() {
      endMode = value;
    });
  }

  setFrequency(value) {
    setState(() {
      frequency = value;
    });
  }

  setWeekDays(value) {
    setState(() {
      weekDays = value;
    });
  }

  setIsTask(value) {
    setState(() {
      isTask = value;
    });
  }

  setIsCollective(value) {
    setState(() {
      isCollective = value;
    });
  }

  setAssignedEmployees(value) {
    setState(() {
      assignedEmployees = value;
    });
  }

  _isUserAdmin() {
    return BlocProvider.of<AuthBloc>(context).state is AuthorizedAdmin;
  }

  _onSubmit() {
    if (_formKey.currentState!.validate()) {
      String title = _controllers.title.text;
      String? initTime = _controllers.initTime.text;
      String? endTime = _controllers.endTime.text;
      String date = DateFormat("yyyy-MM-dd").format(
        DateFormat("dd/MM/yyyy").parse(
          _controllers.date.text,
        ),
      );
      String intervalStr = _controllers.interval.text;
      String endDateStr = _controllers.endDate.text;
      String timesStr = _controllers.times.text;
      String description = _controllers.description.text;

      int? interval;
      int? times;
      String? endDate;
      if (!allDay) {
        initTime = "$initTime:00";
        endTime = "$endTime:00";
      } else {
        initTime = null;
        endTime = null;
      }
      if (isRoutine) {
        interval = int.parse(intervalStr);
        if (undefinedEnd) {
          times = null;
          endDate = null;
        } else {
          if (endMode == EndMode.endDate) {
            endDate = DateFormat("yyyy-MM-dd").format(
              DateFormat("dd/MM/yyyy").parse(
                endDateStr,
              ),
            );
            times = null;
          } else {
            times = int.parse(timesStr);
            endDate = null;
          }
        }
      }

      EventModel oldEvent = widget.eventD.event;
      EventModel event = EventModel(
        idEvent: oldEvent.idEvent,
        date: date,
        title: title,
        initTime: initTime,
        endTime: endTime,
        allDay: allDay,
        description: description,
        isTask: isTask,
        isCollective: isCollective,
        isRoutine: isRoutine,
        initDate: date,
        frequency: frequency,
        interval: interval,
        weekDays: weekDays,
        undefinedEnd: undefinedEnd,
        endDate: endDate,
        times: times,
      );

      List<AssignmentModel> assignmentList = [];
      if (isTask) {
        assignmentList = assignedEmployees
            .map(
              (employee) => AssignmentModel(
                idAssignment: 0,
                idEvent: oldEvent.idEvent,
                idEmployee: employee.idEmployee,
                isCompleted: false,
              ),
            )
            .toList();
      }

      BlocProvider.of<EditEventBloc>(context).add(
        EditEventButtonPressed(
          params: EditEventParams(
            event: event,
            assignmentList: assignmentList,
          ),
        ),
      );

      setState(() {
        assignedEmployees = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Evento"),
        actions: [
          IconButton(
            onPressed: _onSubmit,
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: BlocListener<EditEventBloc, EditEventState>(
        listener: (_, state) {
          if (state is EditEventError) {
            Navigator.of(context).pop();
            Utils.showSnackBar(context, state.msg);
          } else if (state is EditEventLoading) {
            showDialog(
              context: context,
              builder: (context) {
                loadingModalContext = context;
                return Center(
                  child: Container(
                    color: Colors.grey,
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(5),
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                );
              },
            );
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pop(true);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              EventForm(
                formKey: _formKey,
                controllers: _controllers,
                variables: EventFieldsVariables(
                  allDay: allDay,
                  endTimeIsEnabled: endTimeIsEnabled,
                  isRoutineIsEnabled: isRoutineIsEnabled,
                  isRoutine: isRoutine,
                  undefinedEnd: undefinedEnd,
                  endMode: endMode,
                  frequency: frequency,
                  weekDays: weekDays,
                  isTask: isTask,
                  isCollective: isCollective,
                  employeeList: employeeList,
                  assignedEmployees: assignedEmployees,
                ),
                setters: EventFieldsSetters(
                  setAllDay: setAllDay,
                  setEndTimeIsEnabled: setEndTimeIsEnabled,
                  setIsRoutineIsEnabled: setIsRoutineIsEnabled,
                  setIsRoutine: setIsRoutine,
                  setUndefinedEnd: setUndefinedEnd,
                  setEndMode: setEndMode,
                  setFrequency: setFrequency,
                  setWeekDays: setWeekDays,
                  setIsTask: setIsTask,
                  setIsCollective: setIsCollective,
                  setAssignedEmployees: setAssignedEmployees,
                ),
                showTaskSection: _isUserAdmin(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
