import 'package:flutter/material.dart';

class ErrorDisplay extends StatelessWidget {
  final String msg;
  const ErrorDisplay({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.warning,
              color: Color.fromARGB(255, 255, 6, 6),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              msg,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
