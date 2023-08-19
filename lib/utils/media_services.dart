

import 'package:photo_manager/photo_manager.dart';

class MediaServices  {


  Future loadAlbums(RequestType requestType, int page) async {
    var permission = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];

    if(permission.isAuth == true) {
      List<AssetPathEntity> temp =  await PhotoManager.getAssetPathList(type: requestType, hasAll: false);
      // if album is empty then remove that album from list album
      for(int i = 0; i < temp.length; i++) {
        if((await loadAssets(temp[i], page)).length != 0) {
          albumList.add(temp[i]);
        }
      }
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }



  Future loadAssets(AssetPathEntity selectedAlbum, int page) async {
    List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(start: (page - 1) * 45, end: page * 45);
    return assetList;
  }

  // crop image
  Future cropImage(AssetEntity assetEntity) async {
    return await assetEntity.originFile;
  }
}