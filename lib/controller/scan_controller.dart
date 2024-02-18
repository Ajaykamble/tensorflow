import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
   // initTflite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;

  late List<CameraDescription> cameras;

  late CameraImage cameraImage;
  var cameraCount = 0;
  var x, y, w, h = 0.0;
  var label = "";

  var isCameraInitialized = false.obs;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then(
        (value) {
          cameraController.startImageStream((image) {
            cameraCount++;
            if (cameraCount % 10 == 0) {
              cameraCount = 0;
              //objectDetector(image);
            }
            update();
          });
        },
      );
      isCameraInitialized(true);
      update();
    } else {
      debugPrint("permission Denied");
    }
  }

  /* initTflite() async {
    await Tflite.loadModel(model: "assets/model.tflite", labels: "assets/labels.txt", isAsset: true, numThreads: 1, useGpuDelegate: false);
  }

  objectDetector(CameraImage image) async {
    var detector = await Tflite.runModelOnFrame(
      bytesList: image.planes.map((e) {
        return e.bytes;
      }).toList(),
      asynch: true,
      imageHeight: image.height,
      imageMean: 127.5,
      imageStd: 127.5,
      imageWidth: image.width,
      numResults: 1,
      rotation: 90,
      threshold: 0.4,
    );

    if (detector != null && detector.isNotEmpty) {
      var ourDetectedObject = detector.first;

      log("Result is $ourDetectedObject");
      label = ourDetectedObject['label'].toString();
      log("${label}");
      /* h = ourDetectedObject["rect"]["h"];
      w = ourDetectedObject["rect"]["w"];
      x = ourDetectedObject["rect"]["x"];
      y = ourDetectedObject["rect"]["y"];  */

      update();
    }
  } */
}
