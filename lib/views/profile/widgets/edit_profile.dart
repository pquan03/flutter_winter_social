import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/models/user.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/views/profile/widgets/edit_item_profile.dart';
import 'package:insta_node_app/views/profile/widgets/edit_avatar_modal.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Function onUpdateUser;
  const EditProfileScreen(
      {super.key, required this.user, required this.onUpdateUser});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _storyController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;
  late TextEditingController _genderController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullname);
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _mobileController = TextEditingController(text: widget.user.mobile);
    _storyController = TextEditingController(text: widget.user.story);
    _websiteController = TextEditingController(text: widget.user.website);
    _genderController = TextEditingController(
        text: widget.user.gender![0].toUpperCase() +
            widget.user.gender!.substring(1));
    _addressController = TextEditingController(text: widget.user.address);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _storyController.dispose();
    _websiteController.dispose();
    _addressController.dispose();
    _genderController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Auth auth = Provider.of<AuthProvider>(context).auth;
    return LayoutScreen(
      title: 'Edit profile',
      onPressed: () {
        var newAuth = {
          ...auth.toJson(),
          'user': {
            ...auth.user!.toJson(),
            'fullname': _nameController.text,
            'username': _usernameController.text,
            'email': _emailController.text,
            'mobile': _mobileController.text,
            'story': _storyController.text,
            'website': _websiteController.text,
            'gender': _genderController.text.toLowerCase(),
            'address': _addressController.text,
          }
        };
        if(auth.user.toString() != User.fromJson(newAuth['user']).toString()) {
          showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              alignment: Alignment.center,
              title: Text('Unsaved changes?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              content: Text('You have unsaved changes. Are you sure you want to cancel?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, 
                  child: Text('No', style: TextStyle(color: Colors.black)),
                ),
                TextButton(
                  onPressed: () {
                    widget.onUpdateUser(newAuth);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }, 
                  child: Text('Yes', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          });
        } else {
          Navigator.pop(context);
        }
      },
      action: [
        _isLoading
            ? Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.blue,
                )),
              )
            : IconButton(
                icon: Icon(
                  Icons.done,
                  size: 30,
                  color: Colors.blue,
                ),
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  widget.onUpdateUser({
                    ...auth.toJson(),
                    'user': {
                      ...auth.user!.toJson(),
                      'fullname': _nameController.text,
                      'username': _usernameController.text,
                      'email': _emailController.text,
                      'mobile': _mobileController.text,
                      'story': _storyController.text,
                      'website': _websiteController.text,
                      'gender': _genderController.text,
                      'address': _addressController.text,
                    }
                  });
                  // Delay 1s to show loading
                  await Future.delayed(Duration(seconds: 1));
                  setState(() {
                    _isLoading = false;
                  });
                  if (!mounted) return;
                  Navigator.pop(context);
                },
              ),
      ],
      child: Padding(
        padding: EdgeInsets.only(
            top: 16,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheetCustom(
                          context,
                          EditAvatarModal(
                            avatar: widget.user.avatar!,
                            onUpdateUser: widget.onUpdateUser,
                          ));
                    },
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(widget.user.avatar!),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                      onTap: () {
                        showModalBottomSheetCustom(
                            context,
                            EditAvatarModal(
                                avatar: widget.user.avatar!,
                                onUpdateUser: widget.onUpdateUser));
                      },
                      child: Text(
                        'Edit picture or avatar',
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            buildTextFormField(_nameController, 'Name'),
            buildTextFormField(_usernameController, 'Username'),
            buildTextFormField(_emailController, 'Email'),
            buildTextFormField(_mobileController, 'Mobile'),
            buildTextFormField(_addressController, 'Address'),
            buildTextFormField(_websiteController, 'Add link'),
            buildTextFormField(_genderController, 'Gender'),
            buildTextFormField(_storyController, 'Story'),
            Padding(padding: const EdgeInsets.only(bottom: 16))
          ],
        ),
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String label) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => EditItemProfileScreen(
                  controller: controller,
                  label: label,
                )));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: controller.text == '' ? 16 : 14,
                  fontWeight: FontWeight.w600),
            ),
            controller.text == ''
                ? Container()
                : TextField(
                    readOnly: true,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => EditItemProfileScreen(
                                controller: controller,
                                label: label,
                              )));
                    },
                    controller: controller,
                    style: TextStyle(
                        fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      suffix: label == 'Gender'
                          ? Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Icon(
                                FontAwesomeIcons.arrowRight,
                                color: Colors.white,
                              ),
                            )
                          : null,
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
