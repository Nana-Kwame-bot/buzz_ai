import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/contact_details.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/details.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/image_pick.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/multiple_car.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/submit_form.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/vehicle_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  static const String iD = '/profile';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
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
          child: Consumer(
            builder: (
              BuildContext context,
              VehicleInfoController vehicleInfoController,
              Widget? child,
            ) {
              return Column(
                children: [
                  const ImagePick(),
                  const BasicDetails(),
                  const ContactDetails(),
                  const Emergency(),
                  const VehicleInformation(),
                  const MultipleCar(),

                  const SubmitForm(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
