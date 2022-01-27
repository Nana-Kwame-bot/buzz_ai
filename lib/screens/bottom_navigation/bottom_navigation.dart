import 'dart:async';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:buzz_ai/controllers/notifications/notifications_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/screens/sos/sos_main.dart';
import 'dart:developer';
import 'package:buzz_ai/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  static const String iD = '/bottom_navigation';

  const BottomNavigation({Key? key}) : super(key: key);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  final PageController controller = PageController(keepPage: false);
  DateTime _currentBackPressTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (!(snapshot.data!.getBool('profileComplete') ?? false)) {
              return const ProfileScreen(isFromSignUp: true);
            }

            return WillPopScope(
              onWillPop: () {
                _onWillPop();
                return Future.value(false);
              },
              child: SafeArea(
                child: Consumer(
                  builder: (BuildContext context,
                      BottomNavigationController value, Widget? child) {
                    return Consumer<ActivityRecognitionApp>(builder: (context,
                        ActivityRecognitionApp activity, Widget? child) {
                      if (activity.gForceExceeded &&
                          !activity.accidentReported) {
                        return const SOSScreen(
                          timeout: 30,
                        );
                      }

                      return Scaffold(
                        backgroundColor: Colors.white,
                        body: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: controller,
                          children: value.pages,
                        ),
                        bottomNavigationBar: FancyBottomNavigation(
                          // key: bottomNavigationKey,
                          circleColor: defaultColor,
                          inactiveIconColor: Colors.black54,
                          initialSelection: 0,
                          textColor: defaultColor,
                          onTabChangedListener: (int index) {
                            value.changePage(index);
                            controller.jumpToPage(index);
                          },
                          tabs: value.tabs,
                        ),
                      );
                    });
                  },
                  child: SafeArea(
                    child: Consumer(
                      builder: (BuildContext context,
                          BottomNavigationController value, Widget? child) {
                        return Scaffold(
                          backgroundColor: Colors.white,
                          body: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controller,
                            children: value.pages,
                          ),
                          bottomNavigationBar: FancyBottomNavigation(
                            // key: bottomNavigationKey,
                            circleColor: defaultColor,
                            inactiveIconColor: Colors.black54,
                            initialSelection: 0,
                            textColor: defaultColor,
                            onTabChangedListener: (int index) async {
                              value.changePage(index);
                              controller.jumpToPage(index);
                            },
                            tabs: value.tabs,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }

  void _onWillPop() {
    final now = DateTime.now();
    if (now.difference(_currentBackPressTime) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      Fluttertoast.showToast(
        msg: 'Press back again to Exit',
        fontSize: 16,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black45,
      );
      return;
    }
    SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
    return;
  }

  @override
  void dispose() {
    // homeSubscription.cancel();
    controller.dispose();
    super.dispose();
  }
}
