import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

class Utils {
  static showSnackBar(context, message) {
    ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }

  static showLoadingEntirePage(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            color: Colors.grey,
            width: 60,
            height: 60,
            padding: const EdgeInsets.all(5),
            child: const CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  static strToDateTime(String dateTime) {
    int year = int.parse(dateTime.substring(0, 4));
    int month = int.parse(dateTime.substring(5, 7));
    int day = int.parse(dateTime.substring(8, 10));
    int hour = int.parse(dateTime.substring(11, 13));
    int minutes = int.parse(dateTime.substring(14, 16));
    return DateTime(year, month, day, hour, minutes);
  }

  static strToDate(String date) {
    int year = int.parse(date.substring(0, 4));
    int month = int.parse(date.substring(5, 7));
    int day = int.parse(date.substring(8, 10));
    return DateTime(year, month, day);
  }

  static convertDateStrPattern(
      String dateStr, String oldPattern, String newPattern) {
    return DateFormat(newPattern).format(
      DateFormat(oldPattern).parse(
        dateStr,
      ),
    );
  }
}
