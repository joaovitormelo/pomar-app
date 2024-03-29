import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/presentation/helpers/input_validation_mixin.dart';
import 'package:pomar_app/features/schedule/presentation/pages/add_event_page.dart';

import '../../../../core/utils/Utils.dart';

class DateTimeFieldsVariables {
  final bool allDay;
  final bool endTimeIsEnabled;
  final bool isRoutineIsEnabled;
  final bool isRoutine;
  final String? frequency;
  final String? weekDays;
  final bool undefinedEnd;
  final EndMode endMode;

  DateTimeFieldsVariables({
    required this.allDay,
    required this.endTimeIsEnabled,
    required this.isRoutineIsEnabled,
    required this.isRoutine,
    required this.frequency,
    required this.weekDays,
    required this.undefinedEnd,
    required this.endMode,
  });
}

class DateTimeFieldsSetters {
  final setAllDay;
  final setEndTimeIsEnabled;
  final setIsRoutineIsEnabled;
  final setIsRoutine;
  final setFrequency;
  final setWeekDays;
  final setUndefinedEnd;
  final setEndMode;

  DateTimeFieldsSetters({
    required this.setAllDay,
    required this.setEndTimeIsEnabled,
    required this.setIsRoutineIsEnabled,
    required this.setIsRoutine,
    required this.setFrequency,
    required this.setWeekDays,
    required this.setUndefinedEnd,
    required this.setEndMode,
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
        widget.setters.setEndTimeIsEnabled(true);
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
      widget.setters.setIsRoutineIsEnabled(true);
    }
  }

  onEndDatePickerTapped() async {
    DateTime initialDate =
        DateFormat("dd/MM/yyyy").parse(widget.controllers.date.text);
    if (DateTime.now().compareTo(initialDate) > 0) {
      initialDate = DateTime.now();
    }
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

  onAllDayChanged(value) {
    widget.setters.setAllDay(value);
  }

  getInitDateWeekDay() {
    DateTime dateInit =
        DateFormat("dd/MM/yyyy").parse(widget.controllers.date.text);
    return dateInit.weekday % 7 + 1;
  }

  onFrequencyChanged(value) {
    widget.setters.setFrequency(value);
    String? weekDays = widget.variables.weekDays;
    if (weekDays == null) {
      widget.setters.setWeekDays(getInitDateWeekDay().toString());
    }
  }

  checkIfWeekDayIsSelected(value) {
    if (widget.variables.weekDays == null) return false;
    return (widget.variables.weekDays as String).contains(value);
  }

  onSelectedWeekDay(value, isSelected) {
    if (value == getInitDateWeekDay().toString()) {
      return;
    }
    String? weekDays = widget.variables.weekDays;
    if (weekDays == null) {
      widget.setters.setWeekDays(value);
    } else {
      if (isSelected) {
        widget.setters.setWeekDays(weekDays + value);
      } else {
        widget.setters.setWeekDays(weekDays.replaceFirst(value, ''));
      }
    }
  }

  onUndefinedEndChanged(value) {
    widget.setters.setUndefinedEnd(value);
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
      FormBuilderSwitch(
        name: "all_day",
        title: const Text(
          "Dia todo?",
          style: TextStyle(fontSize: 15),
        ),
        initialValue: widget.variables.allDay,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          prefixIcon: Icon(
            FontAwesomeIcons.calendarDay,
            size: 20,
          ),
        ),
        onChanged: onAllDayChanged,
      ),
    ];
    if (!widget.variables.allDay) {
      children.addAll([
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
                enabled: widget.variables.endTimeIsEnabled,
              ),
            ),
          ],
        ),
      ]);
    }

    var dataLabel = "Data";
    if (widget.variables.isRoutine) {
      dataLabel = "Data inicial";
    }

    children.addAll([
      const SizedBox(
        height: 30,
      ),
      FormBuilderTextField(
        name: "date",
        controller: widget.controllers.date,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_month),
          border: const OutlineInputBorder(),
          labelText: dataLabel,
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
        initialValue: widget.variables.isRoutine,
        enabled: widget.variables.isRoutineIsEnabled,
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
    ]);

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
                  initialValue: widget.variables.frequency,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.repeat),
                    labelText: "Freq.",
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (frequency) => validateString(frequency, 0, 500),
                  onChanged: onFrequencyChanged,
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
        ],
      );
      if (widget.variables.frequency == "W") {
        children.addAll([
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterChip(
                label: const Text("Dom"),
                onSelected: (isSelected) => onSelectedWeekDay("1", isSelected),
                selected: checkIfWeekDayIsSelected("1"),
                selectedColor: Colors.blue,
                showCheckmark: false,
                disabledColor: Colors.grey,
              ),
              FilterChip(
                label: const Text("Seg"),
                onSelected: (isSelected) => onSelectedWeekDay("2", isSelected),
                selected: checkIfWeekDayIsSelected("2"),
                selectedColor: Colors.blue,
                showCheckmark: false,
                disabledColor: Colors.grey,
              ),
              FilterChip(
                label: const Text("Ter"),
                onSelected: (isSelected) => onSelectedWeekDay("3", isSelected),
                selected: checkIfWeekDayIsSelected("3"),
                selectedColor: Colors.blue,
                showCheckmark: false,
                disabledColor: Colors.grey,
              ),
              FilterChip(
                label: const Text("Qua"),
                onSelected: (isSelected) => onSelectedWeekDay("4", isSelected),
                selected: checkIfWeekDayIsSelected("4"),
                selectedColor: Colors.blue,
                showCheckmark: false,
                disabledColor: Colors.grey,
              ),
              FilterChip(
                label: const Text("Qui"),
                onSelected: (isSelected) => onSelectedWeekDay("5", isSelected),
                selected: checkIfWeekDayIsSelected("5"),
                selectedColor: Colors.blue,
                showCheckmark: false,
                disabledColor: Colors.grey,
              ),
              FilterChip(
                label: const Text("Sex"),
                onSelected: (isSelected) => onSelectedWeekDay("6", isSelected),
                selected: checkIfWeekDayIsSelected("6"),
                selectedColor: Colors.blue,
                showCheckmark: false,
                disabledColor: Colors.grey,
              ),
              FilterChip(
                label: const Text("Sáb"),
                onSelected: (isSelected) => onSelectedWeekDay("7", isSelected),
                selected: checkIfWeekDayIsSelected("7"),
                selectedColor: Colors.blue,
                showCheckmark: false,
                disabledColor: Colors.grey,
              ),
            ],
          ),
        ]);
      }
      children.addAll(
        [
          const SizedBox(
            height: 30,
          ),
          FormBuilderSwitch(
            name: "undefined_end",
            title: const Text(
              "Final indefinido",
              style: TextStyle(fontSize: 15),
            ),
            initialValue: widget.variables.undefinedEnd,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 10,
              ),
              prefixIcon: Icon(
                FontAwesomeIcons.infinity,
                size: 20,
              ),
            ),
            onChanged: onUndefinedEndChanged,
          ),
        ],
      );

      if (!widget.variables.undefinedEnd) {
        children.addAll([
          const SizedBox(
            height: 30,
          ),
          Container(
            height: 175,
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
              initialIndex: widget.variables.endMode == EndMode.endDate ? 0 : 1,
              length: 2,
              child: Column(
                children: [
                  Container(
                    color: Colors.blue,
                    child: TabBar(
                      onTap: (value) {
                        if (value == 1) {
                          widget.setters.setEndMode(EndMode.times);
                        } else {
                          widget.setters.setEndMode(EndMode.endDate);
                        }
                      },
                      indicatorColor: Colors.white,
                      tabs: const [
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
          ),
        ]);
      }
    }

    return Column(
      children: children,
    );
  }
}
