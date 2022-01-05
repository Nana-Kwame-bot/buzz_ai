import 'package:flutter/material.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/image_pick.dart';
import 'package:buzz_ai/models/profile/image_pick/image_pick_controller.dart';


class AccidentReportScreen extends StatefulWidget {
  static const String iD = '/accidentreport';

  const AccidentReportScreen({Key? key}) : super(key: key);

  @override
  _AccidentReportScreenState createState() => _AccidentReportScreenState();
}

class _AccidentReportScreenState extends State<AccidentReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'Report Accident',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,


      body: SingleChildScrollView(
        child: Padding(
    padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
    child: Column(
        children: [
          Container(
            height: 91,
            child: Row(
              children: const [

              ],
            ),
          ),

          Container(
            child: Column(
              children: [
                Row(
                  children: const [
                    Expanded(child: Divider(
                      color: Color.fromRGBO(202, 27, 0, 1),
                      indent: 0,
                      endIndent: 5,

                    )),
                    Text("License Details", style: TextStyle(
                      color: Color.fromRGBO(202, 27, 0, 1),
                      fontSize: 14,
                    ),),
                    Expanded(child: Divider(
                      color: Color.fromRGBO(202, 27, 0, 1),
                      indent: 5,
                      endIndent: 0,
                    )),

                  ]),
                const SizedBox(height: 10,),

                TextFormField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      height: 1
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: '(Required)',
                  ),
                ),

                const SizedBox(height: 5,),

                Row(
                    children: const [
                      Expanded(child: Divider(
                        color: Color.fromRGBO(202, 27, 0, 1),
                        indent: 0,
                        endIndent: 5,

                      )),
                      Text("Car Number Plate", style: TextStyle(
                        color: Color.fromRGBO(202, 27, 0, 1),
                        fontSize: 14,
                      ),),
                      Expanded(child: Divider(
                        color: Color.fromRGBO(202, 27, 0, 1),
                        indent: 5,
                        endIndent: 0,
                      )),

                    ]),
                const SizedBox(height: 10,),

                TextFormField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      height: 1
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: 'Car Number Plate',
                  ),
                ),

                const SizedBox(height: 5,),

                Row(
                    children: const [
                      Expanded(child: Divider(
                        color: Color.fromRGBO(202, 27, 0, 1),
                        indent: 0,
                        endIndent: 5,

                      )),
                      Text("How many people saw the accident", style: TextStyle(
                        color: Color.fromRGBO(202, 27, 0, 1),
                        fontSize: 14,

                      ),),
                      Expanded(child: Divider(
                        color: Color.fromRGBO(202, 27, 0, 1),
                        indent: 5,
                        endIndent: 0,
                      )),

                    ]),
                const SizedBox(height: 10,),

                TextFormField(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14,
                      height: 1
                  ),
                  decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1.0),
                    ),
                    hintText: 'How many people saw the accident',
                  ),
                ),

                const SizedBox(height: 20,),

                Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(82, 71, 197, 1),
                  child: TextButton(
                      onPressed: () {},
                      child: const Text("Submit", style: TextStyle(color: Colors.white
    ),),),
                )

              ],
            ),
          ),
        ],
    ),),
      )
    );

  }
}
