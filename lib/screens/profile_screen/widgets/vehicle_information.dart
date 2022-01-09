import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleInformation extends StatefulWidget {
  const VehicleInformation({Key? key}) : super(key: key);

  @override
  State<VehicleInformation> createState() => _VehicleInformationState();
}

class _VehicleInformationState extends State<VehicleInformation> {
  final vehicleInfoFormKey =
      GlobalKey<FormState>(debugLabel: 'vehicleInfoFormKey');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer2(
        builder: (BuildContext context,
            VehicleInfoController vehicleInfoController,
            UserProfileController userProfileController,
            Widget? child) {
          return Form(
            autovalidateMode: AutovalidateMode.always,
            onChanged: () {
              if (vehicleInfoFormKey.currentState!.validate()) {
                vehicleInfoController.makeValid();
              } else {
                vehicleInfoController.makeInvalid();
              }
            },
            key: vehicleInfoFormKey,
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Vehicle information',
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
                    'Owner name',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue:
                  vehicleInfoController.vehicleInfo.ownerName ?? '',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Owner name',
                    hintText: "Enter the owner's name",
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Enter the owner's name";
                    }
                    return null;
                  },
                  onChanged: vehicleInfoController.setOwnerName,
                  keyboardType: TextInputType.name,
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
                              'Model',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: userProfileController.formEnabled,
                            initialValue:vehicleInfoController.vehicleInfo.model ?? '',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Model',
                              hintText: 'Enter the model',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the model';
                              }
                              return null;
                            },
                            onChanged: vehicleInfoController.setModel,
                            keyboardType: TextInputType.text,
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
                              'Year',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                          TextFormField(
                            enabled: userProfileController.formEnabled,
                            initialValue: vehicleInfoController.vehicleInfo.year ?? '',
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Year',
                              hintText: 'Enter the year',
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the year';
                              }
                              return null;
                            },
                            onChanged: vehicleInfoController.setYear,
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
                    'Vehicle plate number',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  enabled: userProfileController.formEnabled,
                  initialValue: vehicleInfoController.vehicleInfo.plateNumber ?? '',
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle plate number',
                    hintText: "Enter the vehicle's plate number",
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Enter the vehicle's plate number";
                    }
                    return null;
                  },
                  onChanged: vehicleInfoController.setPlateNumber,
                  keyboardType: TextInputType.number,
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
    vehicleInfoFormKey.currentState?.dispose();
    super.dispose();
  }
}
