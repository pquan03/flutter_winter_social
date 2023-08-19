import 'dart:io';

import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
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

Future<String> imageUpload(dynamic file, bool isUint8List) async {
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'noze-blog');
  var data = await upload(isUint8List ? file : file.readAsBytesSync());
  return data['url'];
}

Future<dynamic> imagePostUpload(dynamic file, bool isUint8List) async {
  CloudinaryContext.cloudinary =
      Cloudinary.fromCloudName(cloudName: 'noze-blog');
  var data = await upload(isUint8List ? file : file.readAsBytesSync());
  return {
    'url': data['url'],
    'public_id': data['public_id'],
  };
}

Future<dynamic> upload(dynamic file) async {
  final base64Img = base64Encode(file);
  final res = await http.post(
      Uri.parse('https://api.cloudinary.com/v1_1/noze-blog/upload'),
      body: {
        'file': 'data:image/png;base64,$base64Img',
        'cloud_name': 'noze-blog',
        'upload_preset': 'wi5uwxua',
      });
  print('res: ${res.body}');
  return jsonDecode(res.body);
}
