import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/date_time_fields.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/task_fields.dart';

class EventFieldsControllers {
  final TextEditingController title;
  final TextEditingController description;
  final TextEditingController initTime;
  final TextEditingController endTime;
  final TextEditingController date;
  final TextEditingController interval;
  final TextEditingController times;
  final TextEditingController endDate;

  EventFieldsControllers({
    required this.title,
    required this.description,
    required this.initTime,
    required this.endTime,
    required this.date,
    required this.interval,
    required this.times,
    required this.endDate,
  });
}

class EventFieldsVariables {
  final bool isRoutine;
  final String frequency;
  final bool isTask;
  final bool isCollective;
  final List<Employee> employeeList;
  final List<Employee> assignedEmployees;

  EventFieldsVariables({
    required this.isRoutine,
    required this.frequency,
    required this.isTask,
    required this.isCollective,
    required this.employeeList,
    required this.assignedEmployees,
  });
}

class EventFieldsSetters {
  final setIsRoutine;
  final setFrequency;
  final setIsTask;
  final setIsCollective;
  final setEmployeeList;
  final setAssignedEmployees;

  EventFieldsSetters({
    required this.setIsRoutine,
    required this.setFrequency,
    required this.setIsTask,
    required this.setIsCollective,
    required this.setEmployeeList,
    required this.setAssignedEmployees,
  });
}

class EventForm extends StatefulWidget {
  final GlobalKey<FormBuilderState> formKey;
  final EventFieldsControllers controllers;
  final EventFieldsVariables variables;
  final EventFieldsSetters setters;

  const EventForm({
    Key? key,
    required this.formKey,
    required this.controllers,
    required this.variables,
    required this.setters,
  }) : super(key: key);

  @override
  State<EventForm> createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> with InputValidationMixin {
  @override
  Widget build(BuildContext context) {
    EventFieldsControllers controllers = widget.controllers;
    EventFieldsVariables variables = widget.variables;
    EventFieldsSetters setters = widget.setters;

    var formFields = [
      FormBuilderTextField(
        name: "title",
        controller: controllers.title,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.title),
          border: OutlineInputBorder(),
          labelText: "Título do Evento",
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (title) => validateString(title, 0, 100),
      ),
      const SizedBox(
        height: 30,
      ),
      DateTimeFields(
        controllers: DateTimeFieldsControllers(
          initTime: controllers.initTime,
          endTime: controllers.endTime,
          date: controllers.date,
          interval: controllers.interval,
          times: controllers.times,
          endDate: controllers.endDate,
        ),
        variables: DateTimeFieldsVariables(
            isRoutine: variables.isRoutine, frequency: variables.frequency),
        setters: DateTimeFieldsSetters(
            setIsRoutine: setters.setIsRoutine,
            setFrequency: setters.setFrequency),
      ),
      const SizedBox(
        height: 30,
      ),
      TaskFields(
        variables: TaskFieldsVariables(
          isTask: variables.isTask,
          isCollective: variables.isCollective,
          employeeList: variables.employeeList,
          assignedEmployees: variables.assignedEmployees,
        ),
        setters: TaskFieldsSetters(
          setIsTask: setters.setIsTask,
          setIsCollective: setters.setIsTask,
          setEmployeeList: setters.setEmployeeList,
          setAssignedEmployees: setters.setAssignedEmployees,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
      Row(
        children: [
          const Icon(
            Icons.info_outline,
            color: Colors.grey,
            size: 25,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Container(
              height: 2,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 30,
      ),
      FormBuilderTextField(
        name: "description",
        controller: widget.controllers.description,
        decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          prefixIcon: Icon(Icons.text_fields),
          border: OutlineInputBorder(),
          labelText: "Descrição",
        ),
        maxLines: 5,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (description) =>
            validateString(description, 0, 500, required: false),
      ),
    ];

    return FormBuilder(
      key: widget.formKey,
      child: Column(
        children: formFields,
      ),
    );
  }
}
