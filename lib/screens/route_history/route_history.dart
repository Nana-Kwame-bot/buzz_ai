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
        automaticallyImplyLeading: false,
        foregroundColor: Colors.black,
        title: Text(
          "Travelled History",
          style: GoogleFonts.barlow(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _getRouteHistory(context),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Map<String, dynamic> data =
                  Map<String, dynamic>.from(snapshot.data);

              return ListView.builder(
                itemCount: data.keys.length,
                itemBuilder: (context, index) {
                  String key = data.keys.toList()[index];

                  DateTime date = DateTime.parse(key);
                  String formattedDate =
                      DateFormat("MMM dd, yyyy - ").format(date);
                  String formattedTime = DateFormat("hh:mm a").format(date);

                  String formattedArraivalTime;
                  try {
                    formattedArraivalTime  =
                      DateFormat("hh:mm a").format(data[key]["toTime"].toDate());
                  } catch (e) {
                    return Container();
                  }

                  return HistoryCard(
                    data: data[key],
                    formattedDate: formattedDate,
                    formattedTime: formattedTime,
                    formattedArraivalTime: formattedArraivalTime,
                    index: index,
                  );
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
              formattedArraivalTime: "",
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

    return snapshot.data()?["historyData"];
  }
}

class HistoryCard extends StatelessWidget {
  const HistoryCard({
    Key? key,
    required this.data,
    required this.formattedDate,
    required this.formattedTime,
    required this.formattedArraivalTime,
    required this.index,
    this.isLoading = false,
  }) : super(key: key);

  final Map<String, dynamic> data;
  final String formattedDate;
  final String formattedTime;
  final String formattedArraivalTime;
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
          from: isLoading ? "Point A" : data["from"].toString(),
          to: isLoading ? "Point B" : data["to"].toString(),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.all(8),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => RouteDetailed(
              from: isLoading ? "Point A" : data["from"].toString(),
              to: isLoading ? "Point B" : data["to"].toString(),
              fromDate: formattedDate,
              fromTime: formattedTime,
              toTime: formattedArraivalTime,
              routes: List<Map<String, dynamic>>.from(data["routes"]),
              index: index,
            ),
          ),
        ),
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
