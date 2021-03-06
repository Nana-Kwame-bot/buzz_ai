// ignore_for_file: unused_import
import 'dart:developer';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/global/all_permissions.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:buzz_ai/screens/home/home_screen.dart';
import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:buzz_ai/screens/misc/request_permission.dart';
import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String iD = '/';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  late Animation _animation;
  late String userId;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3300),
    )
      ..forward()
      ..addStatusListener((status) async {
        AuthenticationController authControl =
            Provider.of<AuthenticationController>(context, listen: false);

        if (authControl.auth.currentUser == null) {
          if (status == AnimationStatus.completed) {
            Navigator.of(context).pushNamed(LoginScreen.iD);
            return;
          }
        }

        // Initialize the profile before the app starts so that we can use it in emergency.
        await Provider.of<UserProfileController>(context, listen: false)
            .readProfileData(
                userId: authControl.auth.currentUser!.uid, context: context);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool isProfileComplete = prefs.getBool("profileComplete") ?? false;

        if (isProfileComplete) {
          if (prefs.getBool("allPermissionsGranted") ?? false) {
            bool isAllGranted = await checkForAllPermissions();

            if (isAllGranted) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const BottomNavigation()));
              return;
            }
          }
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => RequestPermission()));

          return;
        }

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProfileScreen(isFromSignUp: true)));
      });

    _animation = CurvedAnimation(
      parent: _animationController.view,
      curve: Curves.easeInCubic,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<bool> checkForAllPermissions() async {
    bool isAllGranted = true;
    List<Permission> _allPermissions = List<Permission>.from(
        allPermissions.map((e) => e["permission"]).toList());

    for (var permission in _allPermissions) {
      bool isGranted = await permission.isGranted;
      if (isGranted) continue;

      log("???????????????????????? $permission is not granted!");
      isAllGranted = false;
    }

    return isAllGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, index) {
          return Container(
            color: const Color.fromRGBO(82, 71, 197, 1),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 120, left: 40, right: 40),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/img/splash2.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 230,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                    image: AssetImage("assets/img/splash1.png"),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: TextWidgetStyle.Barlow(
                      text: "A Safer way to ride",
                      size: 19,
                      color: const Color.fromRGBO(0, 60, 255, 1),
                      fontwight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
