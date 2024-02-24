import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newapp/res/app_color_scheme.dart';
import 'package:newapp/tensorflow/image_classification.dart';
import 'package:newapp/utils/common_fuctions.dart';
import 'package:newapp/utils/enums.dart';
import 'package:newapp/utils/image_model.dart';
import 'package:newapp/viewes/camera_view.dart';
import 'package:newapp/viewes/profile_screen.dart';
import 'package:newapp/widgets/custom_circular_avatar.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

class DoctorAnimationScreen extends StatefulWidget {
  @override
  State<DoctorAnimationScreen> createState() => _DoctorAnimationScreenState();
}

class _DoctorAnimationScreenState extends State<DoctorAnimationScreen> {
  final ValueNotifier<ImageModel?> _profileBytes = ValueNotifier<ImageModel?>(null);

  var imageClassificationHelper = ImageClassificationHelper();

  @override
  void initState() {
    super.initState();
    imageClassificationHelper.initHelper();
  }

  static const modelPath = 'assets/tensor/model.tflite';

  Future<Uint8List> resizeImage(Uint8List imageData, int width, int height) async {
    ui.Image rawImage = await decodeImageFromList(imageData);

    var data = await rawImage.toByteData();
    return data!.buffer.asUint8List();
  }

  void onAddAttachmentClick() async {
    XFile? attachment = await CommonFunctions.chooseImage(context: context);

    if (attachment != null) {
      String fileName = attachment.name;
      Uint8List bytes = await attachment.readAsBytes();
      _profileBytes.value = ImageModel(fileType: p.extension(fileName).replaceAll(".", ""), byteImage: bytes);

      var image = img.decodeImage(bytes);
      // image = img.copyResize(image, 640, 640);
      image = img.copyResize(image!, width: 640, height: 640);
      log("${image.height}");
      log("my inference");


      var result = await imageClassificationHelper.inferenceImage(image);
      log("${result}");
    }
  }

  @override
  void dispose() {
    imageClassificationHelper?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Animation'),
        actions: [
          InkWell(
              onTap: () {
                // showProfileMenu(context, user);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.red,
                  ),
                  height: 40,
                  width: 40,
                ),
              ))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /* Expanded(
            child: Container(
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: Image.asset(
                "assets/doc.jpg",
                fit: BoxFit.contain,
              ),
            ),
          ), */
          const SizedBox(height: 20),
          // Button at the bottom
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () async {
                      onAddAttachmentClick();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Thick Blood Smear",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
              const Text("OR "),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    onPressed: () async {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => const CameraView()));
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Thin Blood Smear",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showProfileMenu(BuildContext context, User user) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to the profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      email: user.email ?? "",
                      name: user.displayName ?? "",
                      mobileNumber: user.phoneNumber ?? "",
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
              },
            ),
          ],
        );
      },
    );
  }
}
