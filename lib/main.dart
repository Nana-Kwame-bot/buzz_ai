import 'package:buzz_ai/activity_recognition.dart';
import 'package:buzz_ai/services/bg_methods.dart';
import 'package:buzz_ai/buzzai_app.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/bottom_navigation/bottom_navigation_controller.dart';
import 'package:buzz_ai/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contact/emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/models/report_accident/submit_accident_report.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/profile/image_pick/image_pick_controller.dart';
import 'firebase_options.dart';

final ActivityRecognitionApp activityRecognitionApp = ActivityRecognitionApp();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // initState();
  await initialize();
  runApp(const MyApp());
}

Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterBackgroundService bgService = FlutterBackgroundService();
  await bgService.configure(
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
    androidConfiguration: AndroidConfiguration(
      autoStart: true,
      onStart: onStart,
      isForegroundMode: true,
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    activityRecognitionApp.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
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
        ChangeNotifierProvider<EmergencyContactController>(
          create: (BuildContext context) {
            return EmergencyContactController()..onStart();
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
            return ActivityRecognitionApp();
          },
        ),
      ],
      child: const BuzzaiApp(),
    );
  }
}
