import 'package:flutter/material.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class PostModal extends StatefulWidget {
  final String postId;
  final String postUserId;
  final Function(String id) deletePost;
  final Function savePost;
  final bool isSaved;
  const PostModal(
      {super.key,
      required this.postId,
      required this.postUserId,
      required this.deletePost,
      required this.savePost,
      required this.isSaved,
      });

  @override
  State<PostModal> createState() => _PostModalState();
}

class _PostModalState extends State<PostModal> {
  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context).auth.user!.sId!;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  widget.savePost();
                  Navigator.pop(context);
                },
                child: widget.isSaved ?
                Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                      color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.white)),
                      ),
                      child: Icon(
                        Icons.bookmark,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'unSave',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                )
                : Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.white)),
                      ),
                      child: Icon(
                        Icons.bookmark_outline,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      'Save',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                          BorderSide(color: Colors.white)),
                    ),
                    child: Icon(
                      Icons.qr_code,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'QR code',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.withOpacity(.3),
          ),
          rowStartItem(Icons.star_outline, 'Add to favorites', () {}, false),
          rowStartItem(Icons.person_add_alt_1_outlined, 'Add to close friends',
              () {}, false),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.withOpacity(.3),
          ),
          rowStartItem(Icons.notifications_none_outlined,
              'Turn on notifications', () {}, false),
          rowStartItem(Icons.link_outlined, 'Copy link', () {}, false),
          rowStartItem(
              Icons.report_gmailerrorred_outlined, 'Report', () {}, true),
          userId == widget.postUserId
              ? rowStartItem(Icons.delete, 'Delete', () {
                  showDialog(context: context, builder: (context) => AlertDialog(
                    title: const Text('Delete Post'),
                    content: const Text('Are you sure you want to delete this post?'),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: const Text('Cancel')),
                      TextButton(onPressed: () async {
                        await widget.deletePost(widget.postId);
                        if(!mounted) return;
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }, child: const Text('Delete')),
                    ],
                  ));
                }, true)
              : Container()
        ],
      ),
    );
  }

  Widget rowStartItem(
      IconData icon, String title, Function()? onTap, bool isImportant) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isImportant ? Colors.red : Colors.white,
              size: 30,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              title,
              style: TextStyle(
                  color: isImportant ? Colors.red : Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
