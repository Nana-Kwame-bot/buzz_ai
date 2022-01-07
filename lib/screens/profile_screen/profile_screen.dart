import 'package:animations/animations.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/contact_details.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/details.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/image_pick.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/multiple_car.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/submit_form.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/vehicle_information.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String iD = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserProfileController userProfileController;
  late AuthenticationController _authenticationController;
  late String userId;

  @override
  void initState() {
    super.initState();
    _authenticationController = Provider.of<AuthenticationController>(
      context,
      listen: false,
    );

    userProfileController = Provider.of<UserProfileController>(
      context,
      listen: false,
    );

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      userId = _authenticationController.auth.currentUser!.uid;
     await userProfileController.readProfileData(
        userId: _authenticationController.auth.currentUser!.uid,
        context: context,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await showModal<void>(
                configuration: const FadeScaleTransitionConfiguration(
                  transitionDuration: Duration(milliseconds: 500),
                ),
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Sign Out?'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          await Provider.of<AuthenticationController>(
                            context,
                            listen: false,
                          ).signOut().whenComplete(() {
                            Navigator.of(context)
                                .pushReplacementNamed(LoginScreen.iD);
                          });
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: defaultColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: defaultColor,
                          ),
                        ),
                      )
                    ],
                  );
                },
                context: context,
              );
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          title: const Text(
            'Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: const [
              ImagePick(),
              BasicDetails(),
              ContactDetails(),
              Emergency(),
              VehicleInformation(),
              MultipleCar(),
              SubmitForm(),
            ],
          ),
        ),
      ),
    );
  }
}
