import 'package:buzz_ai/screens/route_history/widgets/from_date_time.dart';
import 'package:buzz_ai/screens/route_history/widgets/google_map_with_route.dart';
import 'package:buzz_ai/screens/route_history/widgets/travel_data.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RouteDetailed extends StatelessWidget {
  const RouteDetailed({
    Key? key,
    required this.from,
    required this.to,
    required this.fromDate,
    required this.fromTime,
    this.icon = const FaIcon(
      FontAwesomeIcons.carSide,
      size: 50,
      color: Color(0xff7b69da),
    ),
    required this.points,
    required this.toTime,
    required this.index,
  }) : super(key: key);

  final String from;
  final String to;
  final String fromDate;
  final String fromTime;
  final Widget icon;
  final List<Map<String, dynamic>> points;
  final String toTime;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Travelled History",
          style: GoogleFonts.barlow(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.70,
                  child: GoogleMapWithRoute(points: points),
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 8),
                          blurRadius: 20,
                          spreadRadius: 14),
                    ],
                  ),
                  child: Column(
                    children: [
                      Hero(
                        tag: "from-to-$index",
                        child: FromDateTime(text: fromDate, subText: fromTime),
                      ),
                      Hero(tag: "car-$index", child: icon),
                    ],
                  ),
                ),
              ],
            ),
            TravelDataWidget(from: from, fromTime: fromTime),
            Padding(
              padding: const EdgeInsets.only(left: 54, top: 15, bottom: 15),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.directions_car,
                      size: 35,
                      color: Color(0xffB4B4B4),
                    ),
                  ),
                  Text(
                    "Driving",
                    style: GoogleFonts.barlow(
                      fontStyle: FontStyle.italic,
                      color: const Color(0xff33414C),
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            TravelDataWidget(from: from, fromTime: fromTime),
          ],
        ),
      ),
    );
  }
}
