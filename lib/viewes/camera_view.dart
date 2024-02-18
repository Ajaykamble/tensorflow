import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newapp/controller/scan_controller.dart';

class CameraView extends StatelessWidget {
  const CameraView({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: Icon(Icons.leave_bags_at_home))
          ],
        ),
        body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            return controller.isCameraInitialized.value
                ? Stack(
                    children: [
                      Positioned(
                        top: 2,
                        right: 10,
                        child: Container(
                          child: Column(
                            children: [
                              CameraPreview(controller.cameraController),
                            ],
                          ),
                          width: 370,
                          height: 652,
                          decoration: BoxDecoration(border: Border.all(color: Colors.green, width: 4.0), borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 100,
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.all(10),
                                color: Colors.grey,
                                child: Column(
                                  children: [
                                    Text("Label of object: ==> ${controller.label}"),
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ],
                  )
                : Center(child: Text("Loading Preview ...."));
          },
        ),
      ),
    );
  }
}
