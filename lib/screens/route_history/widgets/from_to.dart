import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FromAndTo extends StatelessWidget {
  const FromAndTo({Key? key, required this.from, required this.to})
      : super(key: key);

  final String from;
  final String to;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          from,
          style: GoogleFonts.barlow(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Text(
          to,
          style: GoogleFonts.barlow(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}