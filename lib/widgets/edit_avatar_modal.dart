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
  Future<void> callRestorablePicker(Auth auth) async {
    final List<AssetEntity>? result =
        await InstaAssetPicker().restorableAssetsPicker(
      context,
      title: 'Change avatar',
      closeOnComplete: true,
      provider: DefaultAssetPickerProvider(maxAssets: 1),
      pickerTheme:
          InstaAssetPicker.themeData(Theme.of(context).colorScheme.secondary)
              .copyWith(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            disabledForegroundColor: Colors.red,
          ),
        ),
        appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontSize: 18)),
      ),
      onCompleted: (cropStream) {},
    );
    if (!mounted) return;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    if (result == null) {
      Navigator.of(context).pop();
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
    if (!mounted) return;
    Navigator.of(context).pop();
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
            ),
            title: Text(
              'Take Photo',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(
              Icons.photo_library_outlined,
              size: 30,
            ),
            title: Text(
              'Choose from Library',
              style: TextStyle(fontSize: 18),
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
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            onTap: () async {
              widget.onUpdateUser({
                ...auth.toJson(),
                'user': {
                  ...auth.user!.toJson(),
                  'avatar':
                      'https://res.cloudinary.com/devatchannel/image/upload/v1602752402/avatar/avatar_cugq40.png',
                }
              });
              if (!mounted) return;
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return Dialog(
                      // The background color
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // The loading indicator
                            CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            // Some text
                            Text('Loading...')
                          ],
                        ),
                      ),
                    );
                  });
              await Future.delayed(const Duration(seconds: 1));
              if (!mounted) return;
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
