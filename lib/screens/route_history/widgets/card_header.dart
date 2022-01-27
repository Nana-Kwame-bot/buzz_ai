import 'package:buzz_ai/screens/route_history/widgets/from_date_time.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:ui' as ui;

class CardHeader extends StatelessWidget {
  const CardHeader({
    Key? key,
    this.icon = const FaIcon(
      FontAwesomeIcons.carSide,
      size: 50,
      color: Color(0xff7b69da),
    ),
    required this.text,
    this.subText = "",
    required this.index,
  }) : super(key: key);

  final Widget icon;
  final String text;
  final String subText;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Hero(
          tag: "car-$index",
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) => ui.Gradient.linear(
              const Offset(0, 0),
              const Offset(0, 60),
              [
                const Color(0xff413394),
                const Color(0xff7C62FF),
              ],
            ),
            child: icon,
          ),
        ),
        Hero(
          tag: "from-to-$index",
          child: FromDateTime(text: text, subText: subText),
        ),
      ],
    );
  }
}
