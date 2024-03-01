import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:io';
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
import 'package:image_picker/image_picker.dart';

class DoctorAnimationScreen extends StatefulWidget {
  @override
  State<DoctorAnimationScreen> createState() => _DoctorAnimationScreenState();
}

class _DoctorAnimationScreenState extends State<DoctorAnimationScreen> {
  final ValueNotifier<ImageModel?> _profileBytes = ValueNotifier<ImageModel?>(null);
  XFile? image1;
  final ImagePicker picker = ImagePicker();
  var imageClassificationHelper = ImageClassificationHelper();

  @override
  void initState() {
    super.initState();
    _loadLabels();
    _loadModel();
    //imageClassificationHelper.initHelper();
  }

  static const modelPath = 'assets/tensor/yolov7-tiny.tflite';
  static const labelsPath = 'assets/tensor/labels.txt';

  Future<Uint8List> resizeImage(Uint8List imageData, int width, int height) async {
    ui.Image rawImage = await decodeImageFromList(imageData);

    var data = await rawImage.toByteData();
    return data!.buffer.asUint8List();
  }

  void onAddAttachmentClick() async {
    ImageSource media = ImageSource.gallery;
    // XFile? attachment = await CommonFunctions.chooseImage(context: context);
    var attachment = await picker.pickImage(source: media);
    if (attachment != null) {
      String fileName = attachment.name;
      Uint8List bytes = await attachment.readAsBytes();
      _profileBytes.value = ImageModel(fileType: p.extension(fileName).replaceAll(".", ""), byteImage: bytes);

      var image = img.decodeImage(bytes);
      // image = img.copyResize(image, 640, 640);
      image = img.copyResize(image!, width: 640, height: 640);
      log("${image.height}");
      log("my inference");
      setState(() {
        image1 = attachment;
      });
      var result = await imageClassificationHelper.inferenceImage(image);
      log("onAttached Result: ${result.last}");
      await imageClassificationHelper.close();

      // draw on image
    }
  }

  late Tensor inputTensor;
  late Tensor outputTensor;
  late final Interpreter interpreter;
  late final List<String> labels;
  Uint8List? outputImage;

  Future<void> _loadModel() async {
    final options = InterpreterOptions();

    // Use XNNPACK Delegate
    /* if (Platform.isAndroid) {
      options.addDelegate(XNNPackDelegate());
    } */

    // Use GPU Delegate
    // doesn't work on emulator
    if (Platform.isAndroid) {
      options.addDelegate(GpuDelegateV2());
    }

    // Use Metal Delegate
    if (Platform.isIOS) {
      options.addDelegate(GpuDelegate());
    }

    // Load model from assets
    interpreter = await Interpreter.fromAsset(modelPath);

    // Get tensor input shape [1, 224, 224, 3] [1, 3, 640, 640]

    log("input length ${interpreter.getInputTensors().length}");

    inputTensor = interpreter.getInputTensors().last; // Input shape
    log("input ${inputTensor}");
    // Get tensor output shape [1, 1001] [1, 7]
    log("interpreter.getOutputTensors: ${interpreter.getOutputTensors()}");
    outputTensor = interpreter.getOutputTensors().last;
    log("output: ${outputTensor.shape}");
    log('Interpreter loaded successfully');
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
    //log("labels ${labels}");
  }

  onattachemnt() async {
    ImageSource media = ImageSource.gallery;
    // XFile? attachment = await CommonFunctions.chooseImage(context: context);
    var attachment = await picker.pickImage(source: media);
    if (attachment != null) {
      String fileName = attachment.name;
      Uint8List bytes = await attachment.readAsBytes();
      _profileBytes.value = ImageModel(fileType: p.extension(fileName).replaceAll(".", ""), byteImage: bytes);

      var image = img.decodeImage(bytes);
      // image = img.copyResize(image, 640, 640);
      image = img.copyResize(image!, width: 640, height: 640);
      log("${image.height}");
      log("my inference");
      setState(() {
        image1 = attachment;
      });
      var imageInput = img.copyResize(image, width: inputTensor.shape[2], height: inputTensor.shape[3], maintainAspect: true);
      final imageMatrix = List.generate(
        3,
        (c) => List.generate(
          imageInput.height,
          (y) => List.generate(
            imageInput.width,
            (x) {
              final pixel = imageInput.getPixel(x, y);
              return pixel[c] / 255;
            },
          ),
        ),
      );

      log("${imageMatrix.length}");
      final input = [imageMatrix];

      // log("input image values: ${input[0][0].sublist(0, 10)}");
      log("GOR INPUT");
      log("isolateModel.outputShape: ${outputTensor}");
      List<List<double>> output = List.generate(100, (index) {
        return List<double>.filled(7, 0.0);
      });



      // // Run inference
      log("Before Result");
      interpreter.run(input, output);
      log("After Result");
      // Get first output tensor
      final result = output;
      int zeroCount = 0;
      int oneCount = 0;
      for (var point in result) {

        int x1 = point[1].toInt();
        int y1 = point[2].toInt();
        int x2 = point[3].toInt();
        int y2 = point[4].toInt();

        int colorValue = point[5].toInt();

        if (colorValue == 0) {
          zeroCount += 1;
        } else {
          oneCount += 1;
        }

        String score = point.last.toStringAsFixed(2);

        img.drawRect(
          imageInput,
          x1: x1,
          y1: y1,
          x2: x2,
          y2: y2,
          color: colorValue == 0 ? img.ColorRgb8(0, 255, 0) : img.ColorRgb8(255, 0, 0),
          thickness: 3,
        );

        img.drawString(
          imageInput,
          '${score}',
          font: img.arial24,
          x: x1 + 1,
          y: y1 + 1,
          color: img.ColorRgb8(0, 0, 0),
        );
      }
      Uint8List finalBytes = img.encodeJpg(imageInput);
      setState(() {
        outputImage = finalBytes;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Normal : ${zeroCount} , Infected ${oneCount}")));
    }
  }

  @override
  void dispose() {
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
      body: SingleChildScrollView(
        child: Column(
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
                image1 != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            //to show image, you type like this.
                            File(image1!.path),
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                          ),
                        ),
                      )
                    : const Text(
                        "No Image",
                        style: TextStyle(fontSize: 20),
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
                      onPressed: onattachemnt,
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
                if (outputImage != null)
                  Image.memory(
                    outputImage!,
                    height: 300,
                    width: double.infinity,
                  ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ],
        ),
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
