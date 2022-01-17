import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  Map data = {};
  String str = "";

  @override
  void initState() {
    super.initState();
  }

  void hey(Box box) {
    data[DateTime.now()] = box.values;
    str = "";
    data.forEach((key, value) {
      str += "${key} => ${value}\n";
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Box>(
          future: a(),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.done) {
              Timer.periodic(Duration(seconds: 5), (timer) => hey(snap.data!));
              return SingleChildScrollView(child: Text(str));
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Future<Box> a() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    Hive.init(path);
    Box box = await Hive.openBox("sensor_data");

    return box;
  }
}
