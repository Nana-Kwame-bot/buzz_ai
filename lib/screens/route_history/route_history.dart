import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/route_history/route_detailed_screen.dart';
import 'package:buzz_ai/screens/route_history/widgets/card_header.dart';
import 'package:buzz_ai/screens/route_history/widgets/from_to.dart';
import 'package:buzz_ai/screens/route_history/widgets/timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class RouteHistory extends StatelessWidget {
  const RouteHistory({Key? key}) : super(key: key);

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
      body: FutureBuilder(
        future: _getRouteHistory(context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<Map<String, dynamic>> data =
                  List<Map<String, dynamic>>.from(snapshot.data["historyData"]);

              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  DateTime date = data[index]["timestamp"].toDate();
                  String formattedDate =
                      DateFormat("MMM dd, yyyy - ").format(date);
                  String formattedTime = DateFormat("hh:mm a").format(date);

                  return HistoryCard(
                      data: data[index],
                      formattedDate: formattedDate,
                      formattedTime: formattedTime,
                      index: index);
                },
              );
            }
            return Center(
              child: Text(
                "Nothing to show for now!",
                style: GoogleFonts.barlow(),
              ),
            );
          }

          String formattedDate =
              DateFormat("MMM dd, yyyy - ").format(DateTime.now());
          String formattedTime = DateFormat("hh:mm a").format(DateTime.now());

          return ListView.builder(
            itemCount: 2,
            itemBuilder: (context, index) => HistoryCard(
              data: const {},
              formattedDate: formattedDate,
              formattedTime: formattedTime,
              index: index,
              isLoading: true,
            ),
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>?> _getRouteHistory(BuildContext context) async {
    String uid = Provider.of<AuthenticationController>(context, listen: false)
        .auth
        .currentUser!
        .uid;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection("userDatabase")
        .doc(uid)
        .get();

    return snapshot.data();
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    Key? key,
    required this.data,
    required this.formattedDate,
    required this.formattedTime,
    required this.index,
    this.isLoading = false,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final String formattedDate;
  final String formattedTime;
  final int index;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    Widget _widget = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CardHeader(
          text: formattedDate,
          subText: formattedTime,
          index: index,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Timeline(),
        ),
        FromAndTo(
          from: isLoading ? "Point A" : data["from"],
          to: isLoading ? "Point B" : data["to"],
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RouteDetailed(
            from: isLoading ? "Point A" : data["from"],
            to: isLoading ? "Point B" : data["to"],
            fromDate: formattedDate,
            fromTime: formattedTime,
            toTime: "6:00 PM",
            points: List<Map<String, dynamic>>.from(data["route"]),
            index: index,
          ),
        )),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(8, 8),
                blurRadius: 10,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.grey,
                    highlightColor: Colors.white.withOpacity(0.5),
                    child: _widget,
                  )
                : _widget,
          ),
        ),
      ),
    );
  }
}
