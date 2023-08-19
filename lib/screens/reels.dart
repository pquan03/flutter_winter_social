import 'package:flutter/material.dart';
import 'package:insta_node_app/models/reel.dart';
import 'package:insta_node_app/providers/auth_provider.dart';
import 'package:insta_node_app/recources/reel_api.dart';
import 'package:insta_node_app/utils/show_snack_bar.dart';
import 'package:insta_node_app/widgets/reel_card.dart';
import 'package:provider/provider.dart';

class ReelsScreen extends StatefulWidget {
  const ReelsScreen({super.key});

  @override
  State<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends State<ReelsScreen> {
  final PageController _pageController = PageController();
  bool _isMute = false;
  int _snappedPageIndex = 0;
  List<Reel> _reels = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    handleGetReels();
  }


  void handleGetReels() async {
    setState(() {
      _isLoading = true;
    });
    final token = Provider.of<AuthProvider>(context, listen: false).auth.accessToken!;
    final res = await ReelApi().getReels(token);
    if(res is List) {
      setState(() {
        _reels = [...res];
      });
    } else {
      if(!mounted) return;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () async {
          handleGetReels();
        },
        child: _isLoading ? Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondary,
          )
        ) : PageView.builder(
          onPageChanged: (int page) {
            setState(() {
              _snappedPageIndex = page;
            });
          },
          controller: _pageController,
          itemCount: _reels.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return ReelCardWidget(
              currentIndex: index,
              snappedPageIndex: _snappedPageIndex,
              handleMute: handleMute,
              isMute: _isMute,
              reel: _reels[index],
            );
          },
        ),
      ),
    );
  }
}
