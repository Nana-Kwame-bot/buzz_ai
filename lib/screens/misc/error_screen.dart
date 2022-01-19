import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  /// Simple [Scaffold] widget to show interuppting errors.
  /// This is a stateful widget which returns a column with the provided elements with even spacing.
  /// Elements order:
  /// * `errorHeroWidget`
  /// * `title`
  /// * `description`
  /// * `action`
  const ErrorScreen({
    Key? key,
    required this.title,
    required this.description,
    required this.action,
    this.errorHeroWidget,
  }) : super(key: key);

  /// Error title that will be shown with bigger text
  final String title;

  /// Error description that explains briefly what went wrong
  final String description;

  /// Any action that has to be provided to use. Eg., [ElevatedButton], [TextButton], etc,.
  final Widget action;

  /// Any widget that represents the error, like image, gif or animation. Default [Container]
  final Widget? errorHeroWidget;

  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            widget.errorHeroWidget ?? Container(),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 30),
            ),
            Text(
              widget.description,
              style: const TextStyle(fontSize: 20),
            ),
            widget.action
          ],
        ),
      ),
    );
  }
}
