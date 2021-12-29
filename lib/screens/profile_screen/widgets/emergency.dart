import 'package:buzz_ai/controllers/profile/emergency_contact/emergency_contact_controller.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency_contact_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer<EmergencyContactController>(
        builder: (BuildContext context, value, Widget? child) {
          return ListTile(
            leading: value.emergencyContact.contactAdded!
                ? const SizedBox.shrink()
                : const Icon(
                    Icons.control_point,
                    color: Color(0xFF00AC47),
                  ),
            title: Text(
              value.emergencyContact.contactAdded!
                  ? 'Emergency Contact Added'
                  : 'Add Emergency Contact',
              style: const TextStyle(fontSize: 14.0),
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const EmergencyContactDialog();
                  });
            },
          );
        },
      ),
    );
  }
}
