import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

Future<dynamic> pickImage(ImageSource source) async {
  try {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) return;
    final imageTemporary = File(image.path);
    return imageTemporary;
  } on PlatformException catch (e) {
    print('pickImage error: $e');
  }
}

Future<dynamic> imageUpload(dynamic file, bool isUint8List) async {
  try {
    var data = await upload(isUint8List ? file : file.readAsBytesSync());
    return data['url'];
  } catch (err) {
    debugPrint(err.toString());
  }
}


Future<dynamic> upload(dynamic file) async {
  final base64Img = base64Encode(file);
  final res = await http.post(
      Uri.parse('https://api.cloudinary.com/v1_1/winter-fl/upload'),
      body: {
        'file': 'data:image/png;base64,$base64Img',
        'cloud_name': 'winter-fl',
        'upload_preset': 'wrv6tdbw',
      });
  print('res: ${res.body}');
  return jsonDecode(res.body);
}
