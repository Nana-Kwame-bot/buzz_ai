import 'package:buzz_ai/controllers/profile/emergency_contacts/fifth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/first_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/fourth_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/second_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/emergency_contacts/third_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency_contact_dialogs/fifth_emergency_contact_dialog.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency_contact_dialogs/first_emergency_contact_dialog.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency_contact_dialogs/fourth_emergency_contact_dialog.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency_contact_dialogs/second_emergency_contact_dialog.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency_contact_dialogs/third_emergency_contact_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Emergency extends StatefulWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  State<Emergency> createState() => _EmergencyState();
}

class _EmergencyState extends State<Emergency> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer6(
        builder: (
          BuildContext context,
          FirstEmergencyContactController firstEmergencyContactController,
          SecondEmergencyContactController secondEmergencyContactController,
          ThirdEmergencyContactController thirdEmergencyContactController,
          FourthEmergencyContactController fourthEmergencyContactController,
          FifthEmergencyContactController fifthEmergencyContactController,
          UserProfileController userProfileController,
          Widget? child,
        ) {
          return Column(
            children: [
              ListTile(
                leading: firstEmergencyContactController
                        .firstEmergencyContact.contactAdded!
                    ? IconButton(
                        color: Colors.red,
                        onPressed: userProfileController.formEnabled
                            ? () {
                                setState(() {
                                  firstEmergencyContactController.clear();
                                });
                              }
                            : null,
                        icon: const Icon(
                          Icons.remove_circle_outline,
                        ),
                      )
                    : IconButton(
                        color: const Color(0xFF00AC47),
                        onPressed: () {},
                        icon: const Icon(
                          Icons.control_point,
                        ),
                      ),
                title: Text(
                  firstEmergencyContactController
                          .firstEmergencyContact.contactAdded!
                      ? 'First Emergency Contact'
                      : 'Add Emergency Contact',
                  style: const TextStyle(fontSize: 14.0),
                ),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const FirstEmergencyContactDialog();
                    }),
              ),
              if (firstEmergencyContactController
                  .firstEmergencyContact.contactAdded!) ...[
                secondContact(
                  secondEmergencyContactController:
                      secondEmergencyContactController,
                  userProfileController: userProfileController,
                )
              ],
              if (secondEmergencyContactController
                  .secondEmergencyContact.contactAdded!) ...[
                thirdContact(
                  thirdEmergencyContactController:
                      thirdEmergencyContactController,
                  userProfileController: userProfileController,
                ),
                if (thirdEmergencyContactController
                    .thirdEmergencyContact.contactAdded!) ...[
                  fourthContact(
                    fourthEmergencyContactController:
                        fourthEmergencyContactController,
                    userProfileController: userProfileController,
                  ),
                  if (fourthEmergencyContactController
                      .fourthEmergencyContact.contactAdded!) ...[
                    fifthContact(
                      fifthEmergencyContactController:
                          fifthEmergencyContactController,
                      userProfileController: userProfileController,
                    ),
                  ],
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  Widget secondContact({
    required SecondEmergencyContactController secondEmergencyContactController,
    required UserProfileController userProfileController,
  }) {
    return ListTile(
      leading:
          secondEmergencyContactController.secondEmergencyContact.contactAdded!
              ? IconButton(
                  color: Colors.transparent,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                )
              : IconButton(
                  color: const Color(0xFF00AC47),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.control_point,
                  ),
                ),
      title: Text(
        secondEmergencyContactController.secondEmergencyContact.contactAdded!
            ? 'Second Emergency Contact'
            : 'Add Second Emergency Contact',
        style: const TextStyle(fontSize: 14.0),
      ),
      onTap: userProfileController.formEnabled
          ? () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return const SecondEmergencyContactDialog();
              })
          : null,
    );
  }

  Widget thirdContact({
    required ThirdEmergencyContactController thirdEmergencyContactController,
    required UserProfileController userProfileController,
  }) {
    return ListTile(
      leading:
          thirdEmergencyContactController.thirdEmergencyContact.contactAdded!
              ? IconButton(
                  color: Colors.transparent,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                )
              : IconButton(
                  color: const Color(0xFF00AC47),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.control_point,
                  ),
                ),
      title: Text(
        thirdEmergencyContactController.thirdEmergencyContact.contactAdded!
            ? 'Third Emergency Contact'
            : 'Add Third Emergency Contact',
        style: const TextStyle(fontSize: 14.0),
      ),
      onTap: userProfileController.formEnabled
          ? () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return const ThirdEmergencyContactDialog();
              })
          : null,
    );
  }

  Widget fourthContact({
    required FourthEmergencyContactController fourthEmergencyContactController,
    required UserProfileController userProfileController,
  }) {
    return ListTile(
      leading:
          fourthEmergencyContactController.fourthEmergencyContact.contactAdded!
              ? IconButton(
                  color: Colors.transparent,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                )
              : IconButton(
                  color: const Color(0xFF00AC47),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.control_point,
                  ),
                ),
      title: Text(
        fourthEmergencyContactController.fourthEmergencyContact.contactAdded!
            ? 'Fourth Emergency Contact'
            : 'Add Fourth Emergency Contact',
        style: const TextStyle(fontSize: 14.0),
      ),
      onTap: userProfileController.formEnabled
          ? () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return const FourthEmergencyContactDialog();
              })
          : null,
    );
  }

  Widget fifthContact({
    required FifthEmergencyContactController fifthEmergencyContactController,
    required UserProfileController userProfileController,
  }) {
    return ListTile(
      leading:
          fifthEmergencyContactController.fifthEmergencyContact.contactAdded!
              ? IconButton(
                  color: Colors.transparent,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                )
              : IconButton(
                  color: const Color(0xFF00AC47),
                  onPressed: () {},
                  icon: const Icon(
                    Icons.control_point,
                  ),
                ),
      title: Text(
        fifthEmergencyContactController.fifthEmergencyContact.contactAdded!
            ? 'Fifth Emergency Contact'
            : 'Add Fifth Emergency Contact',
        style: const TextStyle(fontSize: 14.0),
      ),
      onTap: userProfileController.formEnabled
          ? () => showDialog(
              context: context,
              builder: (BuildContext context) {
                return const FifthEmergencyContactDialog();
              })
          : null,
    );
  }
}
