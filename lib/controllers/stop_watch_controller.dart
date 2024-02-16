import 'package:get/get.dart';

class StopWatchController extends GetxController {
  RxInt hours = 0.obs;
  RxInt minutes = 0.obs;
  RxInt seconds = 0.obs;
  RxBool started = false.obs;
  RxString digithour = "00".obs;
  RxString digitminute = "00".obs;
  RxString digitsecond = "00".obs;
  RxList<String> flags = <String>[].obs;
  RxList<String> laps = <String>[].obs;
  updateStart(bool v) {
    started.value = v;
  }

  void addFlag(String s) {
    flags.add(s);
  }

  void addlap() {
    String s = "${digithour.value}:${digitminute.value}:${digitsecond.value}";
    laps.add(s);
  }

  updatevalues(int hour, int minute, int second) {
    hours.value = hour;
    minutes.value = minute;
    seconds.value = second;
    digitsecond.value = (second >= 10) ? "$second" : "0$second";
    digitminute.value = (minute >= 10) ? "$minute" : "0$minute";
    digithour.value = (hour >= 10) ? "$hour" : "0$hour";
  }
}
