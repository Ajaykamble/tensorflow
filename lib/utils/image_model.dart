import 'dart:convert';

import 'package:flutter/services.dart';

class ImageModel {
  String? fileType;
  String? base64Image;
  Uint8List? byteImage;

  ImageModel({
    this.fileType,
    this.base64Image,
    this.byteImage,
  }) {
    base64Image = byteImage == null ? null : base64Encode(byteImage!.toList());
  }

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        fileType: json["fileType"],
        base64Image: json["base64Image"],
      );

  Map<String, dynamic> toJson() => {
        "fileType": fileType,
        "base64Image": base64Image,
      };
}
