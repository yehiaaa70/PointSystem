import 'package:flutter/cupertino.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

Widget circularPercentIndicator({
  required String fotterText,
  required String centerText,
  int percent = 100,
}) {
  return Expanded(
    child: CircularPercentIndicator(
      footer: Text(
        fotterText,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      radius: 85.0,
      lineWidth: 17.0,
      percent: percent / 100,
      animation: true,
      center:  Text(
        centerText,
        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      animationDuration: 3000,
      progressColor: const Color.fromRGBO(14, 113, 179, 1.0),
    ),
  );
}
