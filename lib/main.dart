import 'package:buzz_ai/buzzai_app.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contact/emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/gender/gender_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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
        ChangeNotifierProvider<GenderController>(
          create: (BuildContext context) {
            return GenderController();
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
      ],
      child: const BuzzaiApp(),
    );
  }
}
