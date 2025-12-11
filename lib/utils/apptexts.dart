import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText {
  Widget heavyText({
    required String text,
    double size = 64,
    FontWeight weight = FontWeight.w900,
    Color color = Colors.black,
  }) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: weight,
        fontSize: size,
        color: color,
      ),
    );
  }

  Widget semiboldText({
    required String text,
    double size = 44,
    FontWeight weight = FontWeight.w900,
    Color color = Colors.black,
  }) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: weight,
        fontSize: size,
        color: color,
      ),
    );
  }

  Widget lightText({
    required String text,
    double size = 44,
    FontWeight weight = FontWeight.w200,
    Color color = Colors.black,
  }) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: weight,
        fontSize: size,
        color: color,
      ),
    );
  }
}
