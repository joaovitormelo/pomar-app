import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:pomar_app/core/config/globals.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/schedule/presentation/bloc/add_event/add_event_bloc.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_form.dart';

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
  bool isRoutineIsEnabled = false;
  bool isRoutine = false;
  String frequency = "";
  bool endTimeIsEnabled = false;
  bool isTask = false;
  bool isCollective = false;
  List<Employee> employeeList = [];
  List<Employee> assignedEmployees = [];

  @override
  void initState() {
    super.initState();
    employeeList = widget.employeeList;
  }

  setIsRoutine(value) {
    setState(() {
      isRoutine = value;
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
      String initTime = controllers.initTime.text;
      String endTime = controllers.endTime.text;
      String date = controllers.date.text;
      String endDate = controllers.endDate.text;
      String times = controllers.times.text;
      print("SEnd");
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              EventForm(
                formKey: _formKey,
                controllers: controllers,
                variables: EventFieldsVariables(
                  isRoutine: isRoutine,
                  frequency: frequency,
                  isTask: isTask,
                  isCollective: isCollective,
                  employeeList: employeeList,
                  assignedEmployees: assignedEmployees,
                ),
                setters: EventFieldsSetters(
                  setIsRoutine: setIsRoutine,
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
    );
  }
}
