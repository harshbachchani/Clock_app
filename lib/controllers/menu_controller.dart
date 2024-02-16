import 'package:get/get.dart';

class MyMenuController extends GetxController {
  RxInt item = 0.obs;
  updateMenu(int i) {
    item.value = i;
  }
}
