import 'package:flutter/material.dart';
import 'package:insta_node_app/views/add/widgets/circular_add_post_button.dart';

class AddPostButton extends StatefulWidget {
  final Function(int) handleChangeType;
  const AddPostButton({super.key, required this.handleChangeType});

  @override
  State<AddPostButton> createState() => _AddPostButtonState();
}

class _AddPostButtonState extends State<AddPostButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation degOneTranslationAnimation,
      degTwoTranslationAnimation,
      degThreeTranslationAnimation;
  late Animation rotationAnimation;
  Map<String, dynamic> selected = {
    'text': 'Post',
    'icon': Icons.add_box_outlined,
    'color': Colors.orangeAccent,
  };
  final List<Map<String, dynamic>> listSelect = [
    {
      'text': 'Post',
      'icon': Icons.add_box_outlined,
      'color': Colors.orangeAccent,
    },
    {
      'icon': Icons.video_collection_outlined,
      'text': 'Reels',
      'color': Colors.blue,
    },
    {
      'text': 'Story',
      'icon': Icons.book_online_outlined,
      'color': Colors.black,
    },
  ];

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 250));
    degOneTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.2), weight: 75.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.2, end: 1.0), weight: 25.0),
    ]).animate(animationController);
    degTwoTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.4), weight: 55.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.4, end: 1.0), weight: 45.0),
    ]).animate(animationController);
    degThreeTranslationAnimation = TweenSequence([
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 0.0, end: 1.75), weight: 35.0),
      TweenSequenceItem<double>(
          tween: Tween<double>(begin: 1.75, end: 1.0), weight: 65.0),
    ]).animate(animationController);
    rotationAnimation = Tween<double>(begin: 180.0, end: 0.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 30,
        bottom: 30,
        child: Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            TapRegion(
              onTapOutside: (tap) {
                if (animationController.isCompleted) {
                  animationController.reverse();
                }
              },
              child: IgnorePointer(
                child: Container(
                  color: Colors.transparent,
                  height: 300.0,
                  width: 300.0,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset.fromDirection(getRadiansFromDegree(270),
                  degOneTranslationAnimation.value * 150),
              child: CircularButton(
                color: Colors.blue,
                width: 120,
                height: 50,
                text: 'Reels',
                icon: Icon(
                  Icons.video_collection_outlined,
                  color: Colors.white,
                ),
                onClick: () {
                  setState(() {
                    selected = listSelect[1];
                  });
                  widget.handleChangeType(2);
                },
              ),
            ),
            Transform.translate(
              offset: Offset.fromDirection(getRadiansFromDegree(215),
                  degTwoTranslationAnimation.value * 150),
              child: CircularButton(
                color: Colors.black,
                width: 120,
                height: 50,
                text: 'Story',
                icon: Icon(
                  Icons.book_online_outlined,
                  color: Colors.white,
                ),
                onClick: () {
                  setState(() {
                    selected = listSelect[2];
                  });
                  widget.handleChangeType(1);
                },
              ),
            ),
            Transform.translate(
              offset: Offset.fromDirection(getRadiansFromDegree(180),
                  degThreeTranslationAnimation.value * 150),
              child: CircularButton(
                color: Colors.orangeAccent,
                width: 120,
                height: 50,
                text: 'Post',
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                ),
                onClick: () {
                  setState(() {
                    selected = listSelect[0];
                  });
                  widget.handleChangeType(0);
                },
              ),
            ),
            CircularButton(
              color: selected['color'],
              width: 120,
              height: 50,
              icon: Icon(
                selected['icon'],
                color: Colors.white,
              ),
              text: selected['text'],
              onClick: () {
                if (animationController.isCompleted) {
                  animationController.reverse();
                } else {
                  animationController.forward();
                }
              },
            )
          ],
        ));
  }
}
