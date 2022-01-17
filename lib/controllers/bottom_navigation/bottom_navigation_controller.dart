import 'package:buzz_ai/screens/accidentreport_screen/accidentreport_screen.dart';
import 'package:buzz_ai/screens/home/home_screen.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/test.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart' show kDebugMode;

class BottomNavigationController extends ChangeNotifier {
  int currentPage = 0;

  List<TabData> tabs = [
    TabData(iconData: Icons.home_outlined, title: 'Home'),
    TabData(iconData: Icons.history, title: 'History'),
    TabData(iconData: Icons.description, title: 'Report'),
    TabData(iconData: Icons.perm_identity, title: 'Profile'),
  ];

  void changePage(int position) {
    currentPage = position;
    notifyListeners();
  }

  List<Widget> pages = [
    // kDebugMode
    //     ? Container(
    //         color: Colors.yellowAccent,
    //       )
    //     :
    const HomeScreen(),
    Test(),
    Container(
      color: Colors.greenAccent,
    ),
    const AccidentReportScreen(),
    const ProfileScreen(),
  ];
}
