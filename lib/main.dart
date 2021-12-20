import 'package:buzz_ai/routes/routes.dart';
import 'package:buzz_ai/screens/slpashscreen/splashscrenn.dart';
import 'package:buzz_ai/services/locale/bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ControllerBindings(),
      initialRoute: Routes.INITIAL,
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
