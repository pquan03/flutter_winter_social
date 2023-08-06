import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_node_app/common_widgets/modal_bottom_sheet.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/widgets/grid_icon.dart';
import 'package:provider/provider.dart';

class InputMessageWidget extends StatefulWidget {
  final String recipientId;
  final TextEditingController controller;
  const InputMessageWidget({super.key, required this.controller, required this.recipientId});

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


  @override
  Widget build(BuildContext context) {
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return Container(
        height: 50,
        decoration: ShapeDecoration(
          color: Colors.grey.withOpacity(0.3),
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
                color: Colors.orange.withOpacity(.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: IconButton(
                onPressed: () {
                  showModalBottomSheetCustom(context, GridIconWidget(controller: widget.controller,),);
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Message...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
              ),
            ),
            widget.controller.text != ''
                ? TextButton(
                    onPressed: () {
                      // context.read<MessageBloc>().add(CreateMessageEvent(data: {
                      //   'text': widget.controller.text,
                      //   'media': const [],
                      //   'recipient' : widget.recipientId,
                      //   'call' : null,
                      // }, token: accessToken));
                      // widget.controller.text = '';
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ))
                : IconButton(
                    onPressed: () {},
                    icon: Icon(
                      FontAwesomeIcons.image,
                      color: Colors.white,
                    ),
                  ),
            const SizedBox(
              width: 10,
            ),
          ],
        ));
  }
}
