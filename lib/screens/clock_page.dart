import 'dart:async';

import 'package:alarm_app/res/components/clock.dart';
import 'package:alarm_app/res/fonts/appfont.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockPage extends StatefulWidget {
  const ClockPage({super.key});

  @override
  State<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  late double heigh;
  late double weigh;

  @override
  Widget build(BuildContext context) {
    Brightness current = Theme.of(context).brightness;
    Color textColor = current == Brightness.light ? Colors.black : Colors.white;

    var now = DateTime.now();

    var timeZoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetsign = '';
    if (!timeZoneString.startsWith('-')) offsetsign = '+';
    heigh = MediaQuery.of(context).size.height;
    weigh = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(30),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DigitalClockWidget(),
              ],
            ),
          ),
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: MyClock(size: heigh / 2.5),
          ),
          SizedBox(
            height: heigh * 0.05,
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              children: [
                Text('Timezone', style: AppFont.smallText(24, textColor)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.language,
                      color: Colors.blue.shade200,
                    ),
                    SizedBox(
                      width: weigh * 0.03,
                    ),
                    Text('IST $offsetsign${timeZoneString.substring(0, 4)}',
                        style: AppFont.smallText(30, textColor)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DigitalClockWidget extends StatefulWidget {
  const DigitalClockWidget({
    Key? key,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DigitalClockWidgetState();
  }
}

class DigitalClockWidgetState extends State<DigitalClockWidget> {
  var formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        formattedTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Brightness current = Theme.of(context).brightness;
    Color textColor = current == Brightness.light ? Colors.black : Colors.white;
    return Text(
      formattedTime,
      style: AppFont.headText(60, textColor),
    );
  }
}
