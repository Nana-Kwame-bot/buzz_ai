import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IssueNotifier extends StatefulWidget {
  const IssueNotifier({Key? key, required this.child}) : super(key: key);

  /// The widget below this widget in th tree
  final Widget child;

  @override
  _IssueNotifierState createState() => _IssueNotifierState();
}

class _IssueNotifierState extends State<IssueNotifier> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          widget.child,
          Consumer<IssueNotificationProvider>(
            builder: (context, IssueNotificationProvider issueNotification,
                    Widget? child) =>
                Visibility(
              visible: issueNotification.issue.isNotEmpty,
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      color: issueNotification.color,
                      child: Center(child: Text(issueNotification.issue)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IssueNotificationProvider extends ChangeNotifier {
  /// Show a strip of container on top of the app as a overlay with a issue text and a background color.
  /// Wrap the [IssueNotifier] widget over the topmost widget in the tree to make use of this provider.
  /// Default[color] is set to [Colors.red] but you can customize it with the issueLevel.
  /// issueLevel's:
  /// * 0 = Colors.red
  /// * 1 = Colors.orange
  /// * 2 = Colors.amberAccent
  
  IssueNotificationProvider({
    this.issue = "",
    this.issueLevel = 0,
    this.color = Colors.red,
  });

  /// State the issue briefly in 6 - 8 words.
  String issue;

  /// Defines the basic background colors for issue, ranging from 0 - 2 where 1 being the highest.
  int issueLevel;

  /// Background color of the issue.
  Color color;

  /// Show a issue notification on top of the app
  void showIssue({
    required String issue,
    required int issueLevel,
    Color? color,
  }) {
    this.issue = issue;
    this.issueLevel = issueLevel;
    this.color = color ?? this.color;

    switch (issueLevel) {
      case 2:
        this.color = Colors.amberAccent;
        break;
      case 1:
        this.color = Colors.orangeAccent;
        break;
      case 0:
        this.color = Colors.red;
        break;
      default:
        this.color = Colors.red;
    }

    notifyListeners();
  }

  /// Hide the currently active issue notification
  void hideIssue() {
    issue = "";
    issueLevel = 0;

    notifyListeners();
  }
}
