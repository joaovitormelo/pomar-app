import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:table_calendar/table_calendar.dart';

const textEventDetailModalTitle = "Detalhes do evento";
const double sizeInfoText = 18;
const double sizeLabeltext = 15;
const double spacementRows = 30;

class EventDetailModal extends StatelessWidget {
  final EventData eventD;
  final List<Employee> employeeList;
  final onEditButtonPressed;
  final onDelete;
  final DateTime day;

  const EventDetailModal(
      {Key? key,
      required this.eventD,
      required this.employeeList,
      required this.onEditButtonPressed,
      required this.onDelete,
      required this.day})
      : super(key: key);

  _getTimeColumnChildren(EventModel event) {
    List<Widget> timeColumnChildren = [
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
          const Text("Data/Hora",
              style: TextStyle(fontSize: sizeLabeltext, color: Colors.grey)),
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
        height: 10,
      ),
    ];

    var textDate = '';
    if (!event.isRoutine) {
      textDate += DateFormat("dd/MM/yyyy").format(Utils.strToDate(event.date));
    } else {
      if (event.frequency == 'D') {
        if (event.interval == 1) {
          textDate += 'Todos os dias';
        } else {
          textDate += 'A cada ${event.interval} dias';
        }
      } else if (event.frequency == 'W') {
        if (event.interval == 1) {
          textDate += 'Toda semana';
        } else {
          textDate += 'A cada ${event.interval} semanas';
        }
      } else if (event.frequency == 'M') {
        if (event.interval == 1) {
          textDate += 'Todo mês';
        } else {
          textDate += 'A cada ${event.interval} meses';
        }
      }
      if (!(event.undefinedEnd as bool)) {
        textDate += ', ';
        if (event.endDate != null) {
          textDate +=
              'até ${DateFormat("dd/MM/yyyy").format(Utils.strToDate(event.endDate as String))}';
        } else {
          textDate += '${event.times} vezes';
        }
      }
    }
    timeColumnChildren.addAll([
      Text(
        textDate,
        style: const TextStyle(fontSize: sizeInfoText),
      ),
      const SizedBox(
        height: 5,
      ),
    ]);

    var textTime = '';
    if (event.allDay) {
      textTime += "Dia todo";
    } else {
      textTime += (event.initTime as String).substring(0, 5);
      if (event.endTime != null) {
        String endTime = (event.endTime as String).substring(0, 5);
        textTime += " às $endTime";
      }
    }
    timeColumnChildren.add(
      Text(
        textTime,
        style: const TextStyle(fontSize: sizeInfoText),
      ),
    );

    return timeColumnChildren;
  }

  _getAssignmentsColumnChildren(
      EventModel event, List<AssignmentModel> assignments) {
    List<Widget> assignmentsColumnChildren = [
      Row(
        children: [
          const Icon(
            FontAwesomeIcons.listCheck,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text("Atribuições",
              style: TextStyle(fontSize: sizeLabeltext, color: Colors.grey)),
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
        height: 10,
      ),
    ];

    int completedCount = 0;
    assignments.map((AssignmentModel assignment) {
      if (assignment.isCompleted) {
        completedCount++;
      }
    }).toList();

    bool isCompleted = false;
    if (isSameDay(day, DateTime.now())) {
      if (event.isCollective as bool) {
        if (completedCount > 0) {
          isCompleted = true;
        }
      } else {
        if (completedCount == assignments.length) {
          isCompleted = true;
        }
      }
    }

    assignmentsColumnChildren.addAll([
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Situação da tarefa: ",
            style: TextStyle(fontSize: sizeInfoText),
          ),
          isCompleted
              ? const Icon(Icons.check)
              : const Icon(FontAwesomeIcons.minus),
        ],
      ),
    ]);

    assignments.map((AssignmentModel assignment) {
      String employeeName = '';
      employeeList.map((Employee employee) {
        if (employee.idEmployee == assignment.idEmployee) {
          employeeName = employee.person.name;
        }
      }).toList();
      String statusText = '';
      if (assignment.isCompleted) {
        statusText += 'Concluída';
      } else {
        statusText += 'Pendente';
      }
      assignmentsColumnChildren.addAll([
        const SizedBox(
          height: 10,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              FontAwesomeIcons.user,
              size: sizeInfoText,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              employeeName,
              style: const TextStyle(fontSize: sizeInfoText),
            ),
          ],
        ),
      ]);
    }).toList();

    return assignmentsColumnChildren;
  }

  _getDescriptionColumnChildren(EventModel event) {
    List<Widget> descriptionColumnChildren = [
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
          const Text("Descrição",
              style: TextStyle(fontSize: sizeLabeltext, color: Colors.grey)),
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
        height: 10,
      ),
      Text(
        event.description,
        style: const TextStyle(fontSize: sizeInfoText),
      )
    ];

    return descriptionColumnChildren;
  }

  _onDeleteButtonPressed(context, EventModel event) {
    if (event.isRoutine) {
      showDialog(
          context: context, builder: (context) => _getDialog(context, event));
    } else {
      onDelete(day, event, true);
    }
  }

  _onAllRoutineSelected(context, EventModel event) {
    Navigator.pop(context);
    onDelete(
      day,
      event,
      true,
    );
  }

  _onOnlyEventSelected(context, EventModel event) {
    Navigator.pop(context);
    onDelete(
      day,
      event,
      false,
    );
  }

  _getDialog(context, EventModel event) {
    return AlertDialog(
      title: const Text("Deletar evento"),
      content:
          const Text("Deseja deletar toda a rotina ou somente esse evento?"),
      actions: [
        TextButton(
          onPressed: () => _onAllRoutineSelected(context, event),
          child: const Text("Rotina toda"),
        ),
        TextButton(
          onPressed: () => _onOnlyEventSelected(context, event),
          child: const Text("Somente evento"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    EventModel event = eventD.event;
    List<AssignmentModel> assignments = eventD.assignments;

    List<Widget> columnChildren = [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              onEditButtonPressed(eventD);
            },
            child: const Text("Editar"),
          ),
          TextButton(
            onPressed: () {
              _onDeleteButtonPressed(context, eventD.event);
            },
            child: const Text(
              "Excluir",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      const Text(
        textEventDetailModalTitle,
        style: TextStyle(fontSize: 16),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        event.title,
        style: const TextStyle(fontSize: 30),
      ),
      const SizedBox(
        height: spacementRows,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getTimeColumnChildren(event),
      ),
    ];

    if (event.isTask) {
      columnChildren.addAll([
        const SizedBox(
          height: spacementRows,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _getAssignmentsColumnChildren(event, assignments),
        ),
      ]);
    }

    columnChildren.addAll([
      const SizedBox(
        height: spacementRows,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _getDescriptionColumnChildren(event),
      ),
    ]);

    return Container(
      height: 600,
      padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnChildren,
      ),
    );
  }
}
