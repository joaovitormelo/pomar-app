import 'package:flutter/material.dart';
import 'package:pomar_app/core/utils/Utils.dart';
import 'package:pomar_app/features/employee/domain/entities/employee.dart';
import 'package:pomar_app/features/schedule/data/models/event_model.dart';
import 'package:pomar_app/features/schedule/domain/usecases/do_read_events.dart';
import 'package:pomar_app/features/schedule/presentation/widgets/event_display.dart';
import 'package:table_calendar/table_calendar.dart';

const weekDays = ["SEG", "TER", "QUA", "QUI", "SEX", "SÁB", "DOM"];

class CustomCalendarPage extends StatefulWidget {
  final List<EventData> eventDataList;
  final List<Employee> employeeList;
  final onEventPressed;

  const CustomCalendarPage(
      {Key? key,
      required this.eventDataList,
      required this.employeeList,
      required this.onEventPressed})
      : super(key: key);

  @override
  State<CustomCalendarPage> createState() => _CustomCalendarPageState();
}

class _CustomCalendarPageState extends State<CustomCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  _determineIfDailyRoutineEventExistsInDay(EventModel event, DateTime day) {
    DateTime date = Utils.strToDate(event.date);
    var diff = day.difference(date);
    var divisionRest = diff.inDays % (event.eventInfo.interval as int);
    if (divisionRest == 0) {
      if (event.eventInfo.undefinedEnd as bool) {
        return true;
      } else {
        if (event.eventInfo.endDate != null) {
          if (date.compareTo(
                  Utils.strToDate(event.eventInfo.endDate as String)) <=
              0) {
            return true;
          } else {
            return false;
          }
        } else {
          var divisionQuocient =
              diff.inDays / (event.eventInfo.interval as int).floor();
          if (divisionQuocient <= (event.eventInfo.times as int)) {
            return true;
          } else {
            return false;
          }
        }
      }
    } else {
      return false;
    }
  }

  _determineIfWeeklyRoutineEventExistsInDay(EventModel event, DateTime day) {
    DateTime date = Utils.strToDate(event.date);
    var diff = day.difference(date);
    var divisionRest = diff.inDays % 7 * (event.eventInfo.interval as int);
    if (divisionRest == 0) {
      if (event.eventInfo.undefinedEnd as bool) {
        return true;
      } else {
        if (event.eventInfo.endDate != null) {
          if (date.compareTo(
                  Utils.strToDate(event.eventInfo.endDate as String)) <=
              0) {
            return true;
          } else {
            return false;
          }
        } else {
          var divisionQuocient =
              diff.inDays / 7 * (event.eventInfo.interval as int).floor();
          if (divisionQuocient <= (event.eventInfo.times as int)) {
            return true;
          } else {
            return false;
          }
        }
      }
    } else {
      return false;
    }
  }

  _determineIfMonthlyRoutineEventExistsInDay(EventModel event, DateTime day) {
    DateTime date = Utils.strToDate(event.date);
    var monthDiff = day.month - date.month;
    var divisionRest = monthDiff % (event.eventInfo.interval as int);
    if (date.day == day.day && divisionRest == 0) {
      if (event.eventInfo.undefinedEnd as bool) {
        return true;
      } else {
        if (event.eventInfo.endDate != null) {
          if (date.compareTo(
                  Utils.strToDate(event.eventInfo.endDate as String)) <=
              0) {
            return true;
          } else {
            return false;
          }
        } else {
          var divisionQuocient =
              monthDiff / (event.eventInfo.interval as int).floor();
          if (divisionQuocient <= (event.eventInfo.times as int)) {
            return true;
          } else {
            return false;
          }
        }
      }
    } else {
      return false;
    }
  }

  _determineIfYearlyRoutineEventExistsInDay(EventModel event, DateTime day) {
    DateTime date = Utils.strToDate(event.date);
    var yearDiff = day.year - date.year;
    var divisionRest = yearDiff % (event.eventInfo.interval as int);
    if (date.day == day.day && date.month == day.month && divisionRest == 0) {
      if (event.eventInfo.undefinedEnd as bool) {
        return true;
      } else {
        if (event.eventInfo.endDate != null) {
          if (date.compareTo(
                  Utils.strToDate(event.eventInfo.endDate as String)) <=
              0) {
            return true;
          } else {
            return false;
          }
        } else {
          var divisionQuocient =
              yearDiff / (event.eventInfo.interval as int).floor();
          if (divisionQuocient <= (event.eventInfo.times as int)) {
            return true;
          } else {
            return false;
          }
        }
      }
    } else {
      return false;
    }
  }

  _loadEventsPerDay(DateTime day, List<EventData> eventDataList) {
    return eventDataList.where((eventData) {
      var event = eventData.event;
      DateTime date = Utils.strToDate(event.date);
      if (event.eventInfo.isRoutine) {
        var diff = day.difference(date);
        if (diff.inSeconds < 0) {
          return false;
        } else {
          if (event.eventInfo.frequency == "D") {
            return _determineIfDailyRoutineEventExistsInDay(event, day);
          } else if (event.eventInfo.frequency == "W") {
            return _determineIfWeeklyRoutineEventExistsInDay(event, day);
          } else if (event.eventInfo.frequency == "M") {
            return _determineIfMonthlyRoutineEventExistsInDay(event, day);
          } else {
            return _determineIfYearlyRoutineEventExistsInDay(event, day);
          }
        }
      } else {
        if (isSameDay(date, day)) {
          return true;
        }
        return false;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: _focusedDay,
          firstDay: DateTime(2022, 1, 1),
          lastDay: DateTime(2122, 1, 1),
          locale: 'pt_BR',
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          headerStyle: const HeaderStyle(formatButtonVisible: false),
          eventLoader: (DateTime day) =>
              _loadEventsPerDay(day, widget.eventDataList),
          calendarStyle: const CalendarStyle(
            markerSize: 5,
          ),
          calendarBuilders: CalendarBuilders(
            selectedBuilder: (context, day, focusedDay) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  style: BorderStyle.solid,
                  width: 2,
                ),
              ),
              child: Builder(builder: (context) {
                if (isSameDay(day, DateTime.now())) {
                  return Container(
                    alignment: Alignment.center,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent.shade100,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Text(
                      day.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }
                return Text(
                  day.day.toString(),
                );
              }),
            ),
            todayBuilder: (context, day, focusedDay) => Center(
              child: Container(
                alignment: Alignment.center,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.shade100,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Text(
                  day.day.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          availableGestures: AvailableGestures.horizontalSwipe,
        ),
        const Divider(
          thickness: 0.5,
        ),
        SingleChildScrollView(
          child: Builder(builder: (context) {
            if (_selectedDay != null) {
              Color color = Colors.blue;
              if (isSameDay(_selectedDay, DateTime.now())) {
                color = Colors.blueAccent.shade100;
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          weekDays[_selectedDay!.weekday - 1],
                          style: const TextStyle(
                            fontSize: 13,
                            decorationStyle: TextDecorationStyle.solid,
                            color: Colors.blue,
                          ),
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              _selectedDay!.day.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Builder(builder: (context) {
                          List<EventData> events = _loadEventsPerDay(
                              _selectedDay as DateTime, widget.eventDataList);
                          if (events.isEmpty) {
                            return const Text(
                              "Sem eventos",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            );
                          } else {
                            return SingleChildScrollView(
                              child: Container(
                                height: 300,
                                child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(height: 5),
                                  itemCount: events.length,
                                  itemBuilder: (context, index) => EventDisplay(
                                    eventD: events[index],
                                    onEventPressed: () => widget.onEventPressed(
                                        events[index], widget.employeeList),
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Nenhuma data selecionada",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}
