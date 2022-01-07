import 'dart:io';
import 'package:buzz_ai/models/report_accident/submit_accident_report.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccidentReportScreen extends StatefulWidget {
  static const String iD = '/accidentreport';

  const AccidentReportScreen({Key? key}) : super(key: key);


  @override
  _AccidentReportScreenState createState() => _AccidentReportScreenState();
}

class _AccidentReportScreenState extends State<AccidentReportScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  final picker = ImagePicker();
  late File imageFile;
  dynamic carNumberPlate, peopleInjured;


  Future<void> pickImage() async {
    // dynamic picture = await picker.pickImage(source: ImageSource.camera);
    // setState(() {
    //   imageFile = picture;
    // });

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      imageFile = pickedImageFile;
    });
  }

  Future<void> uploadAccidentReport() async {
    final User? user = auth.currentUser;
    final _uid = user?.uid;

    final ref = FirebaseStorage.instance
        .ref()
        .child(_uid!)
        .child('.jpg');
    await ref.putFile(imageFile);
    var url = await ref.getDownloadURL();

    await FirebaseFirestore.instance
        .collection('users')
        .doc("uploadAccidentReport")
        .set({
      'carNumberPlate': carNumberPlate,
      'peopleInjured': peopleInjured,
      'AccidentImage': url,
      'userId': _uid,
      'createdAt': Timestamp.now(),
    });
    Navigator.canPop(context) ? Navigator.pop(context) : null;
  }


  // final User user = await auth.currentUser!;
  // final userid = user.uid;
  // final referenceDatabase = FirebaseDatabase.instance.ref().child("$userid/");
  // await firebase_storage.FirebaseStorage.instance
  //         .ref().child("$userid/$imageFile").
  //     child(DateTime.now().microsecondsSinceEpoch.toString() + "." + imageFile.path).putFile(imageFile);
  //
  // var imageUrl = referenceDatabase.get().toString();
  //
  // HashMap map = HashMap();
  // map["carNumberplate"] = carNumberPlate;
  // map["peopleInjured"] = peopleInjured;
  // map["imageUrl"] = imageUrl;


  @override
  Widget build(BuildContext context) {
    final validationService = Provider.of<SubmitAccidentReport>(context);
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
              fontSize: 22.0,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,


        body: ListView(
          reverse: true,
          shrinkWrap: true,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [ Column(
                children: [
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.5,
                    color: const Color.fromRGBO(82, 71, 197, 1),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(child: Image.asset('assets/img/upload.png')),
                            const Text("You Need To Upload Your",
                              style: TextStyle(color: Colors.white,),
                              textAlign: TextAlign.center,),
                            const Text("Report Accident Details",
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,),
                            const Text(
                              "If you saw any accident and need help then you can report accident here",
                              style: TextStyle(color: Colors.white,),
                              textAlign: TextAlign.center,)


                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.5,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 30, 20, 0),
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
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.0),
                              ),
                              hintText: 'Car Number Plate',

                            ),
                            onChanged: (dynamic value) {
                              carNumberPlate =
                                  validationService.changeCarNumberPlate(value);
                            },
                          ),

                          const SizedBox(height: 5,),

                          Row(
                              children: const [
                                Expanded(child: Divider(
                                  color: Colors.black,
                                  indent: 0,
                                  endIndent: 5,

                                )),
                                Text("How many people were injured",
                                  style: TextStyle(
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
                            keyboardType: TextInputType.number,
                            style: const TextStyle(
                                fontSize: 14,
                                height: 1
                            ),
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.black, width: 1.0),
                              ),
                              hintText: ' How many people are injured',
                            ),
                            onChanged: (dynamic value) {
                              peopleInjured =
                                  validationService.changeNumberOfPeopleInjured(
                                      value);
                            },
                          ),

                          const SizedBox(height: 20,),

                          Container(
                            width: double.infinity,
                            color: const Color.fromRGBO(82, 71, 197, 1),
                            child: TextButton(
                              onPressed: () {
                                uploadAccidentReport();
                              },
                              child: const Text(
                                "Submit", style: TextStyle(color: Colors.white
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
                          borderRadius: const BorderRadius.all(
                              Radius.circular(20)),
                          color: const Color.fromRGBO(248, 157, 52, 1),

                        ),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/img/camera.png'),
                              const SizedBox(width: 5),
                              const Text(
                                "Use Camera", style: TextStyle(color: Colors
                                  .white),)
                            ],

                          ),
                          onTap: () {
                            pickImage();
                          },
                        )
                    )
                )
              ],),
          ],
        )
    );
  }
}
