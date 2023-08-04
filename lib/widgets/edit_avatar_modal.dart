import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/utils/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';

class EditAvatarModal extends StatefulWidget {
  final String avatar;
  final Function onUpdateUser;
  const EditAvatarModal(
      {super.key, required this.avatar, required this.onUpdateUser});

  @override
  State<EditAvatarModal> createState() => _EditAvatarModalState();
}

class _EditAvatarModalState extends State<EditAvatarModal> {
  bool _isLoading = false;
  final _instaAssetsPicker = InstaAssetPicker();
  final _provider = DefaultAssetPickerProvider(maxAssets: 1);
  late final ThemeData _pickerTheme =
      InstaAssetPicker.themeData(Theme.of(context).primaryColor).copyWith(
    appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18)),
  );
  Future<void> callRestorablePicker(Auth auth) async {
    setState(() {
      _isLoading = true;
    });
    final List<AssetEntity>? result =
        await _instaAssetsPicker.restorableAssetsPicker(
      context,
      title: 'Change avatar',
      closeOnComplete: true,
      provider: _provider,
      pickerTheme: _pickerTheme,
      onCompleted: (cropStream) {},
    );
    if (result == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    final photoUrl = await imageUpload(await result.first.file);
    widget.onUpdateUser({
      ...auth.toJson(),
      'user': {
        ...auth.user!.toJson(),
        'avatar': photoUrl,
      }
    });
    setState(() {
      _isLoading = false;
    });
    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<AuthProvider>(context).auth;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: ListView(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(auth.user!.avatar!),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.5),
          ),
          ListTile(
            leading: Icon(
              Icons.camera_alt_outlined,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              'Take Photo',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library_outlined,
              size: 30,
              color: Colors.white,
            ),
            title: Text(
              'Choose from Library',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            onTap: () => callRestorablePicker(auth),
          ),
          ListTile(
            leading: Icon(
              FontAwesomeIcons.trash,
              size: 30,
              color: Colors.red,
            ),
            title: Text(
              'Remove current picture',
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            onTap: () {
              widget.onUpdateUser({
                ...auth.toJson(),
                'user': {
                  ...auth.user!.toJson(),
                  'avatar':
                      'https://res.cloudinary.com/devatchannel/image/upload/v1602752402/avatar/avatar_cugq40.png',
                }
              });
              if (!mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
