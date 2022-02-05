import 'dart:developer';
import 'dart:io';
import 'package:buzz_ai/controllers/authentication/authentication_controller.dart';
import 'package:buzz_ai/controllers/profile/basic_detail/basic_detail_controller.dart';
import 'package:buzz_ai/controllers/profile/image_pick/image_pick_controller.dart';
import 'package:buzz_ai/controllers/profile/user_profile/user_profile_controller.dart';
import 'package:buzz_ai/services/config.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class ImagePick extends StatelessWidget {
  ImagePick({
    Key? key,
    this.isFromSignUp = false,
  }) : super(key: key);

  final bool isFromSignUp;
  bool _imageFailedToLoad = false;

  @override
  Widget build(BuildContext context) {
    return Consumer2(
      builder: (BuildContext context, ImagePickController value,
          UserProfileController controller, Widget? child) {
        return GestureDetector(
          onTap: controller.formEnabled || isFromSignUp
              ? () async {
                  String? path = await showDialog<String?>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            "Choose option",
                            style: TextStyle(color: defaultColor),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Divider(height: 1, color: defaultColor),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ListTile(
                                  onTap: () async {
                                    await value.openGallery(context);
                                  },
                                  title: const Text("Gallery"),
                                  leading: const Icon(
                                    Icons.account_box,
                                    color: defaultColor,
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: defaultColor,
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: ListTile(
                                  onTap: () async {
                                    await value.openCamera(context);
                                  },
                                  title: const Text("Camera"),
                                  leading: const Icon(
                                    Icons.camera,
                                    color: defaultColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                  if (path != null) {
                    String uid = Provider.of<AuthenticationController>(context,
                            listen: false)
                        .auth
                        .currentUser!
                        .uid;

                    try {
                      File profileImage = File(path);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(const SnackBar(content: Text("Upload started!")));
                          
                      TaskSnapshot uploadTask = await FirebaseStorage.instance
                          .ref(uid)
                          .child("profile")
                          .child(path.split("/").last)
                          .putFile(profileImage);

                      Provider.of<BasicDetailController>(context, listen: false)
                          .setImagePath(await uploadTask.ref.getDownloadURL());
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Error: $e")));
                    }
                  }
                }
              : null,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Consumer2<BasicDetailController, UserProfileController>(
                  builder: (BuildContext context, basicDetailController,
                      userProfileController, Widget? child) {
                    var bgImage = AssetImage(
                        "assets/img/${userProfileController.gender.toString().split(".").last}_profile.png");
                    ImageProvider<Object>? fgImage;

                    try {
                      if (!_imageFailedToLoad) {
                        fgImage = NetworkImage(
                            basicDetailController.basicDetail.imageURL!);
                      }
                    } catch (e) {}

                    return CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,
                      backgroundImage: bgImage,
                      foregroundImage: fgImage,
                    );
                  },
                ),
                const Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF7C62FF),
                    child: Icon(
                      Icons.local_see_outlined,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
