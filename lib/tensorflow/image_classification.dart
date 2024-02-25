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

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:newapp/tensorflow/isolate_interface.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ImageClassificationHelper {
  // // //maleria
  static const modelPath = 'assets/tensor/yolov7-tiny.tflite';
  static const labelsPath = 'assets/tensor/labels.txt';
  // // other
  // static const modelPath = 'assets/models/mobilenet_quant.tflite';
  // static const labelsPath = 'assets/models/labels.txt';

  late final Interpreter interpreter;
  late final List<String> labels;
  late final IsolateInference isolateInference;
  late Tensor inputTensor;
  late Tensor outputTensor;

  // Load model
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

    inputTensor = interpreter.getInputTensors().last;   // Input shape
    log("input ${inputTensor}");
    // Get tensor output shape [1, 1001] [1, 7]
    log("interpreter.getOutputTensors: ${interpreter.getOutputTensors()}");
    outputTensor = interpreter.getOutputTensors().last;
    log("output: ${outputTensor}");
    log('Interpreter loaded successfully');
  }

  // Load labels from assets
  Future<void> _loadLabels() async {
    final labelTxt = await rootBundle.loadString(labelsPath);
    labels = labelTxt.split('\n');
    //log("labels ${labels}");
  }

  Future<void> initHelper() async {
    _loadLabels();
    _loadModel();
    isolateInference = IsolateInference();
    await isolateInference.start();
  }

  Future<List<List<double>>> _inference(InferenceModel inferenceModel) async {
    ReceivePort responsePort = ReceivePort();
    isolateInference.sendPort.send(inferenceModel..responsePort = responsePort.sendPort);
    // get inference result.
    var results = await responsePort.first;
    log("result in _inference: ${results.last}");
    return results;
  }

  // inference camera frame
  Future<List<List<double>>> inferenceCameraFrame(CameraImage cameraImage) async {
    var isolateModel = InferenceModel(cameraImage, null, interpreter.address, labels, inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  // inference still image
  Future<List<List<double>>> inferenceImage(Image image) async {
    var isolateModel = InferenceModel(null, image, interpreter.address, labels, inputTensor.shape, outputTensor.shape);
    return _inference(isolateModel);
  }

  Future<void> close() async {
    isolateInference.close();
  }
}
