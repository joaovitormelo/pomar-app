import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:pomar_app/features/schedule/data/models/event_info_model.dart';

class EventModel extends Equatable {
  final int idEvent;
  final EventInfoModel eventInfo;
  final String date;

  EventModel({
    required this.idEvent,
    required this.eventInfo,
    required this.date,
  });

  factory EventModel.fromJSON(Map<String, dynamic> event) {
    return EventModel(
      idEvent: event['id_event'],
      eventInfo: EventInfoModel.fromJSON(event['event_info']),
      date: event['date'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_event": idEvent,
      "event_info": eventInfo.toJSON(),
      "date": date,
    };
  }

  @override
  List<Object?> get props => [idEvent, eventInfo, date];
}
