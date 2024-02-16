import 'package:alarm_app/controllers/menu_controller.dart';
import 'package:alarm_app/res/data/data.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuButton extends StatefulWidget {
  final PageController pageController;
  const MenuButton(
      {super.key, required this.currentmenu, required this.pageController});
  final int currentmenu;
  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  MyMenuController menuController = Get.put(MyMenuController());
  @override
  Widget build(BuildContext context) {
    Brightness current = Theme.of(context).brightness;
    Color textColor = current == Brightness.light ? Colors.black : Colors.white;
    Color backgroundColor =
        current != Brightness.light ? Colors.black : Colors.white;
    return GestureDetector(
      onTap: () {
        menuController.updateMenu(widget.currentmenu);
        widget.pageController.animateToPage(widget.currentmenu,
            duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
      },
      child: Obx(
        () => Container(
          margin: const EdgeInsets.symmetric(vertical: 15.0),
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: widget.currentmenu == menuController.item.value
                ? Border(
                    bottom: BorderSide(
                        color: textColor,
                        width: 2.0)) // Border color for the active icon
                : null,
          ),
          child: Column(
            children: [
              SizedBox(
                width: 60,
                height: 50,
                child: Icon(menulist[widget.currentmenu].icon as IconData?),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
