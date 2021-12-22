import 'package:buzz_ai/services/widgets/config.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();

    return Scaffold(
      backgroundColor: Color.fromRGBO(82, 71, 197, 1),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 85,
            ),
            Container(
              width: 140,
              height: 43,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/splash2.png"),
                      fit: BoxFit.cover)),
            ),
            SizedBox(
              height: 55,
            ),
            Container(
              child: Column(
                children: [
                  style.Barlow(
                      text: "Enter Your",
                      color: Colors.white,
                      size: 22,
                      fontwight: FontWeight.w700),
                  SizedBox(
                    height: 10,
                  ),
                  style.Barlow(
                      text: "Phone Number",
                      color: Colors.white,
                      size: 22,
                      fontwight: FontWeight.w700),
                  SizedBox(
                    height: 20,
                  ),
                  style.Barlow(
                      text: "You will receive a 4 digit code to verify next",
                      color: Colors.white,
                      size: 14,
                      fontwight: FontWeight.w400),
                  SizedBox(
                    height: 30,
                  ),
                  ConfirmationSlider(
                    foregroundColor: Color.fromRGBO(84, 71, 189, 1),
                    sliderButtonContent: Icon(
                      Icons.chevron_right_outlined,
                      color: Colors.white,
                    ),
                    text: "Send OTP",
                    textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    backgroundColor: Color.fromRGBO(66, 54, 183, 1),
                    iconColor: Colors.transparent,
                    width: 280,
                    height: 60,
                    onConfirmation: () {},
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
