import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VehicleInformation extends StatelessWidget {
  const VehicleInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Consumer(
        builder: (BuildContext context,
            VehicleInfoController vehicleInfoController, Widget? child) {
          return Form(
            key: vehicleInfoController.vehicleInfoFormKey,
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
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Owner name',
                    hintText: "Enter the owner's name",
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the owner's name";
                    }
                    return null;
                  },
                  onSaved: vehicleInfoController.setOwnerName,
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Model',
                              hintText: 'Enter the model',
                            ),
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please the model';
                              }
                              return null;
                            },
                            onSaved: vehicleInfoController.setModel,
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
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Year',
                              hintText: 'Enter the year',
                            ),
                            keyboardType: TextInputType.datetime,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter the year';
                              }
                              return null;
                            },
                            onSaved: vehicleInfoController.setYear,
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
                    'Vehicle plate numer',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle plate numer',
                    hintText: "Enter the vehicle's plate numer",
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter the vehicle's plate numer";
                    }
                    return null;
                  },
                  onSaved: vehicleInfoController.setPlateNumber,
                  keyboardType: TextInputType.text,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
