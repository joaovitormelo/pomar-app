import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';

class DateTimeFieldsVariables {
  final bool isRoutine;
  final String frequency;

  DateTimeFieldsVariables({
    required this.isRoutine,
    required this.frequency,
  });
}

class DateTimeFieldsSetters {
  final setIsRoutine;
  final setFrequency;

  DateTimeFieldsSetters({
    required this.setIsRoutine,
    required this.setFrequency,
  });
}

class DateTimeFieldsControllers {
  final TextEditingController initTime;
  final TextEditingController endTime;
  final TextEditingController date;
  final TextEditingController interval;
  final TextEditingController times;
  final TextEditingController endDate;

  DateTimeFieldsControllers({
    required this.initTime,
    required this.endTime,
    required this.date,
    required this.interval,
    required this.times,
    required this.endDate,
  });
}

class DateTimeFields extends StatefulWidget {
  final DateTimeFieldsControllers controllers;
  final DateTimeFieldsVariables variables;
  final DateTimeFieldsSetters setters;

  const DateTimeFields(
      {Key? key,
      required this.controllers,
      required this.variables,
      required this.setters})
      : super(key: key);

  @override
  State<DateTimeFields> createState() => _DateTimeFieldsState();
}

class _DateTimeFieldsState extends State<DateTimeFields>
    with InputValidationMixin {
  bool endTimeIsEnabled = false;
  bool isRoutineIsEnabled = false;

  onInitTimePickerTapped() async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if (pickedTime != null) {
      setState(() {
        if (pickedTime?.hour == 23 && pickedTime?.minute == 59) {
          pickedTime = pickedTime!.replacing(minute: 58);
        }
        int endHour = (pickedTime?.hour as int) + 1;
        int endMinute = pickedTime?.minute as int;
        if (endHour == 24) {
          endHour = 23;
          endMinute += 1;
        }
        TimeOfDay endTime =
            pickedTime!.replacing(hour: endHour, minute: endMinute);
        widget.controllers.initTime.text =
            pickedTime!.format(context).toString();
        widget.controllers.endTime.text = endTime.format(context).toString();
        endTimeIsEnabled = true;
      });
    }
  }

  onEndTimePickerTapped() async {
    int initHour = int.parse(widget.controllers.initTime.text.substring(0, 2));
    int initMinute =
        int.parse(widget.controllers.initTime.text.substring(3, 5));
    int finalHour = initHour;
    int finalMinute = initMinute + 1;
    if (finalMinute == 60) {
      finalHour = initHour + 1;
      finalMinute = 0;
    }
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime:
          TimeOfDay.now().replacing(hour: finalHour, minute: finalMinute),
      context: context,
    );
    if (pickedTime != null) {
      finalHour = pickedTime.hour;
      finalMinute = pickedTime.minute;
      if ((finalHour == initHour && finalMinute <= initMinute) ||
          finalHour < initHour) {
        finalHour = initHour;
        finalMinute = initMinute + 1;
        if (finalMinute == 60) {
          finalHour = initHour + 1;
          finalMinute = 0;
        }
        if (finalHour == 24) {
          finalHour = 0;
        }
        pickedTime = pickedTime.replacing(hour: finalHour, minute: finalMinute);
      }
      setState(() {
        widget.controllers.endTime.text =
            pickedTime!.format(context).toString();
      });
    }
  }

  onDatePickerTapped() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2200),
    );
    if (pickedDate is DateTime) {
      widget.controllers.date.text =
          DateFormat("dd/MM/yyyy").format(pickedDate);
      setState(() {
        isRoutineIsEnabled = true;
      });
    }
  }

  onEndDatePickerTapped() async {
    DateTime initialDate =
        DateFormat("dd/MM/yyyy").parse(widget.controllers.date.text);
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2200),
    );
    if (pickedDate is DateTime) {
      widget.controllers.endDate.text =
          DateFormat("dd/MM/yyyy").format(pickedDate);
    }
  }

  onIsRoutineChanged(value) {
    widget.setters.setIsRoutine(value);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      Row(
        children: [
          const Icon(
            FontAwesomeIcons.clock,
            color: Colors.grey,
            size: 20,
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
      Row(
        children: [
          Expanded(
            child: FormBuilderTextField(
              name: "init_time",
              controller: widget.controllers.initTime,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alarm),
                border: OutlineInputBorder(),
                labelText: "Hora Início",
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (description) => validateString(description, 0, 500),
              readOnly: true,
              onTap: onInitTimePickerTapped,
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: FormBuilderTextField(
              name: "end_time",
              controller: widget.controllers.endTime,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.alarm),
                border: OutlineInputBorder(),
                labelText: "Hora Fim",
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (description) => validateString(description, 0, 500),
              readOnly: true,
              onTap: onEndTimePickerTapped,
              enabled: endTimeIsEnabled,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 30,
      ),
      FormBuilderTextField(
        name: "date",
        controller: widget.controllers.date,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.calendar_month),
          border: OutlineInputBorder(),
          labelText: "Data",
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (description) => validateString(description, 0, 500),
        readOnly: true,
        onTap: onDatePickerTapped,
      ),
      const SizedBox(
        height: 30,
      ),
      FormBuilderSwitch(
        name: "is_routine",
        title: const Text(
          "Repetir?",
          style: TextStyle(fontSize: 15),
        ),
        enabled: isRoutineIsEnabled,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          prefixIcon: Icon(
            FontAwesomeIcons.arrowsRotate,
            size: 20,
          ),
        ),
        onChanged: onIsRoutineChanged,
      ),
    ];

    if (widget.variables.isRoutine) {
      children.addAll(
        [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              Expanded(
                child: FormBuilderDropdown(
                  name: "frequency",
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.repeat),
                    labelText: "Freq.",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (frequency) => validateString(frequency, 0, 500),
                  onChanged: (value) => widget.setters.setFrequency(value),
                  items: const [
                    DropdownMenuItem(
                      value: "D",
                      child: Text("Diária"),
                    ),
                    DropdownMenuItem(
                      value: "W",
                      child: Text("Semanal"),
                    ),
                    DropdownMenuItem(
                      value: "M",
                      child: Text("Mensal"),
                    ),
                    DropdownMenuItem(
                      value: "Y",
                      child: Text("Anual"),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: FormBuilderTextField(
                  name: "interval",
                  controller: widget.controllers.interval,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Intervalo",
                    prefixIcon: Icon(Icons.redo_sharp),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (interval) => validateString(interval, 0, 500),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 200,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
                style: BorderStyle.solid,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(5),
              ),
            ),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    child: const TabBar(
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                          text: "Até Dia",
                        ),
                        Tab(
                          text: "Vezes",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 110,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 8.0),
                      child: TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderTextField(
                              name: "end_date",
                              controller: widget.controllers.endDate,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.calendar_month),
                                border: OutlineInputBorder(),
                                labelText: "Data Final",
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (description) =>
                                  validateString(description, 0, 500),
                              readOnly: true,
                              onTap: onEndDatePickerTapped,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FormBuilderTextField(
                              name: "times",
                              controller: widget.controllers.times,
                              keyboardType: TextInputType.number,
                              validator: (description) =>
                                  validateString(description, 0, 500),
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Vezes",
                                prefixText: "(X) ",
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      );
    }

    return Column(
      children: children,
    );
  }
}
