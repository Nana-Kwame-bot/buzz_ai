import 'package:animations/animations.dart';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/models/profile/user_profile/user_profile.dart';
import 'package:buzz_ai/screens/login/loginscreen.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/contact_details.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/details.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/image_pick.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/multiple_car.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/submit_form.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/vehicle_information.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String iD = '/profile';
  final bool isFromSignUp;

  const ProfileScreen({Key? key, required this.isFromSignUp}) : super(key: key);

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
    userId = _authenticationController.auth.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (widget.isFromSignUp) {
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () async {
                if (widget.isFromSignUp) {
                  return;
                }
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
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginScreen.iD, (route) {
                                return false;
                              });
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
            child: FutureBuilder<UserProfile>(
              future: userProfileController.readProfileData(
                userId: userId,
                context: context,
              ),
              builder:
                  (BuildContext context, AsyncSnapshot<UserProfile> snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Column(
                    children: [
                      const ImagePick(),
                      const BasicDetails(),
                      const ContactDetails(),
                      const Emergency(),
                      const VehicleInformation(),
                      const MultipleCar(),
                      SubmitForm(
                        isFromSIgnUp: widget.isFromSignUp,
                      ),
                    ],
                  );
                }
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
