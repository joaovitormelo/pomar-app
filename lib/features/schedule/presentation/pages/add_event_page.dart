import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_info_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_add_event.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_events.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_states.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_form.dart';

enum EndMode {
  endDate,
  times,
}

class AddEventPage extends StatelessWidget {
  final List<Employee> employeeList;

  const AddEventPage({
    Key? key,
    required this.employeeList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddEventBloc>(
      create: (context) => Globals.sl<AddEventBloc>(),
      child: AddEventBody(
        employeeList: employeeList,
      ),
    );
  }
}

class AddEventBody extends StatefulWidget {
  final List<Employee> employeeList;
  const AddEventBody({Key? key, required this.employeeList}) : super(key: key);

  @override
  State<AddEventBody> createState() => _AddEventBodyState();
}

class _AddEventBodyState extends State<AddEventBody> with InputValidationMixin {
  final _formKey = GlobalKey<FormBuilderState>();
  final EventFieldsControllers controllers = EventFieldsControllers(
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
  bool undefinedEnd = true;
  EndMode endMode = EndMode.endDate;
  bool isTask = false;
  bool isCollective = false;
  List<Employee> employeeList = [];
  List<Employee> assignedEmployees = [];

  @override
  void initState() {
    super.initState();
    employeeList = widget.employeeList;
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

  setEmployeeList(value) {
    setState(() {
      employeeList = value;
    });
  }

  setAssignedEmployees(value) {
    setState(() {
      assignedEmployees = value;
    });
  }

  onSubmit() {
    if (_formKey.currentState!.validate()) {
      String title = controllers.title.text;
      String? initTime = controllers.initTime.text;
      String? endTime = controllers.endTime.text;
      String date = DateFormat("yyyy-MM-dd").format(
        DateFormat("dd/MM/yyyy").parse(
          controllers.date.text,
        ),
      );
      String intervalStr = controllers.interval.text;
      String endDateStr = controllers.endDate.text;
      String timesStr = controllers.times.text;
      String description = controllers.description.text;

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

      EventModel event = EventModel(
        idEvent: 0,
        eventInfo: EventInfoModel(
          idEventInfo: 0,
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
          weekDays: "",
          undefinedEnd: undefinedEnd,
          endDate: endDate,
          times: times,
        ),
        date: date,
      );

      List<AssignmentModel> assignmentList = [];
      if (isTask) {
        assignmentList = assignedEmployees
            .map(
              (employee) => AssignmentModel(
                idAssignment: 0,
                idEvent: 0,
                idEmployee: employee.idEmployee,
                isCompleted: false,
              ),
            )
            .toList();
      }

      BlocProvider.of<AddEventBloc>(context).add(
        AddEventButtonPressed(
          addEventParams: AddEventParams(
            event: event,
            assignmentList: assignmentList,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Evento"),
        actions: [
          IconButton(
            onPressed: onSubmit,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: BlocListener<AddEventBloc, AddEventStates>(
        listener: (_, state) {
          if (state is AddEventError) {
            Navigator.of(context).pop();
            Utils.showSnackBar(context, state.msg);
          } else if (state is AddEventLoading) {
            Utils.showLoadingEntirePage(context);
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                EventForm(
                  formKey: _formKey,
                  controllers: controllers,
                  variables: EventFieldsVariables(
                    allDay: allDay,
                    endTimeIsEnabled: endTimeIsEnabled,
                    isRoutineIsEnabled: isRoutineIsEnabled,
                    isRoutine: isRoutine,
                    undefinedEnd: undefinedEnd,
                    endMode: endMode,
                    frequency: frequency,
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
                    setIsTask: setIsTask,
                    setIsCollective: setIsCollective,
                    setEmployeeList: setEmployeeList,
                    setAssignedEmployees: setAssignedEmployees,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
