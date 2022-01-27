import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelDataWidget extends StatelessWidget {
  const TravelDataWidget({
    Key? key,
    required this.location,
    required this.arraivalTime,
  }) : super(key: key);

  final String location;
  final String arraivalTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 22, right: 13),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Color(0xff33414c),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_outlined,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: AutoSizeText(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 18,
                        maxFontSize: 20,
                        style: GoogleFonts.barlow(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 1,
                      child: AutoSizeText(
                        arraivalTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 15,
                        maxFontSize: 18,
                        style: GoogleFonts.barlow(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  thickness: 8,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
