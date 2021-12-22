import 'package:flutter/material.dart';

class TextFormWidget extends StatelessWidget {
  TextFormWidget(
      {Key? key,
      this.heading,
      this.type,
      this.onSaved,
      this.controller,
      this.initialValue,
      this.textalign})
      : super(key: key);
  final _formKey = GlobalKey<FormState>();
  String? heading;
  final TextInputType? type;
  final onSaved;
  final TextEditingController? controller;
  final initialValue;
  final textalign;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: 290,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          textAlign: textalign,
          controller: controller,
          initialValue: initialValue,
          onSaved: onSaved,
          keyboardType: type,
          decoration: InputDecoration(
            hintText: heading,
            hoverColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
