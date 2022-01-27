import 'package:buzz_ai/controllers/profile/emergency_contacts/first_emergency_contact_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstEmergencyContactDialog extends StatefulWidget {
  const FirstEmergencyContactDialog({Key? key}) : super(key: key);

  @override
  State<FirstEmergencyContactDialog> createState() =>
      _FirstEmergencyContactDialogState();
}

class _FirstEmergencyContactDialogState
    extends State<FirstEmergencyContactDialog> {
  var firstEmergencyContactFormKey = GlobalKey<FormState>();
  String _relationValue = "Mother";
  List<String> relationships = [
    "Father",
    "Mother",
    "Brother",
    "Sister",
    "Son",
    "Daughter",
    "Grand Father",
    "Grand Mother",
    "Wife",
    "Husband",
    "Fiancé",
    "Aunt",
    "Uncle",
    "Niece",
    "Nephew",
    "Boyfriend",
    "Girlfriend",
    "Lover",
    "Client",
    "Patient",
    "Friend",
  ];

  @override
  void didChangeDependencies() {
    String storedRelationship =
        Provider.of<FirstEmergencyContactController>(context, listen: false)
                .firstEmergencyContact
                .relation ??
            "";

    if (storedRelationship != "") {
      _relationValue = storedRelationship;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    firstEmergencyContactFormKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Consumer2(
          builder: (BuildContext context,
              FirstEmergencyContactController emergencyContactController,
              UserProfileController userProfileController,
              Widget? child) {
            return Form(
              key: firstEmergencyContactFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add First Emergency Contact',
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
                        'Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      enabled: userProfileController.formEnabled,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Enter your name',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your name';
                        }
                        return null;
                      },
                      initialValue: emergencyContactController
                              .firstEmergencyContact.name ??
                          '',
                      onSaved: emergencyContactController.setName,
                      keyboardType: TextInputType.name,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Text(
                        'Relation',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    DropdownButtonFormField(
                      value: _relationValue,
                      items: relationships
                          .map<DropdownMenuItem<String>>(
                              (relation) => DropdownMenuItem(
                                    value: relation,
                                    child: Text(relation),
                                  ))
                          .toList(),
                      onChanged: userProfileController.formEnabled
                          ? (String? value) {
                              if (value == null) return;

                              emergencyContactController.setRelation(value);
                              setState(() {
                                _relationValue = value;
                              });
                            }
                          : null,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Blood group',
                        hintText: 'Enter your blood group',
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: const Text(
                        'Emergency Contact',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      enabled: userProfileController.formEnabled,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Emergency Contact',
                        hintText: 'Enter your emergency contact',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your emergency contact';
                        }
                        return null;
                      },
                      initialValue: emergencyContactController
                              .firstEmergencyContact.contactNumber ??
                          '',
                      onSaved: emergencyContactController.setEmergencyContact,
                      keyboardType: TextInputType.phone,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Close',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    userProfileController.formEnabled
                                        ? const Color(0xFF5247C5)
                                        : Colors.grey,
                              ),
                              onPressed: userProfileController.formEnabled
                                  ? validateEmergencyContactForm
                                  : null,
                              child: const Text(
                                'Add Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void validateEmergencyContactForm() {
    if (firstEmergencyContactFormKey.currentState!.validate()) {
      firstEmergencyContactFormKey.currentState!.save();
      context.read<FirstEmergencyContactController>()
        ..contactAdded()
        ..makeValid();
      Navigator.of(context).pop();
    } else {
      context.read<FirstEmergencyContactController>().makeInvalid();
    }
  }
}
