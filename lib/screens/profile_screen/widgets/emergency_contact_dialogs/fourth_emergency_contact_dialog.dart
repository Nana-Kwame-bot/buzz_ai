import 'package:buzz_ai/controllers/profile/emergency_contacts/fourth_emergency_contact_controller.dart';
import 'package:buzz_ai/global/all_relationships.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FourthEmergencyContactDialog extends StatefulWidget {
  const FourthEmergencyContactDialog({Key? key}) : super(key: key);

  @override
  State<FourthEmergencyContactDialog> createState() =>
      _FourthEmergencyContactDialogState();
}

class _FourthEmergencyContactDialogState
    extends State<FourthEmergencyContactDialog> {
  var fourthEmergencyContactFormKey = GlobalKey<FormState>();
  List<String> relationships = allRelationShips;
  String _relationValue = "Mother";

  @override
  void didChangeDependencies() {
    String storedRelationship =
        Provider.of<FourthEmergencyContactController>(context, listen: false)
                .fourthEmergencyContact
                .relation ??
            "";

    if (storedRelationship != "") {
      _relationValue = storedRelationship;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    fourthEmergencyContactFormKey.currentState?.dispose();
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
              FourthEmergencyContactController fourthEmergencyContactController,
              Widget? child) {
            return Form(
              key: fourthEmergencyContactFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add Fourth Emergency Contact',
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
                      initialValue: fourthEmergencyContactController
                              .fourthEmergencyContact.name ??
                          '',
                      onSaved: fourthEmergencyContactController.setName,
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
                      onChanged: (String? value) {
                        if (value == null) return;

                        fourthEmergencyContactController.setRelation(value);
                        setState(() {
                          _relationValue = value;
                        });
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Relationship',
                        hintText:
                            'Enter your relation with the emergency contact',
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
                      initialValue: fourthEmergencyContactController
                              .fourthEmergencyContact.contactNumber ??
                          '',
                      onSaved:
                          fourthEmergencyContactController.setEmergencyContact,
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
                              onPressed: validateEmergencyContactForm,
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
    if (fourthEmergencyContactFormKey.currentState!.validate()) {
      fourthEmergencyContactFormKey.currentState!.save();
      context.read<FourthEmergencyContactController>()
        ..contactAdded()
        ..makeValid();
      Navigator.of(context).pop();
    } else {
      context.read<FourthEmergencyContactController>().makeInvalid();
    }
  }
}
