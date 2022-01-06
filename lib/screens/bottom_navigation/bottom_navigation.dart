import 'package:buzz_ai/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:buzz_ai/services/widgets/config.dart';
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
  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      final FancyBottomNavigationState fState =
      bottomNavigationKey.currentState as FancyBottomNavigationState;
      fState.setPage(0);
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<BottomNavigationController>(
        builder: (BuildContext context, value, Widget? child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: IndexedStack(
              index: value.currentPage,
              children: value.pages,
            ),
            bottomNavigationBar: FancyBottomNavigation(
              key: bottomNavigationKey,
              circleColor: defaultColor,
              inactiveIconColor: Colors.black54,
              initialSelection: 0,
              textColor: defaultColor,
              onTabChangedListener: value.changePage,
              tabs: value.tabs,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    bottomNavigationKey.currentState?.dispose();
    super.dispose();
  }
}
