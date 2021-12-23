import 'package:flutter/material.dart';

class ImagePick extends StatelessWidget {
  const ImagePick({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: const [
          CircleAvatar(
            radius: 50.0,
            backgroundColor: Colors.brown,
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: CircleAvatar(
              backgroundColor: Color(0xFF7C62FF),
              child: Icon(
                Icons.local_see_outlined,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
