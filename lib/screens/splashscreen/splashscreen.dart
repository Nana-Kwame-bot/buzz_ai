import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  static const String iD = '/';
//repository injection
//final MyRepository repository = MyRepository(apiClient: MyApiClient(httpClient: http.Client()));

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // static const double _iconSize = 50;

  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3300),
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushNamed(context, LoginScreen.iD);
        }
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

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();

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
                      fit: BoxFit.fitWidth)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: style.Barlow(
                      text: "A Safer way to ride",
                      size: 19,
                      color: const Color.fromRGBO(0, 60, 255, 1),
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
