import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/layout_screen.dart';


class EditItemProfileScreen extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  const EditItemProfileScreen({super.key, required this.controller, required this.label});

  @override
  State<EditItemProfileScreen> createState() => _EditItemProfileScreenState();
}

class _EditItemProfileScreenState extends State<EditItemProfileScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutScreen(
      title: widget.label,
      onPressed: () {
        if(_controller.text != widget.controller.text) {
          showDialog(context: context,
          builder: (context) {
            return AlertDialog(
              alignment: Alignment.center,
              title: Text('Unsaved changes?', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),),
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
                    widget.controller.text = _controller.text;
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }, 
                  child: Text('Yes', style: TextStyle(color: Colors.blue)),
                ),
              ],
            );
          }
          );
        } else {
          Navigator.pop(context);
        }
      },
      action: [
        IconButton(
          icon: Icon(Icons.done, size: 30, color: Colors.blue,),
          onPressed: () {
            widget.controller.text = _controller.text;
            Navigator.pop(context);
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: widget.label == 'Gender' ? 
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(padding: const EdgeInsets.only(bottom: 16)),
            Text('This won\'t be a part of your public profile.', style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w600, fontSize: 14),),
            const SizedBox(height: 16,),
            Column(
              children: listData.map((e) => 
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _controller.text = e.toString();
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e[0].toUpperCase() + e.substring(1),  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                        Spacer(),
                        Radio(
                          toggleable: false,
                          fillColor: MaterialStateProperty.all(Colors.white),
                          activeColor: Colors.blue,
                          overlayColor: MaterialStateProperty.all(Colors.white),
                          value: e,
                          groupValue: _controller.text,
                          onChanged: (value) {
                            setState(() {
                              _controller.text = value.toString();
                            });
                          }, 
                        )
                      ],
                    ),
                  ),
                )
              ).toList(),
            )
          ],
        )
        :
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.blue, width: 1))
              ),
              child: TextField(
                autofocus: true,
                controller: _controller,
                style: TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            Text(
              'This is not your username or pin. This name will be visible to your Instagram followers.',
              style: TextStyle(
                color: Colors.grey[300],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    )     ;
  }

  List<String> listData = ['Female', 'Male', 'Other'];
}