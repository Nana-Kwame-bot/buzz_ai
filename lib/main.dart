import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:buzz_ai/activity_recognition.dart';
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
import 'package:buzz_ai/services/upload_sensor_data.dart';
import 'package:buzz_ai/widgets/issue_notifier.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'controllers/profile/image_pick/image_pick_controller.dart';
import 'firebase_options.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    log("Native called background task");
    return uploadSensorData();
  });
}

bool _deviceHasCapableAccelerometer = true;
double maxAccelerometerValue = 0.0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initState();
  await initialize();
  runApp(const MyApp());

  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  Workmanager().registerPeriodicTask(
    "Upload sensor data to storage",
    "uploadSensorData",
    frequency: const Duration(minutes: 15),
  );
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();

  const sensorListChannel = MethodChannel("buzzai/sensor_data");
  double accelerometerMaxRange =
      await sensorListChannel.invokeMethod("accelerometer_max_range");

  // if (accelerometerMaxRange < 40) {
  //   log("In-compatible device. Accelerometer capacity: $accelerometerMaxRange");
  //   maxAccelerometerValue = accelerometerMaxRange;
  //   _deviceHasCapableAccelerometer = false;
  // }

  log("Device compatible to run. Accelerometer capacity: $accelerometerMaxRange");

  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

AppLifecycleState currentAppState = AppLifecycleState.resumed;

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    // activityRecognitionApp.init();
    WidgetsBinding.instance!.addObserver(this);
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: "activity_change",
          channelName: "Activity Change",
          channelDescription:
              "Notification channel for notiyfing user of activity change",
          defaultColor: Colors.orange,
          ledColor: Colors.orange,
          criticalAlerts: true,
          importance: NotificationImportance.High,
          playSound: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        ),
        NotificationChannel(
          channelKey: "alert",
          channelName: "Critical Alerts",
          channelDescription:
              "Notification channel for notiyfing user of critical errors and information",
          defaultColor: Colors.red,
          ledColor: Colors.red,
          criticalAlerts: true,
          importance: NotificationImportance.High,
          playSound: true,
          defaultRingtoneType: DefaultRingtoneType.Notification,
        )
      ],
      debug: kDebugMode,
    );

    // Timer.periodic(const Duration(seconds: 5), (timer) {
    //   AwesomeNotifications().createNotification(
    //     content: NotificationContent(
    //       id: 1,
    //       channelKey: 'activity_change',
    //       title: "title",
    //       body: "body ${DateTime.now()}",
    //     ),
    //     schedule: NotificationCalendar(

    //       repeats: true,
    //     ),
    //   );
    // });

    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    currentAppState = state;
    FlutterBackgroundService()
        .sendData({"message": state.toString().split(".").last});
        
    if (state == AppLifecycleState.detached) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'alert',
          title: "Application terminated",
          body: "Please keep the app running in the background.",
          autoDismissible: false,
          backgroundColor: Colors.red,
          criticalAlert: true,
          displayOnBackground: true,
        ),
        actionButtons: [
          NotificationActionButton(
            key: "open",
            label: "Open",
          ),
          NotificationActionButton(
            key: "dismiss",
            label: "Dismiss",
            isDangerousOption: true,
            buttonType: ActionButtonType.DisabledAction,
          ),
        ],
      );
    }
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
              ChangeNotifierProvider<IssueNotificationProvider>(
                create: (BuildContext context) {
                  return IssueNotificationProvider();
                },
              ),
              StreamProvider(
                create: (_) => Connectivity().onConnectivityChanged,
                initialData: ConnectivityResult.none,
                catchError: (_, error) => error.toString(),
              ),
              ChangeNotifierProvider<ActivityRecognitionApp>(
                create: (BuildContext context) {
                  return ActivityRecognitionApp();
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
                  "Your device's accelerometer value $maxAccelerometerValue that is not capable of recording more than 4 G-force!",
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
