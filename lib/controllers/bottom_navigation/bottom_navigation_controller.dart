import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';

class BottomNavigationController extends ChangeNotifier {
  GlobalKey bottomNavigationKey = GlobalKey();
  int currentPage = 3;

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
    Container(
      color: Colors.blueAccent,
    ),
    Container(
      color: Colors.greenAccent,
    ),
    Container(
      color: Colors.redAccent,
    ),
    const ProfileScreen(),
  ];
}
