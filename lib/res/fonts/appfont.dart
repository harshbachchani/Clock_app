import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static TextStyle headText(double a, [Color? c]) {
    return GoogleFonts.notoSans(
      fontSize: a,
      fontWeight: FontWeight.w700,
      color: c ?? Colors.black,
    );
  }

  static TextStyle smallText(double a, [Color? c]) {
    return GoogleFonts.montserrat(
      fontSize: a,
      fontWeight: FontWeight.w300,
      color: c ?? Colors.black,
    );
  }

  static TextStyle mediumText(double a, [Color? c]) {
    return GoogleFonts.notoSans(
      fontSize: a,
      fontWeight: FontWeight.w500,
      color: c ?? Colors.black,
    );
  }

  static TextStyle regularText(double a, [Color? c]) {
    return GoogleFonts.montserrat(
      fontWeight: FontWeight.w200,
      fontSize: a,
      color: c ?? Colors.black,
    );
  }
}
