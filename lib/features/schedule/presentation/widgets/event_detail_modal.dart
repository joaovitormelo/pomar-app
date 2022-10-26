import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/core/utils/utils.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';

const textEventDetailModalTitle = "Detalhes do evento";
const double sizeInfoText = 18;
const double sizeLabeltext = 15;
const double spacementRows = 30;

class EventDetailModal extends StatelessWidget {
  final EventData eventD;
  final List<Employee> employeeList;
  final onEditButtonPressed;

  const EventDetailModal(
      {Key? key,
      required this.eventD,
      required this.employeeList,
      required this.onEditButtonPressed})
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
    if (!event.eventInfo.isRoutine) {
      textDate += DateFormat("dd/MM/yyyy").format(Utils.strToDate(event.date));
    } else {
      if (event.eventInfo.frequency == 'D') {
        if (event.eventInfo.interval == 1) {
          textDate += 'Todos os dias';
        } else {
          textDate += 'A cada ${event.eventInfo.interval} dias';
        }
      } else if (event.eventInfo.frequency == 'W') {
        if (event.eventInfo.interval == 1) {
          textDate += 'Toda semana';
        } else {
          textDate += 'A cada ${event.eventInfo.interval} semanas';
        }
      } else if (event.eventInfo.frequency == 'M') {
        if (event.eventInfo.interval == 1) {
          textDate += 'Todo mês';
        } else {
          textDate += 'A cada ${event.eventInfo.interval} meses';
        }
      }
      if (!(event.eventInfo.undefinedEnd as bool)) {
        textDate += ', ';
        if (event.eventInfo.endDate != null) {
          textDate +=
              'até ${DateFormat("dd/MM/yyyy").format(Utils.strToDate(event.eventInfo.endDate as String))}';
        } else {
          textDate += '${event.eventInfo.times} vezes';
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
    if (event.eventInfo.allDay) {
      textTime += "Dia todo";
    } else {
      textTime += (event.eventInfo.initTime as String).substring(0, 5);
      if (event.eventInfo.endTime != null) {
        String endTime = (event.eventInfo.endTime as String).substring(0, 5);
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
    if (event.eventInfo.isCollective as bool) {
      if (completedCount > 0) {
        isCompleted = true;
      }
    } else {
      if (completedCount == assignments.length) {
        isCompleted = true;
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
            Expanded(
              child: Text(
                employeeName,
                style: const TextStyle(fontSize: sizeInfoText),
              ),
            ),
            Text(
              "Status: $statusText",
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
        event.eventInfo.description,
        style: const TextStyle(fontSize: sizeInfoText),
      )
    ];

    return descriptionColumnChildren;
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
            onPressed: () {},
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
        event.eventInfo.title,
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

    if (event.eventInfo.isTask) {
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
