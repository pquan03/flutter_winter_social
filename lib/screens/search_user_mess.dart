import 'package:flutter/material.dart';
import 'package:insta_node_app/common_widgets/loading_shimmer.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/screens/message.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:provider/provider.dart';

class SearchUserScreen extends StatefulWidget {
  final Function? handleBack;
  const SearchUserScreen({super.key, required this.handleBack});
  @override
  State<SearchUserScreen> createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoadingShimmer = false;
  List<UserPost> users = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accessToken = Provider.of<AuthProvider>(context).auth.accessToken!;
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => widget.handleBack!(),
              child: const Icon(
                Icons.arrow_back, size: 30,)),
            const SizedBox(width: 16,),
            Expanded(
              child: TextField(
                    onChanged: (value) async {
                      setState(() {
                        users = [];
                      });
                      if (value != '') {
                        setState(() {
                          _isLoadingShimmer = true;
                        });
                        final res = await UserApi()
                            .searchUserWithMessages(value, accessToken);
                        if (res is String) {
                          if (!mounted) return;
                          showSnackBar(context, 'Error', res);
                        } else {
                          setState(() {
                            users = [...res];
                            _isLoadingShimmer = false;
                          });
                        }
                      } else {
                        setState(() {
                          users = [];
                        });
                      }
                    },
                  cursorColor: Colors.green,
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        )
      ),
      body: _isLoadingShimmer
                ? LoadingShimmer(
                    child: ListView(children: <Widget>[
                      ...List.generate(
                        2,
                        (index) => buildTempUser(),
                      ),
                    ]),
                  )
                : ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => MessageScreen(user: users[index], firstListMessages: users[index].messages ?? [],)));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(users[index].avatar!),
                          ),
                          title: Text(
                            users[index].username!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            users[index].fullname!,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    },
                  ),
    );
  }

    Widget buildTempUser() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 0.5,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: 100,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}