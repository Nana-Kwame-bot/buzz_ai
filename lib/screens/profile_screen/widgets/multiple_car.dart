import 'package:flutter/material.dart';

class MultipleCar extends StatelessWidget {
  const MultipleCar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: const [
          Align(
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
            leading: Icon(
              Icons.control_point,
              color: Color(0xFF00AC47),
            ),
            title: Text(
              'Do you use multiple car',
              style: TextStyle(fontSize: 14.0),
            ),
          ),
        ],
      ),
    );
  }
}
