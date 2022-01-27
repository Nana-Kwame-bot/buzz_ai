import 'dart:async';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/contact_detail/contact_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ContactDetails extends StatefulWidget {
  const ContactDetails({Key? key}) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  Timer? _timer;
  final contactDetailsFormKey =
      GlobalKey<FormState>(debugLabel: 'contactDetailsFormKey');

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (contactDetailsFormKey.currentState!.validate()) {
        context.read<ContactDetailController>().makeValid();
      } else {
        context.read<ContactDetailController>().makeInvalid();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer2(
        builder: (
          BuildContext context,
          ContactDetailController contactDetailController,
          UserProfileController userProfileController,
          Widget? child,
        ) {
          return Form(
            autovalidateMode: AutovalidateMode.always,
            key: contactDetailsFormKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contact Detail',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue:
                      contactDetailController.contactDetail.address ?? '',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                    hintText: 'Enter your address',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your address';
                    }
                    return null;
                  },
                  onChanged: contactDetailController.setAddress,
                  keyboardType: TextInputType.name,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'Phone number',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue: Provider.of<AuthenticationController>(context, listen: false).auth.currentUser?.phoneNumber ?? "",
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone number',
                    hintText: 'Enter your phone number',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your phone number';
                    }
                    return null;
                  },
                  onChanged: contactDetailController.setPhoneNumber,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    contactDetailsFormKey.currentState?.dispose();
    super.dispose();
  }
}
