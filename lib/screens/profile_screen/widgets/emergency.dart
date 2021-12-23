import 'package:flutter/material.dart';

class Emergency extends StatelessWidget {
  const Emergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: ListTile(
        leading: Icon(
          Icons.control_point,
          color: Color(0xFF00AC47),
        ),
        title: Text(
          'Add Emergency Contact',
          style: TextStyle(fontSize: 14.0),
        ),
      ),
    );
  }
}
