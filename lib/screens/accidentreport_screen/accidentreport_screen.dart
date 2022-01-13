import 'dart:io';
import 'dart:math';
import 'package:buzz_ai/models/report_accident/accident_report.dart';
import 'package:buzz_ai/models/report_accident/submit_accident_report.dart';
import 'package:buzz_ai/services/get_location.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
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
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final picker = ImagePicker();
  File? imageFile;
  late TextEditingController carPlateNumber;
  late TextEditingController numberOfPeopleInjured;

  @override
  void initState() {
    carPlateNumber = TextEditingController();
    numberOfPeopleInjured = TextEditingController(text: '1');
    super.initState();
  }

  Future<void> pickImage() async {
    // dynamic picture = await picker.pickImage(source: ImageSource.camera);
    // setState(() {
    //   imageFile = picture;
    // });

    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedImage == null) return;

    final pickedImageFile = File(pickedImage.path);
    setState(() {
      imageFile = pickedImageFile;
    });
  }

  Future<void> uploadAccidentReport() async {
    setState(() {
      _uploading = true;
    });
    final User? user = auth.currentUser;
    final _uid = user?.uid;

    final ref = FirebaseStorage.instance
        .ref(_uid!)
        // .child(_uid)
        .child('accidentImage-${DateTime.now().millisecondsSinceEpoch}.jpg');
    await ref.putFile(imageFile!);
    var url = await ref.getDownloadURL();

    Map locationData = await getLocation();
    Position position = locationData["position"];
    Placemark location = locationData["placemark"];

    AccidentReport accidentReport = AccidentReport(
      createdAt: DateTime.now(),
      imageURL: url,
      carPlateNumber: carPlateNumber.text,
      peopleInjured: int.parse(numberOfPeopleInjured.text),
      coordinates: [position.latitude, position.longitude],
      location: location.toJson(),
    );

    FocusScope.of(context).unfocus();

    String reportID =
        "${Random.secure().nextInt(999).toString()}_${DateTime.now().millisecondsSinceEpoch}";
    await FirebaseFirestore.instance
        .collection('accidentReports')
        .doc(_uid)
        .collection("reports")
        .doc(reportID)
        .set(accidentReport.toJSON());
    setState(() {
      _uploading = false;
    });

    carPlateNumber.text = "";
    numberOfPeopleInjured.text = "0";
    imageFile = null;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: const Text("Accident reported successfuly!"),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK")),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Details Not complete"),
      content: const Text("You Must Upload image and Car Number Plate"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  bool _uploading = false;

  @override
  Widget build(BuildContext context) {
    final validationService = Provider.of<SubmitAccidentReport>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromRGBO(82, 71, 197, 1),
          automaticallyImplyLeading: false,
          title: const Text(
            'Report Accident',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.0,
            ),
          ),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(0.4),
            child: Visibility(
              visible: _uploading,
              child: const LinearProgressIndicator(),
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          reverse: true,
          shrinkWrap: true,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.41,
                      color: const Color.fromRGBO(82, 71, 197, 1),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                  child: Image.asset('assets/img/upload.png')),
                              const Text(
                                "You Need To Upload Your",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                "Report Accident Details",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const Text(
                                "If you saw any accident and need help then you can report accident here",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                height: 5.0,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.41,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 20, 0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 25,
                              ),
                              Row(children: const [
                                Expanded(
                                    child: Divider(
                                  color: Colors.black45,
                                  indent: 0,
                                  endIndent: 5,
                                )),
                                Text(
                                  "Car Number Plate",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                  color: Colors.black45,
                                  indent: 5,
                                  endIndent: 0,
                                )),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14, height: 1),
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                  hintText: 'Car Number Plate',
                                ),
                                controller: carPlateNumber,
                                validator: (value) {
                                  if (value!.isEmpty)
                                    return "Enter Car Plate Number";
                                  if (value.length < 3)
                                    return "Enter the valid car plate number!";
                                },
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(children: const [
                                Expanded(
                                    child: Divider(
                                  color: Colors.black45,
                                  indent: 0,
                                  endIndent: 5,
                                )),
                                Text(
                                  "How many people were injured",
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14,
                                  ),
                                ),
                                Expanded(
                                    child: Divider(
                                  color: Colors.black45,
                                  indent: 5,
                                  endIndent: 0,
                                )),
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                style: const TextStyle(fontSize: 14, height: 1),
                                decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black45, width: 1.0),
                                  ),
                                  hintText: ' How many people are injured',
                                ),
                                controller: numberOfPeopleInjured,
                                validator: (value) {
                                  if (int.parse(value ?? "0") == 0)
                                    return "Injured people must be atleast 1";
                                },
                                onChanged: (dynamic value) {
                                  validationService
                                      .changeNumberOfPeopleInjured(value);
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                width: double.infinity,
                                color: const Color.fromRGBO(82, 71, 197, 1),
                                child: TextButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      if (imageFile == null) {
                                        showAlertDialog(context);
                                        return;
                                      }

                                      if (imageFile!.path.isNotEmpty &&
                                          carPlateNumber.text
                                              .toString()
                                              .trim()
                                              .isNotEmpty) {
                                        await uploadAccidentReport();
                                      } else {
                                        if (imageFile!.path.isEmpty) {
                                          showAlertDialog(context);
                                        } else if (carPlateNumber.text
                                            .toString()
                                            .trim()
                                            .isEmpty) {
                                          showAlertDialog(context);
                                        }
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    child: Container(
                        height: 50,
                        width: 180,
                        decoration: const BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange,
                              offset: Offset(
                                2.0,
                                2.0,
                              ),
                              blurRadius: 5.0,
                              spreadRadius: 1.0,
                            ), //BoxShadow
                            BoxShadow(
                              color: Colors.orange,
                              offset: Offset(0.0, 0.0),
                              blurRadius: 0.0,
                              spreadRadius: 0.0,
                            ), //BoxShadow
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(248, 157, 52, 1),
                        ),
                        child: GestureDetector(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/img/camera.png'),
                              const SizedBox(width: 5),
                              const Text(
                                "Use Camera",
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                          onTap: () async {
                            await pickImage();
                          },
                        )))
              ],
            ),
          ],
        ));
  }
}
