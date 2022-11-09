import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final int idEvent;
  final String date;
  final String title;
  final String? initTime;
  final String? endTime;
  final bool allDay;
  final String description;
  final bool isTask;
  final bool? isCollective;
  final bool isRoutine;
  final String? initDate;
  final String? frequency;
  final int? interval;
  final String? weekDays;
  final bool? undefinedEnd;
  final String? endDate;
  final int? times;

  EventModel({
    required this.idEvent,
    required this.date,
    required this.title,
    required this.initTime,
    required this.endTime,
    required this.allDay,
    required this.description,
    required this.isTask,
    required this.isCollective,
    required this.isRoutine,
    required this.initDate,
    required this.frequency,
    required this.interval,
    required this.weekDays,
    required this.undefinedEnd,
    required this.endDate,
    required this.times,
  });

  factory EventModel.fromJSON(Map<String, dynamic> event) {
    return EventModel(
      idEvent: event['id_event'],
      date: event['date'],
      title: event['title'],
      initTime: event['init_time'],
      endTime: event['end_time'],
      allDay: event['all_day'],
      description: event['description'],
      isTask: event['is_task'],
      isCollective: event['is_collective'],
      isRoutine: event['is_routine'],
      initDate: event['init_date'],
      frequency: event['frequency'],
      interval: event['interval'],
      weekDays: event['week_days'],
      undefinedEnd: event['undefined_end'],
      endDate: event['end_date'],
      times: event['times'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "id_event": idEvent,
      "date": date,
      'title': title,
      'init_time': initTime,
      'end_time': endTime,
      'all_day': allDay,
      'description': description,
      'is_task': isTask,
      'is_collective': isCollective,
      'is_routine': isRoutine,
      'frequency': frequency,
      'interval': interval,
      'week_days': weekDays,
      'undefined_end': undefinedEnd,
      'end_date': endDate,
      'times': times,
    };
  }

  @override
  List<Object?> get props => [idEvent, date];
}
