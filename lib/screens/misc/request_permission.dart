import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:buzz_ai/screens/bottom_navigation/bottom_navigation.dart';
import 'package:buzz_ai/widgets/issue_notifier.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RequestPermission extends StatelessWidget {
  final List<Map<String, dynamic>> _allPermissions = [
    {
      "permission": Permission.location,
      "name": "Location",
      "description": "To access features like maps and navigation.",
    },
    {
      "permission": Permission.locationAlways,
      "name": "Location Always",
      "description":
          "To monitor device activity for triggering SOS and other emergency features.",
    },
    {
      "permission": Permission.activityRecognition,
      "name": "Activity Recognition",
      "description":
          "To recognize if you are on foot or in vehicle to start recording your travel.",
    },
    {
      "permission": Permission.camera,
      "name": "Camera",
      "description": "To capture accidents.",
    },
    {
      "permission": Permission.microphone,
      "name": "Microphone",
      "description": "To record audio when an accident happens.",
    },
  ];

  RequestPermission({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: ListView.builder(
          itemCount: _allPermissions.length + 2,
          itemBuilder: (context, index) {
            if (index == 0) {
              return const Text("We need certian permissions to run the app.");
            }

            if (index == _allPermissions.length + 1) {
              return ElevatedButton(
                child: const Text("Continue"),
                onPressed: () async {
                  for (var element in _allPermissions) {
                    Permission permission = element["permission"];

                    if (!(await permission.isGranted)) {
                      Provider.of<IssueNotificationProvider>(context,
                              listen: false)
                          .showIssue(
                              issue: "Please provide all permissions!",
                              issueLevel: 2);
                      Future.delayed(const Duration(seconds: 10)).then(
                          (value) => Provider.of<IssueNotificationProvider>(
                                  context,
                                  listen: false)
                              .hideIssue());

                      return;
                    }
                  }

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool("allPermissionsGranted", true);
                  Navigator.of(context).pushNamed(BottomNavigation.iD);
                },
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: _PermissionContainer(
                permission: _allPermissions[index - 1]["permission"],
                name: _allPermissions[index - 1]["name"],
                description: _allPermissions[index - 1]["description"],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _PermissionContainer extends StatefulWidget {
  _PermissionContainer({
    Key? key,
    required this.permission,
    required this.name,
    required this.description,
  }) : super(key: key);

  final Permission permission;
  final String description;
  final String name;
  bool granted = false;

  @override
  State<_PermissionContainer> createState() => _PermissionContainerState();
}

class _PermissionContainerState extends State<_PermissionContainer> {
  @override
  void initState() {
    _checkForPermission();
    super.initState();
  }

  Future<void> _checkForPermission() async {
    bool status = await widget.permission.isGranted;

    setState(() => widget.granted = status);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AutoSizeText(
                  widget.description,
                  maxLines: 4,
                ),
              ],
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 1,
            child: Switch(
              value: widget.granted,
              onChanged: widget.granted ? null : _onSwitch,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSwitch(value) async {
    if (!(await widget.permission.isGranted)) {
      PermissionStatus status = await widget.permission.request();

      if (widget.permission == Permission.locationAlways) {
        Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (await widget.permission.isGranted) {
            setState(() => widget.granted = true);
            timer.cancel();
          }
        });
        return;
      }

      setState(() => widget.granted = status.isGranted);
    }
  }
}
