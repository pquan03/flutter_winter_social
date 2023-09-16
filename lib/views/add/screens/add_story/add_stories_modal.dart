import 'package:flutter/material.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AddStoriesModalWidget extends StatefulWidget {
  final Function handleCreateStories;
  final bool isLoading;
  const AddStoriesModalWidget(
      {super.key, required this.handleCreateStories, required this.isLoading});

  @override
  State<AddStoriesModalWidget> createState() => _AddStoriesModalWidgetState();
}

class _AddStoriesModalWidgetState extends State<AddStoriesModalWidget> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return SafeArea(
      child: Wrap(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(user.avatar!),
            ),
            title: const Text(
              'Add to your story',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(''),
            trailing: Radio(
              value: 1,
              groupValue: 1,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            leading: Container(
              alignment: Alignment.center,
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Icon(Icons.send),
            ),
            title: const Text('Message'),
            subtitle: const Text(''),
            trailing: Radio(
              value: 2,
              groupValue: 1,
              onChanged: (value) {},
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () => {widget.handleCreateStories()},
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue),
              child: widget.isLoading
                  ? Center(
                      child: const CircularProgressIndicator(
                      color: Colors.green,
                    ))
                  : Text(
                      'Share',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
