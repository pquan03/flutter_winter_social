import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/post.dart';
import 'package:insta_node_app/views/post/screens/explore_list_post.dart';

class ListPostProfileWiget extends StatelessWidget {
  final bool isLoading;
  final List<Post> posts;
  final bool isLoadMore;
  const ListPostProfileWiget(
      {super.key,
      required this.isLoadMore,
      required this.isLoading,
      required this.posts});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            ))
          : posts.isEmpty
              ? Center(
                  child: Text(
                    'No Post',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 2,
                    children: [
                      ...[...posts, {}].asMap().entries.map((e) {
                        if (e.key == posts.length) {
                          return StaggeredGridTile.count(
                              crossAxisCellCount: 3,
                              mainAxisCellCount: 1,
                              child: Opacity(
                                opacity: isLoadMore ? 1 : 0,
                                child: Center(
                                    child: CircularProgressIndicator(
                                  color: Colors.blue,
                                )),
                              ));
                        }
                        return StaggeredGridTile.count(
                          crossAxisCellCount: 1,
                          mainAxisCellCount: 1,
                          child: GestureDetector(
                              onTap: () {
                                final newListPost = [...posts];
                                final tempPost = newListPost[e.key];
                                newListPost.removeAt(e.key);
                                newListPost.insert(0, tempPost);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => ExploreListPostScreen(
                                          posts: newListPost,
                                          title: 'Posts',
                                        )));
                              },
                              child: ImageHelper.loadImageNetWork(
                                posts[e.key].images!.first,
                                fit: BoxFit.cover,
                              )),
                        );
                      }).toList()
                    ],
                  ),
                );
    });
  }
}
