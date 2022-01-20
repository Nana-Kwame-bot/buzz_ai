import 'package:buzz_ai/controllers/profile/emergency_contacts/first_emergency_contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultipleEmergencyContactDialog extends StatefulWidget {
  const MultipleEmergencyContactDialog({Key? key}) : super(key: key);

  @override
  State<MultipleEmergencyContactDialog> createState() =>
      _EmergencyContactDialogState();
}

class _EmergencyContactDialogState
    extends State<MultipleEmergencyContactDialog> {
  var multipleEmergencyContactFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    multipleEmergencyContactFormKey.currentState?.dispose();
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
        child: Consumer(
          builder: (BuildContext context,
              FirstEmergencyContactController emergencyContactController,
              Widget? child) {
            return Form(
              key: multipleEmergencyContactFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Emergency Contact',
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
                        'Phone number',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Relation',
                        hintText: 'Enter your relation',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your relation';
                        }
                        return null;
                      },
                      initialValue: emergencyContactController
                          .firstEmergencyContact.relation,
                      onSaved: emergencyContactController.setRelation,
                      keyboardType: TextInputType.text,
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
                                backgroundColor: const Color(0xFF5247C5),
                              ),
                              // onPressed: validateBasicDetailForms,
                              onPressed: () {},
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

// void validateBasicDetailForms() {
//   if (emergencyContactFormKey.currentState!.validate()) {
//     emergencyContactFormKey.currentState!.save();
//     context.read<EmergencyContactController>()
//       ..contactAdded()
//       ..makeValid();
//     Navigator.of(context).pop();
//   } else {
//     context.read<EmergencyContactController>().makeInvalid();
//   }
// }
}
