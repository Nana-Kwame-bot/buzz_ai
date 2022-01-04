import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatefulWidget {
  static const String iD = '/bottom_navigation';

  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late AuthenticationController authenticationController;
  late UserProfileController userProfileController;
  late String userId;

  @override
  void initState() {
    super.initState();
    authenticationController = Provider.of<AuthenticationController>(
      context,
      listen: false,
    );

    userProfileController = Provider.of<UserProfileController>(
      context,
      listen: false,
    );

    userId = authenticationController.auth.currentUser!.uid;
    userProfileController.readProfileData(userId: userId);
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
              circleColor: defaultColor,
              inactiveIconColor: Colors.black54,
              key: value.bottomNavigationKey,
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
}
