import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final double heigh;
  final double weigh;
  final Widget child;
  const MyDialog(
      {super.key,
      required this.heigh,
      required this.weigh,
      required this.child});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        height: heigh,
        width: weigh,
        child: child,
      ),
    );
  }

  static void showCustomDialog(BuildContext context,
      {required double height, required double width, required Widget child}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext build) {
          return MyDialog(heigh: height, weigh: width, child: child);
        });
  }
}
