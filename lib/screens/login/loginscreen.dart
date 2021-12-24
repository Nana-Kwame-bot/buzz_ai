import 'package:buzz_ai/screens/profile_screen/profile_screen.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:buzz_ai/services/widgets/locale/textformwidget.dart';
import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class LoginScreen extends StatelessWidget {
  static const String iD = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextWidgetStyle style = TextWidgetStyle();
    TextEditingController _mobileController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color.fromRGBO(82, 71, 197, 1),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 85,
            ),
            Container(
              width: 140,
              height: 43,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/img/splash2.png"),
                      fit: BoxFit.cover)),
            ),
            const SizedBox(
              height: 55,
            ),
            Column(
              children: [
                style.Barlow(
                    text: "Enter Your",
                    color: Colors.white,
                    size: 22,
                    fontwight: FontWeight.w700),
                const SizedBox(
                  height: 10,
                ),
                style.Barlow(
                    text: "Phone Number",
                    color: Colors.white,
                    size: 22,
                    fontwight: FontWeight.w700),
                const SizedBox(
                  height: 20,
                ),
                style.Barlow(
                    text: "You will receive a 4 digit code to verify next",
                    color: Colors.white,
                    size: 14,
                    fontwight: FontWeight.w400),
                const SizedBox(
                  height: 30,
                ),
                Container(
                    height: 42,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: style.Barlow(color: Colors.grey, text: "+91"),
                        ),
                        VerticalDivider(
                          color: Colors.grey.shade400,
                        ),
                        TextFormWidget(
                          heading: "Enter Your Phone number",
                          type: TextInputType.number,
                          controller: _mobileController,
                          textalign: TextAlign.center,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 30,
                ),
                ConfirmationSlider(
                  foregroundColor: const Color.fromRGBO(84, 71, 189, 1),
                  sliderButtonContent: const Icon(
                    Icons.chevron_right_outlined,
                    color: Colors.white,
                  ),
                  text: "Send OTP",
                  textStyle: const TextStyle(color: Colors.white, fontSize: 16),
                  backgroundColor: const Color.fromRGBO(66, 54, 183, 1),
                  iconColor: Colors.transparent,
                  width: 280,
                  height: 60,
                  onConfirmation: () {
                    Navigator.pushNamed(context, ProfileScreen.iD);
                  },
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
