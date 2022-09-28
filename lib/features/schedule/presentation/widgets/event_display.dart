import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';

class EventDisplay extends StatelessWidget {
  final EventData eventD;
  final onEventPressed;
  const EventDisplay(
      {Key? key, required this.eventD, required this.onEventPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String textTime = '';
    EventModel event = eventD.event;
    if (event.eventInfo.endTime != null) {
      String endTime = event.eventInfo.endTime as String;
      textTime =
          '${event.eventInfo.initTime.substring(0, 5)} - ${endTime.substring(0, 5)}';
    } else {
      textTime = event.eventInfo.initTime.substring(0, 5);
    }
    late Color color;
    if (event.eventInfo.isTask) {
      color = Colors.green;
    } else {
      color = Colors.blue;
    }
    List<Widget> row1Children = [];
    row1Children.add(Text(
      event.eventInfo.title,
      textAlign: TextAlign.left,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          decoration: TextDecoration.none), //TextDecoration.lineThrough
    ));
    if (event.eventInfo.isRoutine) {
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
    if (!event.eventInfo.allDay) {
      collumn1Children.add(Text(
        textTime,
        textAlign: TextAlign.left,
        style: const TextStyle(color: Colors.white, fontSize: 13),
      ));
    }
    List<Widget> row2Children = [];
    if (event.eventInfo.isTask) {
      row2Children.add(
        Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.check_box_outlined,
                size: 18,
                color: Colors.white,
              ),
              Text(
                "(1/2)",
                style: TextStyle(fontSize: 10, color: Colors.white),
              )
            ],
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
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: row2Children,
          ),
        ),
      ),
    );
  }
}
