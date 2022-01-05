import 'dart:io';
import 'package:flutter/material.dart';
import 'package:buzz_ai/screens/profile_screen/widgets/image_pick.dart';
import 'package:buzz_ai/models/profile/image_pick/image_pick_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart';

class AccidentReportScreen extends StatefulWidget {
  static const String iD = '/accidentreport';

  const AccidentReportScreen({Key? key}) : super(key: key);

  @override
  _AccidentReportScreenState createState() => _AccidentReportScreenState();
}

class _AccidentReportScreenState extends State<AccidentReportScreen> {
  File?image;
  final ImagePicker imagePicker = ImagePicker();


  Future  uploadImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);
    this.image = imageTemporary;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromRGBO(82, 71, 197, 1),
        title: const Text(
          'Report Accident',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,


      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [ Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: const Color.fromRGBO(82, 71, 197, 1),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(child: Image.asset('assets/img/upload.png')),
                          const Text("You Need To Upload Your", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,),
                          const Text("Report Accident Details", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center, ),
                          const Text("Lorem Ipsum is simply dummy text of the printing and typesetting world", style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,)



                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 30, 20, 10),
                    child: Column(
                      children: [
                        const SizedBox(height: 5,),

                        Row(
                            children: const [
                              Expanded(child: Divider(
                                color: Colors.black,
                                indent: 0,
                                endIndent: 5,

                              )),
                              Text("Car Number Plate", style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),),
                              Expanded(child: Divider(
                                color: Colors.black,
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
                                color: Colors.black,
                                indent: 0,
                                endIndent: 5,

                              )),
                              Text("How many people saw the accident", style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,

                              ),),
                              Expanded(child: Divider(
                                color: Colors.black,
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
                ),
              ],),

            Positioned(
                child: Container(
                  height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                        border: Border.all(
                        ),
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: const Color.fromRGBO(255, 200, 20, 1),

                    ),
                    child: GestureDetector(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/img/camera.png'),
                          const SizedBox(width: 5),
                          const Text("Use Camera", style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    )
                )
            )
          ],)
      )
    );

  }
}
