import 'package:buzz_ai/controllers/profile/vehicle_info/vehicle_info_controller.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/multiple_car_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
          ListTile(
            leading: const Icon(
              Icons.control_point,
              color: Color(0xFF00AC47),
            ),
            title: const Text(
              'Do you use multiple car',
              style: TextStyle(fontSize: 14.0),
            ),
            onTap: () {
              Get.dialog(const MultipleCarDialog());
            },
          ),
        ],
      ),
    );
  }
}
