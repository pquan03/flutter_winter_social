import 'package:flutter/material.dart';

class SendMessStory extends StatefulWidget {
  const SendMessStory({super.key, required this.controller});
  final TextEditingController controller;

  @override
  State<SendMessStory> createState() => _SendMessStoryState();
}

class _SendMessStoryState extends State<SendMessStory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.only(top: 100),
                  height: 200,
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listIcon.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3, childAspectRatio: 1.5),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            widget.controller.text =
                                widget.controller.text + listIcon[index];
                          },
                          child: Container(
                            color: Colors.transparent,
                            height: 40,
                            width: 40,
                            alignment: Alignment.center,
                            child: Text(
                              listIcon[index],
                              style: TextStyle(fontSize: 40),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.black,
            height: MediaQuery.sizeOf(context).height * 0.1,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.controller,
                    style: TextStyle(color: Colors.white),
                    autofocus: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      hintText: 'Send message',
                      hintStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_outline,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  final List<String> listIcon = [
    "🙂",
    "😀",
    "😄",
    "😆",
    "😅",
    "😂",
  ];
}
