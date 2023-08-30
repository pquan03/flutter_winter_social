import 'package:flutter/material.dart';
import 'package:insta_node_app/models/auth.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/user_api.dart';
import 'package:insta_node_app/utils/animate_route.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/add/screens/add_post/media_gallery_post.dart';
import 'package:insta_node_app/views/add/widgets/preview.dart';
import 'package:insta_node_app/views/profile/screens/follow_user.dart';
import 'package:insta_node_app/views/profile/widgets/edit_profile.dart';
import 'package:insta_node_app/views/setting/screens/settings.dart';
import 'package:provider/provider.dart';

class ProfileInfoWidget extends StatefulWidget {
  final ScrollController scrollController;
  const ProfileInfoWidget({super.key, required this.scrollController});

  @override
  State<ProfileInfoWidget> createState() => _ProfileInfoWidgetState();
}

class _ProfileInfoWidgetState extends State<ProfileInfoWidget> {
  void handleUpdateUser(Map<String, dynamic> data) async {
    final res =
        await UserApi().updateUser(data['user']!, data['access_token']!);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setAuth(Auth.fromJson(data));
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).auth.user!;
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(user.username!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(createRoute(MediaGalleryPostScreen()));
              },
              child: Icon(
                Icons.camera_alt_outlined,
              ),
            ),
            const SizedBox(
              width: 15,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SettingsScreen()));
              },
              child: Icon(
                Icons.menu,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(createRoute(
                        PreviewScreen(imagesString: [user.avatar!])));
                  },
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user.avatar!),
                  ),
                ),
                const SizedBox(height: 8),
                Text(user.fullname!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            const SizedBox(width: 30),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        // scroll to center screen
                        widget.scrollController.animateTo(
                            MediaQuery.of(context).size.width / 2,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      child: startColumnItem(user.countPosts!, 'Posts')),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FollowUserScreen(
                                initIndex: 0,
                                username: user.username!,
                                followers: user.followers!,
                                following: user.following!,
                              )));
                    },
                    child: startColumnItem(user.followers!.length, 'Followers'),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => FollowUserScreen(
                                initIndex: 1,
                                username: user.username!,
                                followers: user.followers!,
                                following: user.following!,
                              )));
                    },
                    child: startColumnItem(user.following!.length, 'Following'),
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            user.story!,
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        SizedBox(
          height: 40,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                              user: user,
                              onUpdateUser: handleUpdateUser,
                            )));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('Share profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget startColumnItem(int num, String title) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(num.toString(),
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 8),
          Text(title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }
}
