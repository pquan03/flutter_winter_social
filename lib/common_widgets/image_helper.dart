

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImageHelper {
  static Widget loadImageAsset(
    String path,{
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        path,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      ),
    );
  }

  static Widget loadImageNetWork(
    String path,{
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        path,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      ),
    );
  }

  static Widget loadImageFile(
    File path,{
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.file(
        path,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      ),
    );
  }

    static Widget loadImageMemory(
    Uint8List path,{
    double? width,
    double? height,
    BoxFit? fit,
    Color? color,
    BorderRadius? borderRadius,
  }) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.memory(
        path,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        color: color,
      ),
    );
  }
}