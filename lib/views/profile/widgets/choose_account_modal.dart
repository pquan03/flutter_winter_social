import 'package:flutter/material.dart';

class ChooseAccountModalWidget extends StatelessWidget {
  const ChooseAccountModalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        children: [
          buildAccountTile(),
          const Divider(),
          buildAddAccountTile(),
          const Divider(),
          buildSwitchAccountTile(),
        ],
      ),
    );
  }

  Widget buildAccountTile() {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text('hiimwinter03'),
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