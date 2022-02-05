import 'package:auto_size_text/auto_size_text.dart';
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
      children: [
        Expanded(
          flex: 1,
          child: AutoSizeText(
            from,
            minFontSize: 18,
            maxFontSize: 18,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.barlow(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
        const Spacer(),
        Expanded(
          flex: 1,
          child: AutoSizeText(
            to,
            minFontSize: 18,
            maxFontSize: 18,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.barlow(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
