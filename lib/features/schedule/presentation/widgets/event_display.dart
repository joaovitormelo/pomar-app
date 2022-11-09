import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/features/schedule/data/models/assignment_model.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:table_calendar/table_calendar.dart';

class EventDisplay extends StatelessWidget {
  final EventData eventD;
  final DateTime day;
  final onEventPressed;
  const EventDisplay(
      {Key? key,
      required this.eventD,
      required this.day,
      required this.onEventPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String textTime = '';
    EventModel event = eventD.event;
    List<AssignmentModel> assignmentList = eventD.assignments;
    if (event.initTime != null && event.endTime != null) {
      String endTime = event.endTime as String;
      textTime =
          '${(event.initTime as String).substring(0, 5)} - ${endTime.substring(0, 5)}';
    }
    late Color color;
    bool taskIsCompleted = false;
    var completedCount = 0;
    var assignmentsCount = assignmentList.length;
    if (event.isTask) {
      color = Colors.green;
      assignmentList.map((assignment) {
        if (assignment.isCompleted == true) {
          completedCount += 1;
        }
      }).toList();
      if (isSameDay(day, DateTime.now())) {
        if (event.isCollective as bool) {
          if (completedCount > 0) {
            taskIsCompleted = true;
          }
        } else {
          if (completedCount == assignmentsCount) {
            taskIsCompleted = true;
          }
        }
      }
    } else {
      color = Colors.blue;
    }
    List<Widget> row1Children = [];
    row1Children.add(Text(
      event.title,
      textAlign: TextAlign.left,
      style: TextStyle(
        color: Colors.white,
        fontSize: 13,
        decoration: taskIsCompleted ? TextDecoration.lineThrough : null,
        decorationThickness: 2,
      ),
    ));
    if (event.isRoutine) {
      row1Children.add(
        const Icon(
          FontAwesomeIcons.arrowsRotate,
          color: Colors.white,
          size: 13,
        ),
      );
    }
    List<Widget> collumn1Children = [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: row1Children,
      )
    ];
    if (!event.allDay) {
      collumn1Children.add(Text(
        textTime,
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ));
    }
    List<Widget> row2Children = [];
    if (event.isTask) {
      row2Children.add(
        const Padding(
          padding: EdgeInsets.all(5),
          child: Icon(
            FontAwesomeIcons.listCheck,
            size: 18,
            color: Colors.white,
          ),
        ),
      );
    }
    row2Children.add(Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: collumn1Children,
        ),
      ),
    ));
    return GestureDetector(
      onTap: onEventPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: row2Children,
            ),
          ),
        ),
      ),
    );
  }
}
