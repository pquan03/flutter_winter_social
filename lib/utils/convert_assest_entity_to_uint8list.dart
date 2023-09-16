

import 'package:flutter/services.dart';
import 'package:photo_manager/photo_manager.dart';

Future<Uint8List> convertAssetEntityToUint8List(AssetEntity assetEntity)  async{
  final file = await assetEntity.originFile;
  final bytes = await file!.readAsBytes();
  return bytes;
}