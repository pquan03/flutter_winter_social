import 'package:flutter/material.dart';

class GridIconWidget extends StatefulWidget {
  final TextEditingController controller;
  const GridIconWidget({super.key, required this.controller});

  @override
  State<GridIconWidget> createState() => _GridIconWidgetState();
}

class _GridIconWidgetState extends State<GridIconWidget> {
  final List<String> listIcon = [
    "🙂",
    "😀",
    "😄",
    "😆",
    "😅",
    "😂",
    "🤣",
    "😊",
    "😌",
    "😉",
    "😏",
    "😍",
    "😘",
    "😗",
    "😙",
    "😚",
    "🤗",
    "😳",
    "🙃",
    "😇",
    "😈",
    "😛",
    "😝",
    "😜",
    '😋',
    '🤤',
    "🤓",
    "😎",
    '🤑',
    "😠",
    "😡",
    "💩",
    "🎃",
    "👿",
    "👍",
    "👎",
    "🤞",
    "👩",
    "💂",
    "👳",
    "👊",
    "✊",
    "🙌",
    "🖖",
    "👂",
    "👃",
    "👁️️",
    "🎖️️",
    "🏆️",
    "🎧️",
    "🥈️",
    "🥇️",
    "🏅"
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.6,
      child: Column(
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: widget.controller.text != ''
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                height: 50,
                decoration: ShapeDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: TextField(
                  readOnly: true,
                  onChanged: (value) => setState(() {}),
                  controller: widget.controller,
                  style: TextStyle(color: Colors.white, fontSize: 30),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(left: 10),
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.white),
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.controller.text = '';
                        });
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: ShapeDecoration(
                          color: Colors.orange.withOpacity(.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        margin: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            secondChild: Container(),
          ),
          Expanded(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                crossAxisCount: 6,
              ),
              children: listIcon
                  .map((e) => GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.controller.text += e;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(e, style: TextStyle(fontSize: 40)),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
