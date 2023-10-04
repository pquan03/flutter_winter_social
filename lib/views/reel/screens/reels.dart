import 'package:flutter/material.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/views/add/screens/add_reel/media_gallery_reel.dart';
import 'package:insta_node_app/views/reel/widgets/reel_card.dart';
import 'package:provider/provider.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  bool _isMute = false;
  List<Reel> _reels = [];
  bool _isLoading = false;
  int page = 1;
  int limit = 9;

  @override
  void initState() {
    super.initState();
    handleGetReels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
          toolbarHeight: 50,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Text(
                'Reels',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              Spacer(),
              GestureDetector(
                  onTap: () {
                    if (!mounted) return;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const MediaGalleryReelScreen()));
                  },
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  )),
            ],
          )),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          handleGetReels();
        },
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
                    onPageChanged: (index) {
                      if (index == _reels.length - 1) {
                        setState(() {
                          page++;
                        });
                        handleGetReels();
                      }
                    },
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

  void handleGetReels() async {
    setState(() {
      _isLoading = true;
    });
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await ReelApi().getReels(token, page, limit);
    if (res is List) {
      setState(() {
        _reels = [..._reels, ...res];
      });
    } else {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void handleMute() {
    setState(() {
      _isMute = !_isMute;
    });
  }

  void deleteReel(String reelId) async {
    final token =
        Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await ReelApi().deleteReel(reelId, token);
    if (res is String) {
      if (!mounted) return;
      showSnackBar(context, 'Error', res);
    } else {
      setState(() {
        _reels.removeWhere((element) => element.sId == reelId);
      });
      final currentPage = _pageController.page!.toInt();
      if (currentPage > 0) {
        _pageController.jumpToPage(currentPage - 1);
      } else if (currentPage < _reels.length - 1) {
        _pageController.jumpToPage(currentPage + 1);
      }
    }
  }
}
