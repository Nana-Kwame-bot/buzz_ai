import 'dart:async';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key, this.isFromSignUp}) : super(key: key);

  final bool? isFromSignUp;

  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  Timer? _timer;
  final TextEditingController _dobKey = TextEditingController();
  final TextEditingController _ageKey = TextEditingController();

  final List<String> _bloodGroups = [
    "A +",
    "A -",
    "B +",
    "B -",
    "AB +",
    "AB -",
    "O +",
    "O -"
  ];
  String _dropDownValue = "";

  final basicDetailsFormKey =
      GlobalKey<FormState>(debugLabel: 'basicDetailsFormKey');

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (basicDetailsFormKey.currentState == null) return;

      if (basicDetailsFormKey.currentState!.validate()) {
        context.read<BasicDetailController>().makeValid();
      } else {
        context.read<BasicDetailController>().makeInvalid();
      }
    });
    Provider.of<UserProfileController>(context, listen: false).formEnabled =
        widget.isFromSignUp ?? false;
    _dobKey.text = Provider.of<BasicDetailController>(context, listen: false)
            .basicDetail
            .dateOfBirth ??
        "";
    _ageKey.text = (Provider.of<BasicDetailController>(context, listen: false)
                .basicDetail
                .age ??
            "")
        .toString();

    _dropDownValue = Provider.of<BasicDetailController>(context, listen: false)
            .basicDetail
            .bloodGroup ??
        _bloodGroups.first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Consumer2(
        builder: (
          BuildContext context,
          BasicDetailController basicDetailController,
          UserProfileController userProfileController,
          Widget? child,
        ) {
          return Form(
            autovalidateMode: AutovalidateMode.always,
            key: basicDetailsFormKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Basic Detail',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !(widget.isFromSignUp ?? false),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            userProfileController.changeFormState();
                            ScaffoldMessenger.of(context)
                              ..clearSnackBars()
                              ..showSnackBar(
                                SnackBar(
                                  backgroundColor: defaultColor,
                                  duration: const Duration(seconds: 2),
                                  content: Text(
                                    userProfileController.formEnabled
                                        ? 'Form Enabled'
                                        : 'Form Disabled',
                                  ),
                                ),
                              );
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: defaultColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'Full name',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue:
                      basicDetailController.basicDetail.fullName ?? '',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Full name',
                    hintText: 'Enter your full name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your full name';
                    }
                    return null;
                  },
                  onChanged: basicDetailController.setFullName,
                  keyboardType: TextInputType.name,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'Date of birth',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                InkWell(
                  child: TextFormField(
                    controller: _dobKey,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Date of birth',
                      hintText: 'Enter your date of birth',
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your date of birth';
                      }
                      return null;
                    },
                    onChanged: basicDetailController.setDOB,
                    keyboardType: TextInputType.datetime,
                  ),
                  onTap: userProfileController.formEnabled
                      ? () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now()
                                .add(const Duration(days: -(365 * 50))),
                            firstDate: DateTime.now()
                                .add(const Duration(days: -(365 * 50))),
                            lastDate: DateTime.now()
                                .add(const Duration(days: -(365 * 5))),
                          ).then((value) {
                            if (value == null) return;

                            _dobKey.text =
                                "${value.day}-${value.month}-${value.year}";
                            basicDetailController.setDOB(_dobKey.text);

                            basicDetailController.setAge(
                                (DateTime.now().difference(value).inDays ~/ 365)
                                    .toString());

                            setState(() {
                              _ageKey.text =
                                  (DateTime.now().difference(value).inDays ~/
                                          365)
                                      .toString();
                            });
                          });
                        }
                      : null,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'Weight',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue:
                      basicDetailController.basicDetail.weight.toString() ==
                              'null'
                          ? ''
                          : basicDetailController.basicDetail.weight.toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    hintText: 'Enter your weight',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your  weight';
                    }
                    return null;
                  },
                  onChanged: basicDetailController.setWeight,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'Gender',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: RadioListTile<Gender>(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(),
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                        ),
                        value: Gender.male,
                        title: const Text(
                          'Male',
                        ),
                        groupValue: userProfileController.gender,
                        onChanged: userProfileController.formEnabled
                            ? userProfileController.setGender
                            : null,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: RadioListTile<Gender>(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(),
                          borderRadius: BorderRadius.circular(
                            4.0,
                          ),
                        ),
                        value: Gender.female,
                        title: const Text(
                          'Female',
                        ),
                        groupValue: userProfileController.gender,
                        onChanged: userProfileController.formEnabled
                            ? userProfileController.setGender
                            : null,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: const Text(
                              'Age',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: false,
                            controller: _ageKey,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Age',
                              hintText: 'Enter your age',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your age';
                              }
                              return null;
                            },
                            onChanged: basicDetailController.setAge,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: const Text(
                              'Blood group',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          DropdownButtonFormField<String>(
                            value: _dropDownValue,
                            hint: const Text("Blood Type"),
                            items: _bloodGroups
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              if (value == null) return;

                              basicDetailController.setBloodGroup(value);
                              setState(() {
                                _dropDownValue = value;
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Blood group',
                              hintText: 'Enter your blood group',
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: const Text(
                    'License number',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue: basicDetailController.basicDetail.licenseNumber
                              .toString() ==
                          'null'
                      ? ''
                      : basicDetailController.basicDetail.licenseNumber
                          .toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'License number',
                    hintText: 'Enter your license number',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your license number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: basicDetailController.setLicenseNumber,
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
    basicDetailsFormKey.currentState?.dispose();
    super.dispose();
  }
}
