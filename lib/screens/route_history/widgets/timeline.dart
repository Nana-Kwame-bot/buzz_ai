import 'package:flutter/material.dart';

class Timeline extends StatelessWidget {
  const Timeline({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 14,
          width: 14,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.red,
                width: 2,
              )),
        ),
        const Expanded(
          flex: 3,
          child: Divider(
            color: Colors.grey,
            thickness: 1.5,
          ),
        ),
        Container(
          height: 14,
          width: 14,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green,
                width: 2,
              )),
        ),
      ],
    );
  }
}
