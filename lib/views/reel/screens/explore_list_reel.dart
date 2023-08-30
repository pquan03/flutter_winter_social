import 'package:flutter/material.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/reel/widgets/reel_card.dart';
import 'package:provider/provider.dart';

class ExploreListReelScreen extends StatefulWidget {
  final List<Reel> reels;
  final String accessToken;
  const ExploreListReelScreen(
      {super.key,
      required this.reels,
      required this.accessToken,
      });

  @override
  State<ExploreListReelScreen> createState() => _ExploreListReelScreenState();
}

class _ExploreListReelScreenState extends State<ExploreListReelScreen> {
  bool _isLoading = false;
  List<Reel> _reels = [];
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _reels = [...widget.reels];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleGetMorePosts() async {
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
  }
  

    void deleteReel(String reelId) async {
    final token = Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await ReelApi().deleteReel(reelId, token);
    if(res is String) {
      if(!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _reels.removeWhere((element) => element.sId == reelId);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    // final Auth auth = Provider.of<AuthProvider>(context).auth;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )
            ),
            SizedBox(width: 20,),
            Text('Reels', style: TextStyle(fontSize: 20),),
            Spacer(),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              )
            ),
          ],
        ), 
        backgroundColor: Colors.transparent, 
        elevation: 0.0,
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {},
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondary,
              ))
            : _reels.isEmpty
                ? Center(
                    child: Text(
                    'No Reels',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ))
                : PageView.builder(
                    controller: _pageController,
                    itemCount: _reels.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      return ReelCardWidget(
                        deleteReel: deleteReel,
                        reel: _reels[index],
                      );
                    },
                  ),
      ),
    );
  }
}
