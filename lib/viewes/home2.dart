import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newapp/utils/common_fuctions.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';


class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  Uint8List? _image;

  open() async {
    XFile? attachment = await CommonFunctions.chooseImage(context: context);
    if (attachment != null) {
      Uint8List imageBytes = await attachment.readAsBytes();
      
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              open();
            },
            icon: Icon(Icons.add),
          ),
          if (_image != null)
            Image.memory(
              _image!,
              height: 200,
              width: 200,
            )
        ],
      ),
    );
  }
}
