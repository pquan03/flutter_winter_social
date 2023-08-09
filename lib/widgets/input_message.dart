import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_assets_picker/insta_assets_picker.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/providers/theme.dart';
import 'package:insta_node_app/utils/image_picker.dart';
import 'package:insta_node_app/widgets/grid_icon.dart';
import 'package:provider/provider.dart';

class InputMessageWidget extends StatefulWidget {
  final String recipientId;
  final TextEditingController controller;
  final VoidCallback handleCreateMessage;
  const InputMessageWidget(
      {super.key,
      required this.controller,
      required this.recipientId,
      required this.handleCreateMessage});

  @override
  State<InputMessageWidget> createState() => _InputMessageWidgetState();
}

class _InputMessageWidgetState extends State<InputMessageWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }



  Future<void> callRestorablePicker() async {
    final accessToken = Provider.of<AuthProvider>(context, listen: false).auth.accessToken;
    final List<AssetEntity>? result =
        await InstaAssetPicker().restorableAssetsPicker(
      context,
      title: 'Choose image',
      closeOnComplete: true,
      provider: DefaultAssetPickerProvider(maxAssets: 5),
      pickerTheme: InstaAssetPicker.themeData(Theme.of(context).primaryColor).copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue,
            disabledForegroundColor: Colors.red,
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(fontSize: 18)),
  ),
      onCompleted: (cropStream) {},
    );
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
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Container(
              // margin: const EdgeInsets.all(value),
              height: 40,
              width: 40,
              margin: const EdgeInsets.only(left: 5),
              decoration: ShapeDecoration(
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  showModalBottomSheetCustom(
                    context,
                    GridIconWidget(
                      controller: widget.controller,
                    ),
                  );
                },
                icon: Icon(
                  FontAwesomeIcons.faceSmile,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: TextField(
                onChanged: (value) => setState(() {}),
                controller: widget.controller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Message...',
                ),
              ),
            ),
            widget.controller.text != ''
                ? TextButton(
                    onPressed: () {
                      print('hi');
                      widget.handleCreateMessage();
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ))
                : IconButton(
                    onPressed: () {
                      callRestorablePicker();
                    },
                    icon: Icon(
                      FontAwesomeIcons.image,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }
}
