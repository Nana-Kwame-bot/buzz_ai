// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore: file_names

// ignore_for_file: use_key_in_widget_constructors

import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
//repository injection
//final MyRepository repository = MyRepository(apiClient: MyApiClient(httpClient: http.Client()));

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const double _iconSize = 50;

  AnimationController? _animationController;
  Animation? _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3300),
    );
    _animation = CurvedAnimation(
        parent: _animationController!.view, curve: Curves.easeInCubic);

    _animationController!.forward().whenComplete(() => Get.to(LoginScreen()));
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();

    return Scaffold(
        body: AnimatedBuilder(
      animation: _animation!,
      builder: (context, index) {
        return Container(
          color: Color.fromRGBO(82, 71, 197, 1),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 120, left: 40, right: 40),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/img/splash2.png"),
                        fit: BoxFit.fitWidth)),
              ),
            ),
            Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 230,
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: DecorationImage(
                      image: AssetImage("assets/img/splash1.png"),
                      fit: BoxFit.fitWidth)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: style.Barlow(
                      text: "A Safer way to ride",
                      size: 19,
                      color: Color.fromRGBO(0, 60, 255, 1),
                      fontwight: FontWeight.w800),
                ),
              ),
            ),
          ]),
        );
      },
    ));
  }
}
