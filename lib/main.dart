import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/controllers/notifications/notifications_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/fifth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/first_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/fourth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/second_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/third_emergency_contact_controller.dart';
import 'package:buzz_ai/screens/misc/error_screen.dart';
import 'package:buzz_ai/buzzai_app.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:buzz_ai/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/models/report_accident/submit_accident_report.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/profile/image_pick/image_pick_controller.dart';
import 'firebase_options.dart';

bool _deviceHasCapableAccelerometer = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initState();
  await initialize();
  // runApp(const MyApp());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  const sensorListChannel = MethodChannel("buzzai/sensor_data");
  double accelerometerMaxRange =
      await sensorListChannel.invokeMethod("accelerometer_max_range");

  if ((accelerometerMaxRange / 9.5) < 4) {
    log("In-compatible device. Accelerometer capacity: ${(accelerometerMaxRange / 9.5)}");
    _deviceHasCapableAccelerometer = false;
  }

  log("Device compatible to run. Accelerometer capacity: ${(accelerometerMaxRange / 9.5)}");

  await Hive.initFlutter();
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          defaultColor: defaultColor,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          channelDescription: 'Show basic notifications',
        ),
      ],
      debug: true);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Allow Notifications'),
                content:
                    const Text('Buzzai would like to send you notifications'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Don't Allow",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then((_) {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      'Allow',
                      style: TextStyle(
                        color: defaultColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
    );

    AwesomeNotifications().actionStream.listen((ReceivedAction receivedAction) {
      if (receivedAction.channelKey == 'basic_channel' && Platform.isIOS) {
        AwesomeNotifications().getGlobalBadgeCounter().then(
          (int counter) {
            return AwesomeNotifications().setGlobalBadgeCounter(counter - 1);
          },
        );
      }
      if (receivedAction.buttonKeyPressed == "Yes") {
        //TODO: Do something with this info
      }
      if (receivedAction.buttonKeyPressed == "No") {
        //TODO: Do something with this info
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _deviceHasCapableAccelerometer
        ? MultiProvider(
            providers: [
              ChangeNotifierProvider<UserProfileController>(
                create: (BuildContext context) {
                  return UserProfileController()..setPersistence();
                },
              ),
              ChangeNotifierProvider<NotificationsController>(
                create: (BuildContext context) {
                  return NotificationsController();
                },
              ),
              ChangeNotifierProvider<BasicDetailController>(
                create: (BuildContext context) {
                  return BasicDetailController();
                },
              ),
              ChangeNotifierProvider<ContactDetailController>(
                create: (BuildContext context) {
                  return ContactDetailController();
                },
              ),
              ChangeNotifierProvider<FirstEmergencyContactController>(
                create: (BuildContext context) {
                  return FirstEmergencyContactController();
                },
              ),
              ChangeNotifierProvider<SecondEmergencyContactController>(
                create: (BuildContext context) {
                  return SecondEmergencyContactController();
                },
              ),
              ChangeNotifierProvider<ThirdEmergencyContactController>(
                create: (BuildContext context) {
                  return ThirdEmergencyContactController();
                },
              ),
              ChangeNotifierProvider<FourthEmergencyContactController>(
                create: (BuildContext context) {
                  return FourthEmergencyContactController();
                },
              ),
              ChangeNotifierProvider<FifthEmergencyContactController>(
                create: (BuildContext context) {
                  return FifthEmergencyContactController();
                },
              ),
              ChangeNotifierProvider<MultipleVehicleController>(
                create: (BuildContext context) {
                  return MultipleVehicleController()..onStart();
                },
              ),
              ChangeNotifierProvider<AuthenticationController>(
                create: (BuildContext context) {
                  return AuthenticationController();
                },
              ),
              ChangeNotifierProvider<VehicleInfoController>(
                create: (BuildContext context) {
                  return VehicleInfoController();
                },
              ),
              ChangeNotifierProvider<BottomNavigationController>(
                create: (BuildContext context) {
                  return BottomNavigationController();
                },
              ),
              ChangeNotifierProvider<HomeScreenController>(
                create: (BuildContext context) {
                  return HomeScreenController()..onAppStarted();
                },
              ),
              ChangeNotifierProvider<ImagePickController>(
                create: (BuildContext context) {
                  return ImagePickController();
                },
              ),
              ChangeNotifierProvider<SubmitAccidentReport>(
                create: (BuildContext context) {
                  return SubmitAccidentReport();
                },
              ),
              ChangeNotifierProvider<ActivityRecognitionApp>(
                create: (BuildContext context) {
                  return ActivityRecognitionApp()..init();
                },
              ),
            ],
            child: const BuzzaiApp(),
          )
        : MaterialApp(
            home: ErrorScreen(
              errorHeroWidget: SvgPicture.asset(
                "assets/img/undraw_warning_cyit.svg",
                height: 200,
              ),
              title: "Accelerometer Error",
              description:
                  "Your device's accelerometer is not capable of recording more than 4 G-force!",
              action: ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService()
                      .sendData({"action": "stopService"});
                  exit(-1);
                },
                child: const Text("Undestood & Exit"),
              ),
            ),
          );
  }
}

// Error codes:
// -1 => Accelerometer not capable
