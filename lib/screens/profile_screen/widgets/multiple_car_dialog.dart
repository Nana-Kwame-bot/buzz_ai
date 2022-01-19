import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultipleCarDialog extends StatefulWidget {
  const MultipleCarDialog({Key? key}) : super(key: key);

  @override
  State<MultipleCarDialog> createState() => _MultipleCarDialogState();
}

class _MultipleCarDialogState extends State<MultipleCarDialog> {
  var multipleCarFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    multipleCarFormKey.currentState?.dispose();
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
              MultipleVehicleController multipleVehicleController,
              Widget? child) {
            return Form(
              key: multipleCarFormKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Add Multiple Car',
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
                        hintText: 'Enter owner name',
                      ),
                      initialValue:
                          multipleVehicleController.multipleVehicle.ownerName ??
                              '',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter owner name';
                        }
                        return null;
                      },
                      onSaved: multipleVehicleController.setOwnerName,
                      keyboardType: TextInputType.name,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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
                                initialValue: multipleVehicleController
                                        .multipleVehicle.model ??
                                    '',
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter the model';
                                  }
                                  return null;
                                },
                                onSaved: multipleVehicleController.setModel,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
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
                                initialValue: multipleVehicleController
                                        .multipleVehicle.year ??
                                    '',
                                validator: (String? value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Enter the year';
                                  }
                                  return null;
                                },
                                onSaved: multipleVehicleController.setYear,
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
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Vehicle plate number',
                        hintText: 'Enter the Vehicle plate number',
                      ),
                      initialValue: multipleVehicleController
                              .multipleVehicle.plateNumber ??
                          '',
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter the Vehicle plate number';
                        }
                        return null;
                      },
                      onSaved: multipleVehicleController.setPlateNumber,
                      keyboardType: TextInputType.number,
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
                              onPressed: validateMultipleCarForms,
                              child: const Text(
                                'Add Vehicle',
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

  void validateMultipleCarForms() {
    if (multipleCarFormKey.currentState!.validate()) {
      multipleCarFormKey.currentState!.save();
      Provider.of<MultipleVehicleController>(context, listen: false).added();
      Navigator.of(context).pop();
    }
  }
}
