import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:buzz_ai/screens/verification_screen/verification_screen.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class LoginScreen extends StatefulWidget {
  static const String iD = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthenticationController _authenticationController;
  DateTime _currentBackPressTime = DateTime.now();
  var numberAuthFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _authenticationController = Provider.of<AuthenticationController>(
      context,
      listen: false,
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _onWillPop();
        return Future.value(false);
      },
      child: StreamBuilder<User?>(
          stream: context.select((AuthenticationController controller) {
        return controller.onAuthStateChanges;
      }), builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (!snapshot.hasData) {
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
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 55,
                      ),
                      TextWidgetStyle.Barlow(
                          text: "Enter Your",
                          color: Colors.white,
                          size: 22,
                          fontwight: FontWeight.w700),
                      const SizedBox(
                        height: 10,
                      ),
                      TextWidgetStyle.Barlow(
                          text: "Phone Number",
                          color: Colors.white,
                          size: 22,
                          fontwight: FontWeight.w700),
                      const SizedBox(
                        height: 20,
                      ),
                      TextWidgetStyle.Barlow(
                          text:
                              "You will receive a 6 digit code to verify next",
                          color: Colors.white,
                          size: 14,
                          fontwight: FontWeight.w400),
                      const SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Form(
                          key: numberAuthFormKey,
                          child: IntlPhoneField(
                            // dropdownDecoration: const BoxDecoration(
                            //   color: Colors.white,
                            // ),
                            showDropdownIcon: false,
                            showCountryFlag: false,
                            autoValidate: true,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            onSaved: (phoneNumber) async {
                              if (phoneNumber != null) {
                                bool result = validateNumberForm(
                                  phoneNumber.completeNumber,
                                );
                                if (result) {
                                  Navigator.of(context).pushReplacementNamed(
                                    VerificationScreen.iD,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..removeCurrentSnackBar()
                                    ..showSnackBar(
                                      const SnackBar(
                                        duration: Duration(seconds: 3),
                                        content:
                                            Text("Phone number is invalid"),
                                      ),
                                    );
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                  ..removeCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      duration: Duration(seconds: 3),
                                      content:
                                          Text("Phone number can't be empty"),
                                    ),
                                  );
                              }
                            },
                            initialCountryCode: 'IN',
                          ),
                        ),
                      ),
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
                        textStyle:
                            const TextStyle(color: Colors.white, fontSize: 16),
                        backgroundColor: const Color.fromRGBO(66, 54, 183, 1),
                        iconColor: Colors.transparent,
                        width: 280,
                        height: 60,
                        onConfirmation: () {
                          numberAuthFormKey.currentState!.save();
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
          return const BottomNavigation();
        } else {
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
        }
      }),
    );
  }

  bool validateNumberForm(String? number) {
    if (numberAuthFormKey.currentState!.validate()) {
      _authenticationController.onFieldSubmitted(number);
      return true;
    } else {
      numberAuthFormKey.currentState!.reset();
      return false;
    }
  }

  @override
  void dispose() {
    numberAuthFormKey.currentState?.dispose();
    super.dispose();
  }
}
