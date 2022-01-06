import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/models/profile/gender/gender.dart';
import 'package:buzz_ai/services/widgets/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key}) : super(key: key);

  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  final basicDetailsFormKey =
      GlobalKey<FormState>(debugLabel: 'basicDetailsFormKey');

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
            onChanged: () {
              if (basicDetailsFormKey.currentState!.validate()) {
                basicDetailController.makeValid();
              } else {
                basicDetailController.makeInvalid();
              }
            },
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
                    Align(
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
                      userProfileController.userProfile.basicDetail?.fullName,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    // labelText: 'Full name',
                    // hintText: 'Enter your full name',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
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
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue: userProfileController
                      .userProfile.basicDetail?.dateOfBirth,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Date of birth',
                    hintText: 'Enter your date of birth',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your date of birth';
                    }
                    return null;
                  },
                  onChanged: basicDetailController.setDOB,
                  keyboardType: TextInputType.datetime,
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
                  initialValue: userProfileController
                      .userProfile.basicDetail?.weight
                      .toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Weight',
                    hintText: 'Enter your weight',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your  weight';
                    }
                    return null;
                  },
                  onChanged: basicDetailController.setWeight,
                  keyboardType: TextInputType.number,
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
                Consumer(
                  builder: (BuildContext context,
                      UserProfileController controller, Widget? child) {
                    return Row(
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
                            onChanged: controller.formEnabled
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
                            onChanged: controller.formEnabled
                                ? userProfileController.setGender
                                : null,
                          ),
                        ),
                      ],
                    );
                  },
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
                            enabled: userProfileController.formEnabled,
                            initialValue: userProfileController
                                .userProfile.basicDetail?.age
                                .toString(),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Age',
                              hintText: 'Enter your age',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              return null;
                            },
                            onChanged: basicDetailController.setAge,
                            keyboardType: TextInputType.number,
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
                          TextFormField(
                            enabled: userProfileController.formEnabled,
                            initialValue: userProfileController
                                .userProfile.basicDetail?.bloodGroup,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Blood group',
                              hintText: 'Enter your blood group',
                            ),
                            keyboardType: TextInputType.text,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your blood group';
                              }
                              return null;
                            },
                            onChanged: basicDetailController.setBloodGroup,
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
                  initialValue: userProfileController
                      .userProfile.basicDetail?.licenseNumber
                      .toString(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'License number',
                    hintText: 'Enter your license number',
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your license number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
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
    basicDetailsFormKey.currentState?.dispose();
    super.dispose();
  }
}
