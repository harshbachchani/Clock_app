import 'package:get/get.dart';

class TimerController extends GetxController {
  RxInt hour = 0.obs;
  RxInt minute = 0.obs;
  RxInt second = 0.obs;
  RxString dhour = "00".obs;
  RxString dminute = "00".obs;
  RxString dsecond = "00".obs;
  RxBool isplaying = false.obs;
  RxBool isstarted = false.obs;

  RxInt timerhour = 0.obs;
  RxInt timerminute = 0.obs;
  RxInt timersecond = 0.obs;

  setvalue(int value, int option) {
    if (option == 1) {
      timerhour.value = value;
    } else if (option == 2) {
      timerminute.value = value;
    } else {
      timersecond.value = value;
    }
  }

  changeStarted(bool v) {
    isstarted.value = v;
  }

  toggleplaying() {
    isplaying.value = !isplaying.value;
  }

  settimer(int a, int b, int c) {
    hour.value = a;
    minute.value = b;
    second.value = c;
    dsecond.value = (c >= 10) ? "$c" : "0$c";
    dminute.value = (b >= 10) ? "$b" : "0$b";
    dhour.value = (a >= 10) ? "$a" : "0$a";
  }
}
