import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TravelDataWidget extends StatelessWidget {
  const TravelDataWidget({
    Key? key,
    required this.from,
    required this.fromTime,
  }) : super(key: key);

  final String from;
  final String fromTime;

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
                    Text(
                      from,
                      style: GoogleFonts.barlow(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      fromTime,
                      style: GoogleFonts.barlow(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
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
