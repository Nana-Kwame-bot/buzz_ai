import 'package:buzz_ai/controllers/profile/multiple_car/multiple_car_controller.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/multiple_car_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MultipleCar extends StatelessWidget {
  const MultipleCar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Second vehicle information',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.0,
              ),
            ),
          ),
          Provider.of<MultipleVehicleController>(context).multipleVehicle.added!
              ? Consumer(
                builder: (BuildContext context,
                    MultipleVehicleController multi, Widget? child) {
                  return Column(
                    children: [
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
                        ),
                        initialValue: multi.multipleVehicle.ownerName,
                        readOnly: true,
                        enabled: false,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
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
                                  ),
                                  initialValue: multi.multipleVehicle.model,
                                  readOnly: true,
                                  enabled: false,
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
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
                                  ),
                                  initialValue: multi.multipleVehicle.year,
                                  readOnly: true,
                                  enabled: false,
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
                        ),
                        readOnly: true,
                        enabled: false,
                        initialValue: multi.multipleVehicle.plateNumber,
                      ),
                    ],
                  );
                },
              )
              : const SizedBox.shrink(),
          Provider.of<MultipleVehicleController>(context).multipleVehicle.added!
              ? const SizedBox.shrink()
              : ListTile(
                  leading: const Icon(
                    Icons.control_point,
                    color: Color(0xFF00AC47),
                  ),
                  title: const Text(
                    'Do you use multiple car',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const MultipleCarDialog();
                        });
                  },
                ),
        ],
      ),
    );
  }
}
