import 'package:alarm_app/controllers/timer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimerInput extends StatefulWidget {
  final String range;
  final int option;
  const TimerInput({super.key, required this.range, required this.option});

  @override
  State<TimerInput> createState() => _TimerInputState();
}

class _TimerInputState extends State<TimerInput> {
  TimerController controller = Get.put(TimerController());

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              width: 60,
              height: 70,
              child: Obx(
                () => TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                      text: getValue(widget.option).toString()),
                  onSubmitted: (value) {
                    if (int.parse(value) > int.parse(widget.range)) {
                      controller.setvalue(
                          int.parse(widget.range), widget.option);
                      Get.snackbar("Value Error",
                          "You cannot enter the value more than the ${widget.range}");
                    } else {
                      controller.setvalue(int.parse(value), widget.option);
                    }
                  },
                  maxLength: 2,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 232, 140, 227)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
                onPressed: () {
                  int r = int.parse(widget.range);
                  int t = getValue(widget.option);
                  if (t == r) {
                    controller.setvalue(0, widget.option);
                  } else {
                    controller.setvalue(t + 1, widget.option);
                  }
                },
                icon: const Icon(
                  Icons.arrow_drop_up_outlined,
                  size: 40,
                )),
            IconButton(
              onPressed: () {
                int t = getValue(widget.option);
                if (t == 0) {
                  controller.setvalue(int.parse(widget.range), widget.option);
                } else {
                  controller.setvalue(t - 1, widget.option);
                }
              },
              icon: const Icon(
                Icons.arrow_drop_down_outlined,
                size: 40,
              ),
            ),
          ],
        )
      ],
    );
  }

  int getValue(int option) {
    switch (option) {
      case 1:
        return controller.timerhour.value;
      case 2:
        return controller.timerminute.value;
      case 3:
        return controller.timersecond.value;
    }
    return 0;
  }
}
