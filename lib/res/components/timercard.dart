import 'package:alarm_app/res/fonts/appfont.dart';
import 'package:flutter/material.dart';

class TimerCard extends StatelessWidget {
  final String hour;
  final String minute;
  final String second;
  const TimerCard(
      {super.key,
      required this.hour,
      required this.minute,
      required this.second});

  @override
  Widget build(BuildContext context) {
    Brightness current = Theme.of(context).brightness;
    Color textColor = current == Brightness.light ? Colors.black : Colors.white;
    Color backgroundColor =
        current != Brightness.light ? Colors.black : Colors.white;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 100,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]),
          child: Center(
            child: Text(
              hour,
              style: AppFont.mediumText(40, textColor),
            ),
          ),
        ),
        const SizedBox(width: 13),
        Text(":", style: AppFont.mediumText(30, textColor)),
        const SizedBox(width: 13),
        Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 100,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]),
          child: Center(
            child: Text(
              minute,
              style: AppFont.mediumText(40, textColor),
            ),
          ),
        ),
        const SizedBox(width: 13),
        Text(":", style: AppFont.mediumText(30, textColor)),
        const SizedBox(width: 13),
        Container(
          width: MediaQuery.of(context).size.width / 5,
          height: 100,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                )
              ]),
          child: Center(
            child: Text(
              second,
              style: AppFont.mediumText(40, textColor),
            ),
          ),
        ),
      ],
    );
  }
}
