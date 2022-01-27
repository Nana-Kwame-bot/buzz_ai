import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FromDateTime extends StatelessWidget {
  const FromDateTime({
    Key? key,
    required this.text,
    this.subText = "",
  }) : super(key: key);

  final String text;
  final String subText;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style:
                GoogleFonts.barlow(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          TextSpan(
            text: subText,
            style: GoogleFonts.barlow(
              fontWeight: FontWeight.w400,
              fontSize: 18,
            ),
          ),
        ],
        style: GoogleFonts.barlow(color: Colors.black),
      ),
    );
  }
}
