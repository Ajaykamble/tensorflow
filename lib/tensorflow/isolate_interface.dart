/*
 * Copyright 2023 The TensorFlow Authors. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *             http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as image_lib;
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class IsolateInference {
  static const String _debugName = "TFLITE_INFERENCE";
  final ReceivePort _receivePort = ReceivePort();
  late Isolate _isolate;
  late SendPort _sendPort;

  SendPort get sendPort => _sendPort;

  Future<void> start() async {
    _isolate = await Isolate.spawn<SendPort>(entryPoint, _receivePort.sendPort, debugName: _debugName);
    _sendPort = await _receivePort.first;
  }

  Future<void> close() async {
    _isolate.kill();
    _receivePort.close();
  }

  static _write(String text) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
  }

  static void entryPoint(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    await for (final InferenceModel isolateModel in port) {
      image_lib.Image? img;
      img = isolateModel.image;
      log("my isolate model: ${isolateModel.inputShape}");
      log("my isolate 2 model: ${isolateModel.inputShape[2]}");
      log("my isolate 3 model: ${isolateModel.inputShape[3]}");
      log("my isolate 0 model: ${isolateModel.inputShape[0]}");
      log("my input image size: $img");

      // resize original image to match model shape.
      image_lib.Image imageInput = image_lib.copyResize(img!, width: isolateModel.inputShape[2], height: isolateModel.inputShape[3], maintainAspect: true);

      log("my input image size after: $img");

      log("${imageInput.height}");
      log("start inference");
      // log("Stop inference");

      // final imageMatrix = List.generate(
      //   imageInput.height,
      //   (y) => List.generate(
      //     imageInput.width,
      //     (x) {
      //       final pixel = imageInput.getPixel(x, y);
      //       return [pixel.r, pixel.g, pixel.b];
      //     },
      //   ),
      // );

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

      log("${imageMatrix.length}");

      // Set tensor input [1, 224, 224, 3]
      final input = [imageMatrix];
      log("input image: ${input.length}, ${input[0].length}, ${input[0][0].length}, ${input[0][0][0].length}");
      log("input image values: ${input[0][0][0].sublist(0, 10)}");
      // log("input image values: ${input[0][0].sublist(0, 10)}");
      log("GOR INPUT");
      log("isolateModel.outputShape: ${isolateModel.outputShape}");
      // Set tensor output [1, 1001]
      // final output = [List<int>.filled(isolateModel.outputShape[1], 0)];
      // final List<List<double>> output = [[0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]];

      List<List<double>> output = List.generate(100, (index) {
        return List<double>.filled(7, 0.0);
      });

      // log("output: ${output}");
      // List<List<int>> output = List.generate(
      //     100, (_) => List<int>.filled(7, 0)
      // );

      // // Run inference
      Interpreter interpreter = Interpreter.fromAddress(isolateModel.interpreterAddress);
      log("Before Result");
      interpreter.run(input, output);
      log("After Result");
      // Get first output tensor
      final result = output;

      log('Processing outputs...');
      // Location
      final locationsRaw = output;
      final locations = locationsRaw.map((list) {
        return list.map((value) => (value * 300).toInt()).toList();
      }).toList();
      log('Locations: $locations');

      // log("Result: ${result}");
      // int maxScore = result.reduce((a, b) => a + b);
      // // Set classification map {label: points}
      // var classification = <String, double>{};
      // for (var i = 0; i < result.length; i++) {
      //   if (result[i] != 0) {
      //     // Set label: points
      //     classification[isolateModel.labels[i]] = result[i].toDouble() / maxScore.toDouble();
      //   }
      // }
      isolateModel.responsePort.send(result);
    }
  }
}

class InferenceModel {
  CameraImage? cameraImage;
  image_lib.Image? image;
  int interpreterAddress;
  List<String> labels;
  List<int> inputShape;
  List<int> outputShape;
  late SendPort responsePort;

  InferenceModel(this.cameraImage, this.image, this.interpreterAddress, this.labels, this.inputShape, this.outputShape);

  // check if it is camera frame or still image
  bool isCameraFrame() {
    return cameraImage != null;
  }
}
