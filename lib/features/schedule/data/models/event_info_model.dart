import 'package:equatable/equatable.dart';

class EventInfoModel extends Equatable {
  final int idEventInfo;
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
  final String? endDate;
  final int? times;

  EventInfoModel({
    required this.idEventInfo,
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
    required this.endDate,
    required this.times,
  });

  factory EventInfoModel.fromJSON(Map<String, dynamic> event) {
    return EventInfoModel(
      idEventInfo: event["id_event_info"],
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
      endDate: event['end_date'],
      times: event['times'],
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id_event_info': idEventInfo,
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
      'end_date': endDate,
      'times': times,
    };
  }

  @override
  List<Object?> get props => [idEventInfo, title, initTime, endTime];
}
