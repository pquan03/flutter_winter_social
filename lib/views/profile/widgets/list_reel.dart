import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:insta_node_app/common_widgets/image_helper.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/views/reel/screens/explore_list_reel.dart';

class ListReelProfileWidget extends StatelessWidget {
  final bool isLoading;
  final List<Reel> reels;
  final bool isLoadMore;
  const ListReelProfileWidget({super.key, required this.isLoadMore, required this.isLoading, required this.reels});

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
              return isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ))
                  : reels.isEmpty
                      ? Center(
                          child: Text(
                            'No Reels',
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
                              ...[...reels, {}].asMap().entries.map((e) {
                                if (e.key == reels.length) {
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
                                  mainAxisCellCount: 2,
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    ExploreListReelScreen(
                                                        initpage: e.key,
                                                        reels: reels,)));
                                      },
                                      child: ImageHelper.loadImageNetWork(
                                          reels[e.key].backgroundUrl!,
                                          fit: BoxFit.cover)),
                                );
                              }).toList()
                            ],
                          ),
                        );
            });
  }
}
