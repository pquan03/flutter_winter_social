import 'package:flutter/material.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ChooseAccountModalWidget extends StatelessWidget {
  const ChooseAccountModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<AuthProvider>(context).auth.user!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        children: [
          buildAccountTile(currentUser.username!, currentUser.avatar!),
          const Divider(),
          buildAddAccountTile(),
          const Divider(),
          buildSwitchAccountTile(),
        ],
      ),
    );
  }

  Widget buildAccountTile(String username, String avatar) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundImage: NetworkImage(avatar),
      ),
      title: Text(username),
      onTap: () {},
    );
  }

  Widget buildAddAccountTile() {
    return ListTile(
      leading: const Icon(Icons.add),
      title: const Text('Add account'),
      onTap: () {},
    );
  }

  Widget buildSwitchAccountTile() {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Switch account'),
      onTap: () {},
    );
  }
}
