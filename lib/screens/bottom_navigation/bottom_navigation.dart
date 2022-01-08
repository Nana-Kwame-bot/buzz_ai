import 'package:buzz_ai/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  static const String iD = '/bottom_navigation';

  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final PageController controller = PageController(keepPage: false);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer(
        builder: (BuildContext context, BottomNavigationController value,
            Widget? child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              // index: value.currentPage,
              children: value.pages,
            ),
            bottomNavigationBar: FancyBottomNavigation(
              circleColor: defaultColor,
              inactiveIconColor: Colors.black54,
              initialSelection: 0,
              textColor: defaultColor,
              onTabChangedListener: (int index){
                value.changePage(index);
                controller.jumpToPage(index);
              },
              tabs: value.tabs,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
