import 'dart:developer';

import 'package:buzz_ai/models/profile/emergency_contact/emergency_contact.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/emergency_contact_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: ListTile(
        leading: const Icon(
          Icons.control_point,
          color: Color(0xFF00AC47),
        ),
        title: const Text(
          'Add Emergency Contact',
          style: TextStyle(fontSize: 14.0),
        ),
        onTap: () {
          Get.dialog(const EmergencyContactDialog());
        },
      ),
    );
  }
}
