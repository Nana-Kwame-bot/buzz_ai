import 'package:flutter/material.dart';

class SubmitForm extends StatelessWidget {
  const SubmitForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 32.0,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: const Color(0xFF5247C5),
            shape: const StadiumBorder(),
            minimumSize: const Size(100, 35)),
        onPressed: () {},
        child: const Text('SUBMIT'),
      ),
    );
  }
}
